package iudx.data.ingestion.server.apiserver.handlers;

import static iudx.data.ingestion.server.apiserver.response.ResponseUrn.INVALID_TOKEN;
import static iudx.data.ingestion.server.apiserver.response.ResponseUrn.RESOURCE_NOT_FOUND;
import static iudx.data.ingestion.server.apiserver.util.Constants.API_ENDPOINT;
import static iudx.data.ingestion.server.apiserver.util.Constants.API_METHOD;
import static iudx.data.ingestion.server.apiserver.util.Constants.APPLICATION_JSON;
import static iudx.data.ingestion.server.apiserver.util.Constants.CONTENT_TYPE;
import static iudx.data.ingestion.server.apiserver.util.Constants.ENTITIES_URL_REGEX;
import static iudx.data.ingestion.server.apiserver.util.Constants.HEADER_TOKEN;
import static iudx.data.ingestion.server.apiserver.util.Constants.ID;
import static iudx.data.ingestion.server.apiserver.util.Constants.IID;
import static iudx.data.ingestion.server.apiserver.util.Constants.INGESTION_URL_REGEX;
import static iudx.data.ingestion.server.apiserver.util.Constants.NGSILD_INGESTION_URL;
import static iudx.data.ingestion.server.apiserver.util.Constants.JSON_DETAIL;
import static iudx.data.ingestion.server.apiserver.util.Constants.JSON_TITLE;
import static iudx.data.ingestion.server.apiserver.util.Constants.JSON_TYPE;
import static iudx.data.ingestion.server.apiserver.util.Constants.NGSILD_ENTITIES_URL;
import static iudx.data.ingestion.server.apiserver.util.Constants.USER_ID;

import io.vertx.core.Handler;
import io.vertx.core.Vertx;
import io.vertx.core.http.HttpServerRequest;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import iudx.data.ingestion.server.apiserver.response.ResponseUrn;
import iudx.data.ingestion.server.apiserver.util.HttpStatusCode;
import iudx.data.ingestion.server.authenticator.AuthenticationService;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * IUDX Authentication handler to authenticate token passed in HEADER
 */
public class AuthHandler implements Handler<RoutingContext> {

  private static final Logger LOGGER = LogManager.getLogger(AuthHandler.class);
  private static final String AUTH_SERVICE_ADDRESS = "iudx.data.ingestion.authentication.service";
  private static AuthenticationService authenticator;
  private final String AUTH_INFO = "authInfo";
  private HttpServerRequest request;

  public static AuthHandler create(Vertx vertx) {
    authenticator = AuthenticationService.createProxy(vertx, AUTH_SERVICE_ADDRESS);
    return new AuthHandler();
  }

  @Override
  public void handle(RoutingContext context) {
    request = context.request();
    JsonObject requestJson = context.getBodyAsJson();

    if (requestJson == null) {
      requestJson = new JsonObject();
    }

    LOGGER.debug("Info : path " + request.path());

    String token = request.headers().get(HEADER_TOKEN);
    final String path = getNormalizedPath(request.path());
    final String method = context.request().method().toString();

    String paramId = getIdFromRequest();
    LOGGER.info("id from param : " + paramId);
    String bodyId = getIdFromBody(context);
    LOGGER.info("id from body : " + bodyId);

    String id;
    if (paramId != null && !paramId.isBlank()) {
      id = paramId;
    } else {
      id = bodyId;
    }
    LOGGER.info("id : " + id);

    JsonObject authInfo =
        new JsonObject().put(API_ENDPOINT, path).put(HEADER_TOKEN, token).put(API_METHOD, method)
            .put(ID, id);

    authenticator.tokenIntrospect(requestJson, authInfo, authHandler -> {

      if (authHandler.succeeded()) {
        authInfo.put(IID, authHandler.result().getValue(IID));
        authInfo.put(USER_ID, authHandler.result().getValue(USER_ID));
        context.data().put(AUTH_INFO, authInfo);
      } else {
        processAuthFailure(context, authHandler.cause().getMessage());
        return;
      }
      context.next();
      return;
    });
  }


  private String getIdFromRequest() {
    return request.getParam(ID);
  }

  private void processAuthFailure(RoutingContext ctx, String result) {
    LOGGER.debug("RESULT " + result);
    if (result.contains("Not Found")) {
      LOGGER.error("Error : Item Not Found");
      HttpStatusCode statusCode = HttpStatusCode.getByValue(404);
      ctx.response()
          .putHeader(CONTENT_TYPE, APPLICATION_JSON)
          .setStatusCode(statusCode.getValue())
          .end(generateResponse(RESOURCE_NOT_FOUND, statusCode).toString());
    } else {
      LOGGER.error("Error : Authentication Failure");
      HttpStatusCode statusCode = HttpStatusCode.getByValue(401);
      ctx.response()
          .putHeader(CONTENT_TYPE, APPLICATION_JSON)
          .setStatusCode(statusCode.getValue())
          .end(generateResponse(INVALID_TOKEN, statusCode).toString());
    }
  }

  private JsonObject generateResponse(ResponseUrn urn, HttpStatusCode statusCode) {
    return new JsonObject()
        .put(JSON_TYPE, urn.getUrn())
        .put(JSON_TITLE, statusCode.getDescription())
        .put(JSON_DETAIL, statusCode.getDescription());
  }

  private String getIdFromBody(RoutingContext context) {
    JsonObject body = context.getBodyAsJson();
    return body.getString(ID);
  }

  /**
   * get normalized path without id as path param.
   *
   * @param url complete path from request
   * @return path without id.
   */
  private String getNormalizedPath(String url) {
    LOGGER.debug("URL : " + url);
    String path = null;
    if (url.matches(ENTITIES_URL_REGEX)) {
      path = NGSILD_ENTITIES_URL;
    } else if (url.matches(INGESTION_URL_REGEX)) {
      path = NGSILD_INGESTION_URL;
    }
    return path;
  }
}
