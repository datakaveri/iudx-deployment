package iudx.data.ingestion.server.authenticator;

import static iudx.data.ingestion.server.authenticator.Constants.API_ENDPOINT;
import static iudx.data.ingestion.server.authenticator.Constants.ID;
import static iudx.data.ingestion.server.authenticator.Constants.METHOD;
import static org.junit.jupiter.api.Assertions.assertEquals;

import io.micrometer.core.ipc.http.HttpSender.Method;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.auth.PubSecKeyOptions;
import io.vertx.ext.auth.jwt.JWTAuth;
import io.vertx.ext.auth.jwt.JWTAuthOptions;
import io.vertx.ext.web.client.WebClient;
import io.vertx.junit5.VertxExtension;
import io.vertx.junit5.VertxTestContext;
import iudx.data.ingestion.server.authenticator.authorization.Api;
import iudx.data.ingestion.server.authenticator.model.JwtData;
import iudx.data.ingestion.server.configuration.Configuration;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

@ExtendWith(VertxExtension.class)
public class JwtAuthServiceImplTest {

  private static final Logger LOGGER = LogManager.getLogger(JwtAuthServiceImplTest.class);
  private static JsonObject authConfig;
  private static JwtAuthenticationServiceImpl jwtAuthenticationService;
  private static Configuration config;
  private static String openId;
  private static String closeId;
  private static String invalidId;


  @BeforeAll
  @DisplayName("Initialize Vertx and deploy Auth Verticle")
  static void init(Vertx vertx, VertxTestContext testContext) {
    config = new Configuration();
    authConfig = config.configLoader(1, vertx);

    JWTAuthOptions jwtAuthOptions = new JWTAuthOptions();
    jwtAuthOptions.addPubSecKey(
        new PubSecKeyOptions()
            .setAlgorithm("ES256")
            .setBuffer("-----BEGIN PUBLIC KEY-----\n" +
                "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE8BKf2HZ3wt6wNf30SIsbyjYPkkTS\n" +
                "GGyyM2/MGF/zYTZV9Z28hHwvZgSfnbsrF36BBKnWszlOYW0AieyAUKaKdg==\n" +
                "-----END PUBLIC KEY-----\n" +
                ""));
    jwtAuthOptions.getJWTOptions()
        .setIgnoreExpiration(true);// ignore token expiration only for test
    JWTAuth jwtAuth = JWTAuth.create(vertx, jwtAuthOptions);

    WebClient webClient = AuthenticationVerticle.createWebClient(vertx, authConfig, true);
    jwtAuthenticationService =
        new JwtAuthenticationServiceImpl(vertx, jwtAuth, webClient, authConfig);

    // since test token doesn't contain valid id's, so forcibly put some dummy id in the cache for test.
    openId = "foobar.iudx.io";
    closeId = "example.com/79e7bfa62fad6c765bac69154c2f24c94c95220a/resource-group";

    invalidId = "example.com/79e7bfa62fad6c765bac69154c2f24c94c95220a/resource-group1";

    jwtAuthenticationService.resourceIdCache.put(openId, "OPEN");
    jwtAuthenticationService.resourceIdCache.put(closeId, "CLOSED");
    jwtAuthenticationService.resourceIdCache.put(invalidId, "CLOSED");

    LOGGER.info("Auth tests setup complete");
    testContext.completeNow();
  }


  @Test
  @DisplayName("Testing setup")
  public void shouldSucceed(VertxTestContext testContext) {
    LOGGER.info("Default test is passing");
    testContext.completeNow();
  }


  @Test
  @DisplayName("success - allow access to all open ingestion endpoints")
  public void allow4OpenIngestionEndpoint(VertxTestContext testContext) {
    JsonObject authInfo = new JsonObject();

    authInfo.put(ID, openId);
    authInfo.put(API_ENDPOINT, Api.INGESTION.getApiEndpoint());
    authInfo.put(METHOD, Method.POST);

    JwtData jwtData = new JwtData();
    jwtData.setIss("auth.test.com");
    jwtData.setAud("rs.iudx.io");
    jwtData.setExp(1627408865L);
    jwtData.setIat(1627408865L);
    jwtData.setIid("ri:foobar.iudx.io");
    jwtData.setRole("provider");
    jwtData.setCons(new JsonObject().put("access", new JsonArray().add("ingestion")));

    jwtAuthenticationService.validateAccess(jwtData, authInfo).onComplete(handler -> {
      if (handler.succeeded()) {
        testContext.completeNow();
      } else {
        testContext.failNow("invalid access");
      }
    });
  }

  @Test
  @DisplayName("success - allow access to all open api endpoints")
  public void allow4OpenApiEndpoint(VertxTestContext testContext) {
    JsonObject authInfo = new JsonObject();

    authInfo.put(ID, openId);
    authInfo.put(API_ENDPOINT, Api.ENTITIES.getApiEndpoint());
    authInfo.put(METHOD, Method.POST);

    JwtData jwtData = new JwtData();
    jwtData.setIss("auth.test.com");
    jwtData.setAud("rs.iudx.io");
    jwtData.setExp(1627408865L);
    jwtData.setIat(1627408865L);
    jwtData.setIid("ri:foobar.iudx.io");
    jwtData.setRole("provider");
    jwtData.setCons(new JsonObject().put("access", new JsonArray().add("api")));

    jwtAuthenticationService.validateAccess(jwtData, authInfo).onComplete(handler -> {
      if (handler.succeeded()) {
        testContext.completeNow();
      } else {
        testContext.failNow("invalid access");
      }
    });
  }

  @Test
  @DisplayName("success - allow access to closed ingestion-endpoint")
  public void allow4ClosedIngestionEndpoint(VertxTestContext testContext) {
    JsonObject authInfo = new JsonObject();
    authInfo.put("token", JwtTokenHelper.closedProviderIngestionToken);
    authInfo.put("id", closeId);
    authInfo.put("apiEndpoint", Api.INGESTION.getApiEndpoint());
    authInfo.put("method", Method.POST);

    JsonObject request = new JsonObject();

    jwtAuthenticationService.tokenIntrospect(request, authInfo, handler -> {
      if (handler.succeeded()) {
        testContext.completeNow();
      } else {
        testContext.failNow("invalid access");
      }
    });
  }

  @Test
  @DisplayName("success - allow access to closed api-endpoint")
  public void allow4ClosedApiEndpoint(VertxTestContext testContext) {
    JsonObject authInfo = new JsonObject();
    authInfo.put("token", JwtTokenHelper.closedProviderApiToken);
    authInfo.put("id", closeId);
    authInfo.put("apiEndpoint", Api.ENTITIES.getApiEndpoint());
    authInfo.put("method", Method.POST);

    JsonObject request = new JsonObject();

    jwtAuthenticationService.tokenIntrospect(request, authInfo, handler -> {
      if (handler.succeeded()) {
        testContext.completeNow();
      } else {
        testContext.failNow("invalid access");
      }
    });
  }

  @Test
  @DisplayName("success - disallow access to closed endpoint for different id")
  public void disallow4ClosedEndpoint(VertxTestContext testContext) {

    //failing because IsValidId commented in JwtAuthenticationServiceImpl line number 91.
    JsonObject authInfo = new JsonObject();

    authInfo.put("token", JwtTokenHelper.closedProviderApiToken);
    authInfo.put("id", invalidId);
    authInfo.put("apiEndpoint", Api.ENTITIES.getApiEndpoint());
    authInfo.put("method", Method.POST);
    JsonObject request = new JsonObject();

    jwtAuthenticationService.tokenIntrospect(request, authInfo, handler -> {
      if (handler.succeeded()) {
        testContext.failNow("invalid access");
      } else {
        testContext.completeNow();
      }
    });
  }


  @Test
  @DisplayName("success - allow delegate access to /entities endpoint")
  public void success4DelegateTokenEntitiesAPI(VertxTestContext testContext) {

    JsonObject request = new JsonObject();
    JsonObject authInfo = new JsonObject();


    authInfo.put("token", JwtTokenHelper.closedDelegateApiToken);
    authInfo.put("id", closeId);
    authInfo.put("apiEndpoint", Api.ENTITIES.getApiEndpoint());
    authInfo.put("method", Method.POST);

    jwtAuthenticationService.tokenIntrospect(request, authInfo, handler -> {
      if (handler.succeeded()) {
        testContext.completeNow();
      } else {
        testContext.failNow(handler.cause());
      }
    });
  }

  @Test
  @DisplayName("success - allow delegate access to /ingestion endpoint")
  public void success4DelegateTokenIngestionAPI(VertxTestContext testContext) {

    JsonObject request = new JsonObject();
    JsonObject authInfo = new JsonObject();


    authInfo.put("token", JwtTokenHelper.closedDelegateIngestionToken);
    authInfo.put("id", closeId);
    authInfo.put("apiEndpoint", Api.INGESTION.getApiEndpoint());
    authInfo.put("method", Method.POST);

    jwtAuthenticationService.tokenIntrospect(request, authInfo, handler -> {
      if (handler.succeeded()) {
        testContext.completeNow();
      } else {
        testContext.failNow(handler.cause());
      }
    });
  }

  @Test
  @DisplayName("decode valid jwt")
  public void decodeJwtProviderSuccess(VertxTestContext testContext) {
    jwtAuthenticationService.decodeJwt(JwtTokenHelper.closedProviderApiToken)
        .onComplete(handler -> {
          if (handler.succeeded()) {
            assertEquals("provider", handler.result().getRole());
            testContext.completeNow();
          } else {
            testContext.failNow(handler.cause());
          }
        });
  }

  @Test
  @DisplayName("decode valid jwt - delegate")
  public void decodeJwtDelegateSuccess(VertxTestContext testContext) {
    jwtAuthenticationService.decodeJwt(JwtTokenHelper.closedDelegateApiToken)
        .onComplete(handler -> {
          if (handler.succeeded()) {
            assertEquals("delegate", handler.result().getRole());
            testContext.completeNow();
          } else {
            testContext.failNow(handler.cause());
          }
        });
  }

  @Test
  @DisplayName("decode invalid jwt")
  public void decodeJwtFailure(VertxTestContext testContext) {
    String jwt =
        "eyJ0eXAiOiJKV1QiLCJbGciOiJFUzI1NiJ9.eyJzdWIiOiJhM2U3ZTM0Yy00NGJmLTQxZmYtYWQ4Ni0yZWUwNGE5NTQ0MTgiLCJpc3MiOiJhdXRoLnRlc3QuY29tIiwiYXVkIjoiZm9vYmFyLml1ZHguaW8iLCJleHAiOjE2Mjc2ODk5NDAsImlhdCI6MTYyNzY0Njc0MCwiaWlkIjoicmc6ZXhhbXBsZS5jb20vNzllN2JmYTYyZmFkNmM3NjViYWM2OTE1NGMyZjI0Yzk0Yzk1MjIwYS9yZXNvdXJjZS1ncm91cCIsInJvbGUiOiJkZWxlZ2F0ZSIsImNvbnMiOnt9fQ.eJjCUvWuGD3L3Dn2fKj8Ydl1byGoyRS59VfL6ZJcdKR3_eIhm6SOY-CW3p5XDSYVhRTlWvlPLjfXYo9t_PxgnA";
    jwtAuthenticationService.decodeJwt(jwt).onComplete(handler -> {
      if (handler.succeeded()) {
        testContext.failNow(handler.cause());
      } else {
        testContext.completeNow();

      }
    });
  }

  @Test
  @DisplayName("success - provider access to /entities endpoint for access [api]")
  public void access4ProviderTokenEntitiesPostAPI(VertxTestContext testContext) {

    JsonObject authInfo = new JsonObject();
    authInfo.put("token", JwtTokenHelper.closedProviderApiToken);
    authInfo.put("id", "example.com/79e7bfa62fad6c765bac69154c2f24c94c95220a/resource-group");
    authInfo.put("apiEndpoint", "/ngsi-ld/v1/entities");
    authInfo.put("method", "POST");

    JwtData jwtData = new JwtData();
    jwtData.setIss("auth.test.com");
    jwtData.setAud("rs.iudx.io");
    jwtData.setExp(1627408865L);
    jwtData.setIat(1627408865L);
    jwtData.setIid("rg:example.com/79e7bfa62fad6c765bac69154c2f24c94c95220a/resource-group");
    jwtData.setRole("provider");
    jwtData.setCons(new JsonObject().put("access", new JsonArray().add("api")));


    jwtAuthenticationService.validateAccess(jwtData, authInfo).onComplete(handler -> {
      if (handler.succeeded()) {
        testContext.completeNow();
      } else {
        LOGGER.debug("failed access ");
        testContext.failNow("failed for provider");

      }
    });
  }

  @Test
  @DisplayName("success - provider access to /entities endpoint for access [api]")
  public void access4ProviderTokenEntitiesDeleteAPI(VertxTestContext testContext) {

    JsonObject authInfo = new JsonObject();
    authInfo.put("token", JwtTokenHelper.closedProviderApiToken);
    authInfo.put("id", "example.com/79e7bfa62fad6c765bac69154c2f24c94c95220a/resource-group");
    authInfo.put("apiEndpoint", "/ngsi-ld/v1/entities");
    authInfo.put("method", "DELETE");

    JwtData jwtData = new JwtData();
    jwtData.setIss("auth.test.com");
    jwtData.setAud("rs.iudx.io");
    jwtData.setExp(1627408865L);
    jwtData.setIat(1627408865L);
    jwtData.setIid("rg:example.com/79e7bfa62fad6c765bac69154c2f24c94c95220a/resource-group");
    jwtData.setRole("provider");
    jwtData.setCons(new JsonObject().put("access", new JsonArray().add("api")));

    jwtAuthenticationService.validateAccess(jwtData, authInfo).onComplete(handler -> {
      if (handler.succeeded()) {
        testContext.completeNow();
      } else {
        LOGGER.debug("failed access ");
        testContext.failNow("failed for provider");

      }
    });
  }

  @Test
  @DisplayName("success - provider access to /ingestion endpoint for access [api]")
  public void access4ProviderTokenIngestionGetAPI(VertxTestContext testContext) {

    JsonObject authInfo = new JsonObject();

    authInfo.put("token", JwtTokenHelper.closedProviderIngestionToken);
    authInfo.put("id", "example.com/79e7bfa62fad6c765bac69154c2f24c94c95220a/resource-group");
    authInfo.put("apiEndpoint", "/ngsi-ld/v1/ingestion");
    authInfo.put("method", "GET");

    JwtData jwtData = new JwtData();
    jwtData.setIss("auth.test.com");
    jwtData.setAud("rs.iudx.io");
    jwtData.setExp(1628713148L);
    jwtData.setIat(1628669948L);
    jwtData.setIid("rg:example.com/79e7bfa62fad6c765bac69154c2f24c94c95220a/resource-group");
    jwtData.setRole("provider");
    jwtData.setCons(new JsonObject().put("access", new JsonArray().add("ingestion")));

    jwtAuthenticationService.validateAccess(jwtData, authInfo).onComplete(handler -> {
      if (handler.succeeded()) {
        testContext.completeNow();
        testContext.failNow("invalid access provided");
      } else {
        LOGGER.debug("failed access ");
        testContext.failNow("invalid access provided");
      }
    });
  }


  @Test
  @DisplayName("success - provider access to /ingestion endpoint for access [api]")
  public void access4ProviderTokenIngestionPostAPI(VertxTestContext testContext) {

    JsonObject authInfo = new JsonObject();
    authInfo.put("token", JwtTokenHelper.closedProviderIngestionToken);
    authInfo.put("id", "example.com/79e7bfa62fad6c765bac69154c2f24c94c95220a/resource-group");
    authInfo.put("apiEndpoint", "/ngsi-ld/v1/ingestion");
    authInfo.put("method", "POST");

    JwtData jwtData = new JwtData();
    jwtData.setIss("auth.test.com");
    jwtData.setAud("rs.iudx.io");
    jwtData.setExp(1627408865L);
    jwtData.setIat(1627408865L);
    jwtData.setIid("rg:example.com/79e7bfa62fad6c765bac69154c2f24c94c95220a/resource-group");
    jwtData.setRole("provider");
    jwtData.setCons(new JsonObject().put("access", new JsonArray().add("ingestion")));


    jwtAuthenticationService.validateAccess(jwtData, authInfo).onComplete(handler -> {
      if (handler.succeeded()) {
        testContext.completeNow();
      } else {
        LOGGER.debug("failed access ");
        testContext.failNow("failed for provider");

      }
    });
  }

  @Test
  @DisplayName("success - provider access to /ingestion endpoint for access [api]")
  public void access4ProviderTokenIngestionDeleteAPI(VertxTestContext testContext) {

    JsonObject authInfo = new JsonObject();
    authInfo.put("token", JwtTokenHelper.closedProviderIngestionToken);
    authInfo.put("id", "example.com/79e7bfa62fad6c765bac69154c2f24c94c95220a/resource-group");
    authInfo.put("apiEndpoint", "/ngsi-ld/v1/ingestion");
    authInfo.put("method", "DELETE");

    JwtData jwtData = new JwtData();
    jwtData.setIss("auth.test.com");
    jwtData.setAud("rs.iudx.io");
    jwtData.setExp(1627408865L);
    jwtData.setIat(1627408865L);
    jwtData.setIid("rg:example.com/79e7bfa62fad6c765bac69154c2f24c94c95220a/resource-group");
    jwtData.setRole("provider");
    jwtData.setCons(new JsonObject().put("access", new JsonArray().add("ingestion")));


    jwtAuthenticationService.validateAccess(jwtData, authInfo).onComplete(handler -> {
      if (handler.succeeded()) {
        testContext.completeNow();
      } else {
        LOGGER.debug("failed access ");
        testContext.failNow("failed for provider");
      }
    });
  }

  @Test
  @DisplayName("success - allow delegate access to /ingestion endpoint")
  public void allow4DelegateTokenIngestAPI(VertxTestContext testContext) {

    JsonObject request = new JsonObject();
    JsonObject authInfo = new JsonObject();

    authInfo.put("token", JwtTokenHelper.closedDelegateIngestionToken);
    authInfo.put("id", closeId);
    authInfo.put("apiEndpoint", Api.INGESTION.getApiEndpoint());
    authInfo.put("method", Method.POST);

    jwtAuthenticationService.tokenIntrospect(request, authInfo, handler -> {
      if (handler.succeeded()) {
        testContext.completeNow();
      } else {
        testContext.failNow(handler.cause());
      }
    });
  }


  @Test
  @DisplayName("success - allow provider access to /ingestion endpoint")
  public void closeProviderTokenIngestPostAPI(VertxTestContext testContext) {

    JsonObject request = new JsonObject();
    JsonObject authInfo = new JsonObject();

    authInfo.put("token", JwtTokenHelper.closedProviderIngestionToken);
    authInfo.put("id", closeId);
    authInfo.put("apiEndpoint", Api.INGESTION.getApiEndpoint());
    authInfo.put("method", Method.POST);

    jwtAuthenticationService.tokenIntrospect(request, authInfo, handler -> {
      if (handler.succeeded()) {
        testContext.completeNow();
      } else {
        testContext.failNow(handler.cause());
      }
    });
  }


  @Test
  @DisplayName("success - validId check")
  public void validIdCheck4JwtToken(VertxTestContext testContext) {
    JwtData jwtData = new JwtData();
    jwtData.setIss("auth.test.com");
    jwtData.setAud("rs.iudx.io");
    jwtData.setExp(1627408865L);
    jwtData.setIat(1627408865L);
    jwtData.setIid(
        "rg:datakaveri.org/04a15c9960ffda227e9546f3f46e629e1fe4132b/rs.iudx.io/pune-env-flood/FWR053");
    jwtData.setRole("provider");
    jwtData.setCons(new JsonObject().put("access", new JsonArray().add("ingest")));

    jwtAuthenticationService
        .isValidId(jwtData,
            "datakaveri.org/04a15c9960ffda227e9546f3f46e629e1fe4132b/rs.iudx.io/pune-env-flood/FWR053")
        .onComplete(handler -> {
          if (handler.succeeded()) {
            testContext.completeNow();
          } else {
            testContext.failNow("fail");
          }
        });
  }


  @Test
  @DisplayName("failure - invalid validId check")
  public void invalidIdCheck4JwtToken(VertxTestContext testContext) {
    JwtData jwtData = new JwtData();
    jwtData.setIss("auth.test.com");
    jwtData.setAud("rs.iudx.io");
    jwtData.setExp(1627408865L);
    jwtData.setIat(1627408865L);
    jwtData.setIid(
        "rg:datakaveri.org/04a15c9960ffda227e9546f3f46e629e1fe4132b/rs.iudx.io/pune-env-flood/FWR053");
    jwtData.setRole("provider");
    jwtData.setCons(new JsonObject().put("access", new JsonArray().add("ingest")));

    jwtAuthenticationService
        .isValidId(jwtData,
            "datakaveri.org/04a15c9960ffda227e9546f3f46e629e1fe4132b/rs.iudx.io/pune-env-flood/FWR055")
        .onComplete(handler -> {
          if (handler.succeeded()) {
            testContext.failNow("fail");
          } else {
            testContext.completeNow();
          }
        });
  }

  @Test
  @DisplayName("failure - invalid audience")
  public void invalidAudienceCheck(VertxTestContext testContext) {
    JwtData jwtData = new JwtData();
    jwtData.setIss("auth.test.com");
    jwtData.setAud("abc.iudx.io1");
    jwtData.setExp(1627408865L);
    jwtData.setIat(1627408865L);
    jwtData.setIid(
        "rg:datakaveri.org/04a15c9960ffda227e9546f3f46e629e1fe4132b/rs.iudx.io/pune-env-flood/FWR053");
    jwtData.setRole("provider");
    jwtData.setCons(new JsonObject().put("access", new JsonArray().add("ingest")));
    jwtAuthenticationService.isValidAudienceValue(jwtData).onComplete(handler -> {
      if (handler.failed()) {
        testContext.completeNow();
      } else {
        testContext.failNow("fail");

      }
    });
  }
}