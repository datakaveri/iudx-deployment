package iudx.data.ingestion.server.databroker;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import io.vertx.core.AsyncResult;
import io.vertx.core.Future;
import io.vertx.core.Handler;
import io.vertx.core.json.JsonObject;
import io.vertx.rabbitmq.RabbitMQClient;
import iudx.data.ingestion.server.databroker.util.Util;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.concurrent.TimeUnit;

import static iudx.data.ingestion.server.databroker.util.Constants.*;

public class DataBrokerServiceImpl implements DataBrokerService {

  private static final Logger LOGGER = LogManager.getLogger(DataBrokerServiceImpl.class);
  private final RabbitClient rabbitClient;
  private final String databrokerVhost;
  private final Cache<String, Boolean> exchangeListCache = CacheBuilder.newBuilder().maximumSize(1000)
      .expireAfterAccess(CACHE_TIMEOUT_AMOUNT, TimeUnit.MINUTES).build();

  public DataBrokerServiceImpl(RabbitMQClient client, RabbitWebClient rabbitWebClient, String vHost) {
    this.rabbitClient = new RabbitClient(client, rabbitWebClient);
    this.databrokerVhost = vHost;

    rabbitClient.populateExchangeCache(databrokerVhost, exchangeListCache);
  }

  @Override
  public DataBrokerService publishData(JsonObject request, Handler<AsyncResult<JsonObject>> handler) {
    // TODO Auto-generated method stub
    LOGGER.debug("Info : DataBrokerServiceImpl#publishData() started");
    if (request != null && !request.isEmpty()) {
      JsonObject metaData = Util.getMetadata(request);
      String exchange = metaData.getString(EXCHANGE_NAME);
      Boolean doesExchangeExist = exchangeListCache.getIfPresent(exchange);
      rabbitClient.getExchange(exchange, databrokerVhost, doesExchangeExist)
          .compose(ar -> {
            Boolean exchangeFound = ar.getBoolean(DOES_EXCHANGE_EXIST);
            if (!exchangeFound) {
              return Future.failedFuture("Bad Request: Resource ID does not exist");
            }
            exchangeListCache.put(exchange, true);
            return rabbitClient.publishMessage(request, metaData);
          })
          .onSuccess(ar -> {
            LOGGER.debug("Message published Successfully");
            handler.handle(Future.succeededFuture(new JsonObject().put(TYPE, SUCCESS)));
          })
          .onFailure(ar -> {
            LOGGER.fatal(ar);
            handler.handle(Future.succeededFuture(new JsonObject()
                .put(TYPE, FAILURE)
                .put(ERROR_MESSAGE, ar.getLocalizedMessage())
            ));
          });
    } else {
      handler.handle(Future.succeededFuture(new JsonObject()
          .put(TYPE, FAILURE)
          .put(ERROR_MESSAGE, "Bad Request: Request Json empty")
      ));
    }
    return this;
  }

  @Override
  public DataBrokerService ingestDataPost(JsonObject request, Handler<AsyncResult<JsonObject>> handler) {
    LOGGER.debug("Info : DataBrokerServiceImpl#ingestData() started");
    if (request != null && !request.isEmpty()) {
      JsonObject object = new JsonObject()
          .put(ERROR, null);
      JsonObject metaData = Util.getMetadata(request);
      String exchangeName = metaData.getString(EXCHANGE_NAME);
      rabbitClient.getQueue(request, databrokerVhost)
          .compose(ar -> {
            LOGGER.debug("Info: Get queue successful");
            object.mergeIn(metaData)
                .put(QUEUE_NAME, ar.getString(QUEUE_NAME))
                .put(ERROR, "Exchange creation failed");
            return rabbitClient.createExchange(exchangeName, databrokerVhost);
          })
          .compose(ar -> {
            LOGGER.debug("Info: Exchange creation successful");
            object.put(ERROR, "Queue binding failed");
            exchangeListCache.put(exchangeName, true);
            return rabbitClient.bindQueue(object, databrokerVhost);
          })
          .onSuccess(ar -> {
            LOGGER.debug("Info: Queue binding successful");
            LOGGER.debug("Ingest data operation successful");
            handler.handle(Future.succeededFuture(new JsonObject()
                .put(TYPE, SUCCESS)
                .put(EXCHANGE_NAME, exchangeName)
                .put(QUEUE_NAME, object.getString(QUEUE_NAME))
                .put(ROUTING_KEY, object.getString(ROUTING_KEY))
            ));
          })
          .onFailure(ar -> {
            LOGGER.error("Error: {}", object.getString(ERROR));
            LOGGER.fatal("Error: Ingest data operation failed due to {}",
                ar.getCause().toString());
            handler.handle(Future.failedFuture(ar.getCause()));
          });
    }
    return this;
  }

  @Override
  public DataBrokerService ingestDataDelete(JsonObject request, Handler<AsyncResult<JsonObject>> handler) {
    LOGGER.debug("Info: DataBrokerServiceImpl#ingestDataDelete() started");
    if (request != null && !request.isEmpty()) {
      JsonObject metaData = Util.getMetadata(request);
      String exchangeName = metaData.getString(EXCHANGE_NAME);
      rabbitClient.deleteExchange(exchangeName, databrokerVhost)
          .onSuccess(ar -> {
            LOGGER.debug("Deletion of exchange successful");
            exchangeListCache.invalidate(exchangeName);
            handler.handle(Future.succeededFuture(new JsonObject().mergeIn(ar)));
          })
          .onFailure(ar -> {
            LOGGER.debug("Could not delete exchange due to: {}", ar.getCause().toString());
            handler.handle(Future.succeededFuture(new JsonObject()
                .put(TYPE, FAILURE)
                .put(ERROR_MESSAGE, ar.getCause().getLocalizedMessage())
            ));
          });
    } else {
      handler.handle(Future.succeededFuture(new JsonObject()
          .put(TYPE, FAILURE)
          .put(ERROR_MESSAGE, "Bad Request: Request Json empty")
      ));
    }
    return this;
  }
}
