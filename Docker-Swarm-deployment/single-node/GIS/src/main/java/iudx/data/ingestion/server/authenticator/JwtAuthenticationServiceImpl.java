package iudx.data.ingestion.server.authenticator;

import static iudx.data.ingestion.server.authenticator.Constants.API_ENDPOINT;
import static iudx.data.ingestion.server.authenticator.Constants.CAT_HOST;
import static iudx.data.ingestion.server.authenticator.Constants.CAT_SERVER_HOST;
import static iudx.data.ingestion.server.authenticator.Constants.CAT_SERVER_PORT;
import static iudx.data.ingestion.server.authenticator.Constants.ID;
import static iudx.data.ingestion.server.authenticator.Constants.JSON_DELEGATE;
import static iudx.data.ingestion.server.authenticator.Constants.JSON_IID;
import static iudx.data.ingestion.server.authenticator.Constants.JSON_PROVIDER;
import static iudx.data.ingestion.server.authenticator.Constants.JSON_USERID;
import static iudx.data.ingestion.server.authenticator.Constants.METHOD;
import static iudx.data.ingestion.server.authenticator.Constants.TOKEN;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import io.vertx.core.AsyncResult;
import io.vertx.core.Future;
import io.vertx.core.Handler;
import io.vertx.core.Promise;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.auth.authentication.TokenCredentials;
import io.vertx.ext.auth.jwt.JWTAuth;
import io.vertx.ext.web.client.WebClient;
import io.vertx.ext.web.client.WebClientOptions;
import iudx.data.ingestion.server.authenticator.authorization.Api;
import iudx.data.ingestion.server.authenticator.authorization.AuthorizationContextFactory;
import iudx.data.ingestion.server.authenticator.authorization.AuthorizationRequest;
import iudx.data.ingestion.server.authenticator.authorization.AuthorizationStrategy;
import iudx.data.ingestion.server.authenticator.authorization.JwtAuthorization;
import iudx.data.ingestion.server.authenticator.authorization.Method;
import iudx.data.ingestion.server.authenticator.model.JwtData;
import java.util.concurrent.TimeUnit;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class JwtAuthenticationServiceImpl implements AuthenticationService {

  private static final Logger LOGGER = LogManager.getLogger(JwtAuthenticationServiceImpl.class);
  // resourceIdCache will contain info about resources available(& their ACL) in ingestion server.
  public final Cache<String, String> resourceIdCache = CacheBuilder.newBuilder().maximumSize(1000)
      .expireAfterAccess(Constants.CACHE_TIMEOUT_AMOUNT, TimeUnit.MINUTES).build();
  final JWTAuth jwtAuth;
  final WebClient catWebClient;
  final String host;
  final int port;
  final String path;
  final String audience;
  // resourceGroupCache will contain ACL info about all resource group in ingestion server
  private final Cache<String, String> resourceGroupCache =
      CacheBuilder.newBuilder().maximumSize(1000)
          .expireAfterAccess(Constants.CACHE_TIMEOUT_AMOUNT, TimeUnit.MINUTES).build();

  public JwtAuthenticationServiceImpl(Vertx vertx, final JWTAuth jwtAuth, final WebClient webClient,
      final JsonObject config) {
    this.jwtAuth = jwtAuth;
    this.audience = config.getString(CAT_HOST);
    host = config.getString(CAT_SERVER_HOST);
    port = config.getInteger(CAT_SERVER_PORT);
    path = Constants.CAT_RSG_PATH;
    WebClientOptions options = new WebClientOptions();
    options.setTrustAll(true).setVerifyHost(false).setSsl(true);
    catWebClient = WebClient.create(vertx, options);
  }

  @Override
  public AuthenticationService tokenIntrospect(JsonObject request, JsonObject authenticationInfo,
      Handler<AsyncResult<JsonObject>> handler) {

    String endPoint = authenticationInfo.getString(API_ENDPOINT);
    String id = authenticationInfo.getString(ID);
    String token = authenticationInfo.getString(TOKEN);

    Future<JwtData> jwtDecodeFuture = decodeJwt(token);
    // stop moving forward if jwtDecode is a failure.

    ResultContainer result = new ResultContainer();
    jwtDecodeFuture.compose(decodeHandler -> {
      result.jwtData = decodeHandler;
      return isValidAudienceValue(result.jwtData);
    }).compose(audienceHandler -> {

      return isValidId(result.jwtData, id);
      // uncomment above line once you get a valid JWT token. and delete below line

      // return Future.succeededFuture(true);
    }).compose(validIdHandler -> validateAccess(result.jwtData, authenticationInfo))
        .onComplete(completeHandler -> {
          if (completeHandler.succeeded()) {
            LOGGER.debug("Completion handler");
            handler.handle(Future.succeededFuture(completeHandler.result()));
          } else {
            LOGGER.debug("Failure handler");
            LOGGER.error("error : " + completeHandler.cause().getMessage());
            handler.handle(Future.failedFuture(completeHandler.cause().getMessage()));
          }
        });
    return this;
  }

  public Future<JwtData> decodeJwt(String jwtToken) {
    Promise<JwtData> promise = Promise.promise();

    // jwtToken =
    // "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJzdWIiOiIzNDliNGI1NS0wMjUxLTQ5MGUtYmVlOS0wMGYzYTVkM2U2NDMiLCJpc3MiOiJhdXRoLnRlc3QuY29tIiwiYXVkIjoiZm9vYmFyLml1ZHguaW8iLCJleHAiOjE2MjU5NDUxMTQsImlhdCI6MTYyNTkwMTkxNCwiaWlkIjoicmc6ZXhhbXBsZS5jb20vOGQ0YjIwZWM0YmYyMWVmYjM2M2U3MjY3MWUxYjViZDc3ZmQ2Y2Y5MS9yZXNvdXJjZS1ncm91cCIsInJvbGUiOiJjb25zdW1lciIsImNvbnMiOnt9fQ.44MehPzbPBgAFWz7k3CSF2b-wHBQktGVJVk-unDLnO3_SrbClyQ3k42PgD7TFKB9H13rqBegr7vI0C4BShZbAw";

    TokenCredentials creds = new TokenCredentials(jwtToken);

    jwtAuth.authenticate(creds).onSuccess(user -> {
      JwtData jwtData = new JwtData(user.principal());
      promise.complete(jwtData);
    }).onFailure(err -> {
      LOGGER.error("failed to decode/validate jwt token : " + err.getMessage());
      promise.fail("failed");
    });

    return promise.future();
  }

  public Future<JsonObject> validateAccess(JwtData jwtData, JsonObject authInfo) {
    LOGGER.info("validateAccess() started");
    Promise<JsonObject> promise = Promise.promise();
    String jwtId = jwtData.getIid().split(":")[1];

    Method method = Method.valueOf(authInfo.getString(METHOD));
    Api api = Api.fromEndpoint(authInfo.getString(API_ENDPOINT));
    AuthorizationRequest authRequest = new AuthorizationRequest(method, api);
    AuthorizationStrategy authStrategy = AuthorizationContextFactory.create(jwtData.getRole());
    LOGGER.info("strategy : " + authStrategy.getClass().getSimpleName());
    JwtAuthorization jwtAuthStrategy = new JwtAuthorization(authStrategy);
    LOGGER.info("endPoint : " + authInfo.getString(API_ENDPOINT));
    if (jwtAuthStrategy.isAuthorized(authRequest, jwtData)) {
      JsonObject jsonResponse = new JsonObject();
      jsonResponse.put(JSON_IID,jwtId);
      jsonResponse.put(JSON_USERID, jwtData.getSub());
      if (jwtData.getRole().equalsIgnoreCase(JSON_PROVIDER)) {
        jsonResponse.put(JSON_PROVIDER, jwtData.getSub());
      } else if (jwtData.getRole().equalsIgnoreCase(JSON_DELEGATE)) {
        jsonResponse.put(JSON_DELEGATE, jwtData.getSub());
      }
      promise.complete(jsonResponse);
    } else {
      LOGGER.info("failed");
      JsonObject result = new JsonObject().put("401", "no access provided to endpoint");
      promise.fail(result.toString());
    }
    return promise.future();
  }

  public Future<Boolean> isValidAudienceValue(JwtData jwtData) {
    Promise<Boolean> promise = Promise.promise();

    if (audience != null && audience.equalsIgnoreCase(jwtData.getAud())) {
      promise.complete(true);
    } else {
      LOGGER.error("Incorrect audience value in jwt");
      promise.fail("Incorrect audience value in jwt");
    }
    return promise.future();
  }

  public Future<Boolean> isValidId(JwtData jwtData, String id) {
    Promise<Boolean> promise = Promise.promise();
    String jwtId = jwtData.getIid().split(":")[1];
    LOGGER.info("JWT ID" + jwtId);
    LOGGER.info("ID " + id);
    if (id.equalsIgnoreCase(jwtId)) {
      promise.complete(true);
    } else if (id.equalsIgnoreCase(jwtId)) {
      promise.complete(true);
    } else {
      LOGGER.error("Incorrect id value in jwt");
      promise.fail("Incorrect id value in jwt");
    }
    return promise.future();
  }

  // class to contain intermediate data for token introspection
  final class ResultContainer {
    JwtData jwtData;
    boolean isResourceExist;

  }


}
