package iudx.data.ingestion.server.metering;

import static iudx.data.ingestion.server.metering.util.Constants.FAILED;
import static iudx.data.ingestion.server.metering.util.Constants.MESSAGE;
import static iudx.data.ingestion.server.metering.util.Constants.QUERY_KEY;
import static iudx.data.ingestion.server.metering.util.Constants.SUCCESS;

import io.vertx.core.AsyncResult;
import io.vertx.core.Future;
import io.vertx.core.Handler;
import io.vertx.core.Promise;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonObject;
import io.vertx.pgclient.PgConnectOptions;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.PoolOptions;
import iudx.data.ingestion.server.metering.util.QueryBuilder;
import iudx.data.ingestion.server.metering.util.ResponseBuilder;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class MeteringServiceImpl implements MeteringService {

  private static final Logger LOGGER = LogManager.getLogger(MeteringServiceImpl.class);
  private final Vertx vertx;
  private final QueryBuilder queryBuilder = new QueryBuilder();
  PgConnectOptions connectOptions;
  PoolOptions poolOptions;
  PgPool pool;
  private JsonObject query = new JsonObject();
  private String databaseIP;
  private int databasePort;
  private String databaseName;
  private String databaseUserName;
  private String databasePassword;
  private int databasePoolSize;
  private ResponseBuilder responseBuilder;

  public MeteringServiceImpl(JsonObject propObj, Vertx vertxInstance) {

    if (propObj != null && !propObj.isEmpty()) {
      databaseIP = propObj.getString("meteringDatabaseIP");
      databasePort = propObj.getInteger("meteringDatabasePort");
      databaseName = propObj.getString("meteringDatabaseName");
      databaseUserName = propObj.getString("meteringDatabaseUserName");
      databasePassword = propObj.getString("meteringDatabasePassword");
      databasePoolSize = propObj.getInteger("meteringPoolSize");
    }

    this.connectOptions =
        new PgConnectOptions()
            .setPort(databasePort)
            .setHost(databaseIP)
            .setDatabase(databaseName)
            .setUser(databaseUserName)
            .setPassword(databasePassword)
            .setReconnectAttempts(2)
            .setReconnectInterval(1000);

    this.poolOptions = new PoolOptions().setMaxSize(databasePoolSize);
    this.pool = PgPool.pool(vertxInstance, connectOptions, poolOptions);
    this.vertx = vertxInstance;
  }

  @Override
  public MeteringService executeWriteQuery(
      JsonObject request, Handler<AsyncResult<JsonObject>> handler) {

    query = queryBuilder.buildWritingQuery(request);
    Future<JsonObject> result = writeInDatabase(query);
    result.onComplete(
        resultHandler -> {
          if (resultHandler.succeeded()) {
            handler.handle(Future.succeededFuture(resultHandler.result()));
          } else if (resultHandler.failed()) {
            LOGGER.error("failed ::" + resultHandler.cause());
            handler.handle(Future.failedFuture(resultHandler.cause().getMessage()));
          }
        });
    return this;
  }

  private Future<JsonObject> writeInDatabase(JsonObject query) {
    Promise<JsonObject> promise = Promise.promise();
    JsonObject response = new JsonObject();

    pool.withConnection(connection -> connection.query(query.getString(QUERY_KEY)).execute())
        .onComplete(
            rows -> {
              if (rows.succeeded()) {
                response.put(MESSAGE, "Table Updated Successfully");
                responseBuilder =
                    new ResponseBuilder(SUCCESS)
                        .setTypeAndTitle(200)
                        .setMessage(response.getString(MESSAGE));
                LOGGER.debug("Info: " + responseBuilder.getResponse().toString());
                promise.complete(responseBuilder.getResponse());
              }
              if (rows.failed()) {
                LOGGER.error("Info: failed :" + rows.cause());
                response.put(MESSAGE, rows.cause().getMessage());
                responseBuilder =
                    new ResponseBuilder(FAILED)
                        .setTypeAndTitle(400)
                        .setMessage(response.getString(MESSAGE));
                LOGGER.debug("Info: " + responseBuilder.getResponse().toString());
                promise.fail(responseBuilder.getResponse().toString());
              }
            });
    return promise.future();
  }
}
