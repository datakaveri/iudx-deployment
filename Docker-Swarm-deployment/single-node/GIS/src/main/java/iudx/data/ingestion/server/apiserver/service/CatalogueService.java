package iudx.data.ingestion.server.apiserver.service;

import static iudx.data.ingestion.server.apiserver.util.Util.toList;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import io.vertx.core.Future;
import io.vertx.core.Promise;
import io.vertx.core.Vertx;
import io.vertx.core.buffer.Buffer;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.client.HttpResponse;
import io.vertx.ext.web.client.WebClient;
import io.vertx.ext.web.client.WebClientOptions;
import io.vertx.ext.web.client.predicate.ResponsePredicate;
import iudx.data.ingestion.server.authenticator.Constants;
import java.util.List;
import java.util.concurrent.TimeUnit;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * catalogue service to fetch calatogue items and groups for the purpose of cache
 */
public class CatalogueService {

  private static final Logger LOGGER = LogManager.getLogger(CatalogueService.class);
  private static String catHost;
  private static int catPort;
  private static String catSearchPath;
  private static String catItemPath;
  private final Cache<String, List<String>> applicableFilterCache =
      CacheBuilder.newBuilder().maximumSize(1000)
          .expireAfterAccess(Constants.CACHE_TIMEOUT_AMOUNT, TimeUnit.MINUTES).build();
  private WebClient catWebClient;
  private long cacheTimerid;
  private Vertx vertx;

  public CatalogueService(Vertx vertx, JsonObject config) {
    this.vertx = vertx;
    catHost = config.getString("catServerHost");
    catPort = config.getInteger("catServerPort");
    catSearchPath = Constants.CAT_RSG_PATH;
    catItemPath = Constants.CAT_ITEM_PATH;

    WebClientOptions options =
        new WebClientOptions().setTrustAll(true).setVerifyHost(false).setSsl(true);
    catWebClient = WebClient.create(vertx, options);
    populateCache();
    cacheTimerid = vertx.setPeriodic(TimeUnit.DAYS.toMillis(1), handler -> {
      populateCache();
    });
  }

  /**
   * populate
   *
   * @return
   */
  private Future<Boolean> populateCache() {
    Promise<Boolean> promise = Promise.promise();
    catWebClient.get(catPort, catHost, catSearchPath)
        .addQueryParam("property", "[iudxResourceAPIs]")
        .addQueryParam("value", "[[TEMPORAL,ATTR,SPATIAL]]")
        .addQueryParam("filter", "[iudxResourceAPIs,id]").expect(ResponsePredicate.JSON)
        .send(handler -> {
          if (handler.succeeded()) {
            JsonArray response = handler.result().bodyAsJsonObject().getJsonArray("results");
            response.forEach(json -> {
              JsonObject res = (JsonObject) json;
              String id = res.getString("id");
              String[] idArray = id.split("/");
              if (idArray.length == 4) {
                applicableFilterCache.put(id + "/*", toList(res.getJsonArray("iudxResourceAPIs")));
              } else {
                applicableFilterCache.put(id, toList(res.getJsonArray("iudxResourceAPIs")));
              }
            });
            promise.complete(true);
          } else if (handler.failed()) {
            promise.fail(handler.cause());
          }
        });
    return promise.future();
  }

  public Future<Boolean> isItemExist(String id) {
    LOGGER.debug("isItemExist() started");
    Promise<Boolean> promise = Promise.promise();
    LOGGER.info("id : " + id);
    catWebClient.get(catPort, catHost, catItemPath).addQueryParam("id", id)
        .expect(ResponsePredicate.JSON).send(responseHandler -> {
          if (responseHandler.succeeded()) {
            HttpResponse<Buffer> response = responseHandler.result();
            JsonObject responseBody = response.bodyAsJsonObject();
            if (responseBody.getString("type").equalsIgnoreCase("urn:dx:cat:Success")
                && responseBody.getInteger("totalHits") > 0) {
              LOGGER.info("ID exist.");
              promise.complete(responseHandler.succeeded());
            } else {
              LOGGER.error("Error :" + responseHandler.cause());
              promise.fail(responseHandler.cause());
            }
          } else {
            LOGGER.error("Error :" + responseHandler.cause());
            promise.fail(responseHandler.cause());
          }
        });
    return promise.future();
  }

}
