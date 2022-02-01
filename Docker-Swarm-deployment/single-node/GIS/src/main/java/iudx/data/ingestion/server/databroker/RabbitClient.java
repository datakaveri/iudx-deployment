package iudx.data.ingestion.server.databroker;

import com.google.common.cache.Cache;
import io.vertx.core.Future;
import io.vertx.core.Promise;
import io.vertx.core.buffer.Buffer;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.client.HttpResponse;
import io.vertx.rabbitmq.RabbitMQClient;
import iudx.data.ingestion.server.databroker.util.Util;
import org.apache.http.HttpStatus;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.Optional;

import static iudx.data.ingestion.server.databroker.util.Constants.*;

public class RabbitClient {

  private static final Logger LOGGER = LogManager.getLogger(RabbitClient.class);

  private final RabbitMQClient client;
  private final RabbitWebClient rabbitWebClient;

  public RabbitClient(RabbitMQClient rabbitmqClient, RabbitWebClient rabbitWebClient) {
    this.client = rabbitmqClient;
    this.rabbitWebClient = rabbitWebClient;

    client.start(clientStartupHandler -> {
      if (clientStartupHandler.succeeded()) {
        LOGGER.debug("Info : rabbit MQ client started");
      } else if (clientStartupHandler.failed()) {
        LOGGER.fatal("Fail : rabbit MQ client startup failed.");
      }
    });
  }

  public Future<JsonObject> publishMessage(JsonObject request, JsonObject metaData) {
    Promise<JsonObject> promise = Promise.promise();
    String exchangeName = metaData.getString(EXCHANGE_NAME);
    String routingKey = metaData.getString(ROUTING_KEY);
    JsonObject response = new JsonObject();
    LOGGER.debug("Sending message to exchange: {}, with routing key: {}", exchangeName, routingKey);
    client.basicPublish(exchangeName, routingKey, request.toBuffer(),
        asyncResult -> {
          if (asyncResult.succeeded()) {
            promise.complete(response);
          } else {
            promise.fail(asyncResult.cause());
          }
        });
    return promise.future();
  }

  public Future<JsonObject> publishMessage(JsonObject request) {
    JsonObject metaData = Util.getMetadata(request);
    String exchangeName = metaData.getString(EXCHANGE_NAME);
    String routingKey = metaData.getString(ROUTING_KEY);
    Promise<JsonObject> promise = Promise.promise();
    JsonObject response = new JsonObject();
    LOGGER.debug("Sending message to exchange: {}, with routing key: {}", exchangeName, routingKey);
    client.basicPublish(exchangeName, routingKey, request.toBuffer(),
        asyncResult -> {
          if (asyncResult.succeeded()) {
            promise.complete(response);
          } else {
            promise.fail(asyncResult.cause());
          }
        });
    return promise.future();
  }

  public Future<Boolean> populateExchangeCache(String vHost, Cache<String, Boolean> exchangeListCache) {
    Promise<Boolean> promise = Promise.promise();
    String url = "/api/exchanges/" + vHost;
    rabbitWebClient.requestAsync(REQUEST_GET, url)
        .onSuccess(ar -> {
          JsonArray response = ar.bodyAsJsonArray();
          response.forEach(json -> {
            JsonObject exchange = (JsonObject) json;
            String exchangeName = exchange.getString(NAME);
            if (!exchangeName.isEmpty()) {
              LOGGER.debug("Adding {} exchange into cache", exchangeName);
              exchangeListCache.put(exchangeName, true);
            }
          });
        })
        .onFailure(ar -> {
          LOGGER.fatal(ar.getCause());
        });
    promise.complete(true);
    return promise.future();
  }

  public Future<JsonObject> getExchange(String exchange, String vHost, Boolean doesExchangeExist) {
    LOGGER.debug("INFO: Getting exchange: {} from vHost: {}", exchange, vHost);
    Promise<JsonObject> promise = Promise.promise();
    JsonObject response = new JsonObject();
    if (doesExchangeExist == null) {
      LOGGER.debug("INFO: Cache miss");
      fetchExchange(exchange, vHost)
          .onSuccess(promise::complete)
          .onFailure(ar -> promise.fail(ar.getCause()));
    } else {
      LOGGER.debug("INFO: Cache hit");
      response.put(DOES_EXCHANGE_EXIST, doesExchangeExist);
      promise.complete(response);
    }
    return promise.future();
  }

  public Future<JsonObject> getQueue(JsonObject request, String vHost) {
    JsonObject response = new JsonObject();
    Promise<JsonObject> promise = Promise.promise();
    Optional<String> queueOptional = Optional.ofNullable(request.getString("queue"));
    if (queueOptional.isPresent()) {
      String queueName = queueOptional.get();
      getQueue(queueName, vHost)
          .onComplete(asyncResult -> {
            if (asyncResult.succeeded()) {
              response.put(TITLE, SUCCESS)
                  .put(QUEUE_NAME, queueName);
              Integer status = asyncResult.result().getInteger(TYPE);
              if (status == HttpStatus.SC_NOT_FOUND) {
                createQueue(queueName, vHost)
                    .onSuccess(ar -> promise.complete(response))
                    .onFailure(promise::fail);
              } else if (status == HttpStatus.SC_OK) {
                promise.complete(response);
              } else {
                promise.fail(asyncResult.cause());
              }
              LOGGER.debug("Info: Queue {} found for the request", queueName);
            } else {
              promise.fail(asyncResult.cause());
            }
          });
    } else {
      response.put(TITLE, SUCCESS)
          .put(QUEUE_NAME, DEFAULT_QUEUE);
      LOGGER.debug("Info: Queue {} found for the request", DEFAULT_QUEUE);
      promise.complete(response);
    }
    return promise.future();
  }

  public Future<JsonObject> getQueue(String queue, String vHost) {
    JsonObject response = new JsonObject();
    Promise<JsonObject> promise = Promise.promise();
    String url = "/api/queues/" + vHost + "/" + Util.encodeString(queue);
    rabbitWebClient.requestAsync(REQUEST_GET, url).onComplete(asyncResult -> {
      if (asyncResult.succeeded()) {
        int status = asyncResult.result().statusCode();
        response.put(TYPE, status);
        if (status == HttpStatus.SC_OK) {
          response.put(TITLE, SUCCESS);
          response.put(DETAIL, QUEUE_FOUND);
        } else if (status == HttpStatus.SC_NOT_FOUND) {
          response.put(TITLE, FAILURE);
          response.put(DETAIL, QUEUE_NOT_FOUND);
        } else {
          response.put("getQueue_status", status);
          promise.fail("getQueue_status" + asyncResult.cause());
        }
      } else {
        response.put("getQueue_error", asyncResult.cause());
        promise.fail("getQueue_error" + asyncResult.cause());
      }
      LOGGER.debug("getQueue method response : " + response);
      promise.complete(response);
    });
    return promise.future();
  }

  public Future<JsonObject> createQueue(String queueName, String vHost) {
    JsonObject finalResponse = new JsonObject();
    Promise<JsonObject> promise = Promise.promise();
    LOGGER.debug("Info: Creating queue {} for the request", queueName);
    String url = "/api/queues/" + vHost + "/" + Util.encodeString(queueName);
    JsonObject arguments = new JsonObject()
        .put(X_MESSAGE_TTL_NAME, X_MESSAGE_TTL_VALUE)
        .put(X_MAXLENGTH_NAME, X_MAXLENGTH_VALUE)
        .put(X_QUEUE_MODE_NAME, X_QUEUE_MODE_VALUE);
    JsonObject configProp = new JsonObject()
        .put(X_QUEUE_TYPE, true)
        .put(X_QUEUE_ARGUMENTS, arguments);
    rabbitWebClient.requestAsync(REQUEST_PUT, url, configProp).onComplete(ar -> {
      if (ar.succeeded()) {
        HttpResponse<Buffer> response = ar.result();
        if (response != null && !response.equals(" ")) {
          int status = response.statusCode();
          if (status == HttpStatus.SC_CREATED) {
            finalResponse.put(QUEUE_NAME, queueName);
          } else if (status == HttpStatus.SC_NO_CONTENT) {
            finalResponse.mergeIn(
                Util.getResponseJson(HttpStatus.SC_CONFLICT, FAILURE, QUEUE_ALREADY_EXISTS),
                true);
          } else if (status == HttpStatus.SC_BAD_REQUEST) {
            finalResponse.mergeIn(Util.getResponseJson(status, FAILURE,
                QUEUE_ALREADY_EXISTS_WITH_DIFFERENT_PROPERTIES), true);
          }
        }
        promise.complete(finalResponse);
        LOGGER.info("Success : Queue created ");
      } else {
        LOGGER.error("Fail : Creation of Queue failed - " + ar.cause());
        finalResponse.mergeIn(Util.getResponseJson(500, FAILURE, QUEUE_CREATE_ERROR));
        promise.fail(finalResponse.toString());
      }
    });
    return promise.future();
  }

  public Future<JsonObject> createExchange(String exchangeName, String vHost) {
    Promise<JsonObject> promise = Promise.promise();
    String url = "/api/exchanges/" + vHost + "/" + Util.encodeString(exchangeName);
    JsonObject exchangeProperties = new JsonObject();
    exchangeProperties
        .put(TYPE, EXCHANGE_TYPE)
        .put(AUTO_DELETE, false)
        .put(DURABLE, true);
    rabbitWebClient.requestAsync(REQUEST_PUT, url, exchangeProperties).onComplete(result -> {
      if (result.succeeded()) {
        JsonObject responseJson = new JsonObject();
        HttpResponse<Buffer> response = result.result();
        LOGGER.debug("Exchange creation response: {}", response.bodyAsJsonObject());
        int statusCode = response.statusCode();
        if (statusCode == HttpStatus.SC_CREATED) {
          responseJson.put(EXCHANGE, exchangeName);
        } else if (statusCode == HttpStatus.SC_NO_CONTENT) {
          responseJson = Util.getResponseJson(HttpStatus.SC_CONFLICT, FAILURE, EXCHANGE_EXISTS);
        } else if (statusCode == HttpStatus.SC_BAD_REQUEST) {
          responseJson = Util.getResponseJson(statusCode, FAILURE,
              EXCHANGE_EXISTS_WITH_DIFFERENT_PROPERTIES);
        }
        LOGGER.debug("Exchange Created Successfully with result: " + responseJson);
        promise.complete(responseJson);
      } else {
        JsonObject errorJson = Util.getResponseJson(HttpStatus.SC_INTERNAL_SERVER_ERROR, ERROR,
            EXCHANGE_CREATE_ERROR);
        LOGGER.error("Failure in exchange creation due to: " + result.cause());
        promise.fail(errorJson.toString());
      }
    });
    return promise.future();
  }

  public Future<JsonObject> bindQueue(JsonObject request, String vHost) {
    JsonObject response = new JsonObject();
    Promise<JsonObject> promise = Promise.promise();
    String exchangeName = Util.encodeString(request.getString(EXCHANGE_NAME));
    String queueName = Util.encodeString(request.getString(QUEUE_NAME));
    String routingKey = request.getString(ROUTING_KEY);
    String url =
        "/api/bindings/" + vHost + "/e/" + exchangeName + "/q/" + queueName;
    JsonObject bindRequest = new JsonObject()
        .put("routing_key", routingKey);

    rabbitWebClient.requestAsync(REQUEST_POST, url, bindRequest).onComplete(handler -> {
      if (handler.succeeded()) {
        response.put(TYPE, SUCCESS);
        promise.complete(response);
      } else {
        promise.fail(handler.cause());
      }
    });

    return promise.future();
  }

  public Future<JsonObject> setTopicPermissions(JsonObject request, String vHost, String userID) {
    Promise<JsonObject> promise = Promise.promise();
    JsonObject response = new JsonObject();
    String exchangeName = request.getString(EXCHANGE_NAME);
    String url = "/api/permissions/" + vHost + "/" + Util.encodeString(userID);
    JsonObject permissionRequest = new JsonObject();
    permissionRequest.put(EXCHANGE, exchangeName);
    permissionRequest.put(WRITE, ALLOW);
    permissionRequest.put(READ, DENY);
    permissionRequest.put(CONFIGURE, DENY);

    rabbitWebClient.requestAsync(REQUEST_PUT, url, permissionRequest).onComplete(result -> {
      if (result.succeeded()) {
        if (result.result().statusCode() == HttpStatus.SC_CREATED) {
          response.mergeIn(
              Util.getResponseJson(
                  HttpStatus.SC_OK,
                  TOPIC_PERMISSION,
                  TOPIC_PERMISSION_SET_SUCCESS
              ));
          LOGGER.debug("Success : Topic permission set");
          promise.complete(response);
        } else if (result.result()
            .statusCode() == HttpStatus.SC_NO_CONTENT) { /* Check if request was already served */
          response.mergeIn(
              Util.getResponseJson(
                  HttpStatus.SC_OK,
                  TOPIC_PERMISSION,
                  TOPIC_PERMISSION_ALREADY_SET
              ));
          promise.complete(response);
        } else { /* Check if request has an error */
          LOGGER.error(
              "Error : error in setting topic permissions" + result.result().statusMessage());
          response.mergeIn(
              Util.getResponseJson(
                  HttpStatus.SC_INTERNAL_SERVER_ERROR,
                  TOPIC_PERMISSION,
                  TOPIC_PERMISSION_SET_ERROR
              ));
          promise.fail(response.toString());
        }
      } else { /* Check if request has an error */
        LOGGER.error("Error : error in setting topic permission : " + result.cause());
        response.mergeIn(
            Util.getResponseJson(
                HttpStatus.SC_INTERNAL_SERVER_ERROR,
                TOPIC_PERMISSION,
                TOPIC_PERMISSION_SET_ERROR
            ));
        promise.fail(response.toString());
      }
    });
    return promise.future();
  }

  public Future<JsonObject> deleteExchange(String exchangeName, String vHost) {
    LOGGER.debug("Info : RabbitClient#deleteExchange() started");
    Promise<JsonObject> promise = Promise.promise();
    String url = "/api/exchanges/" + vHost + "/" + Util.encodeString(exchangeName);
    rabbitWebClient.requestAsync(REQUEST_DELETE, url).onComplete(requestHandler -> {
      JsonObject responseJson = new JsonObject();
      if (requestHandler.succeeded()) {
        HttpResponse<Buffer> response = requestHandler.result();
        int statusCode = response.statusCode();
        if (statusCode == HttpStatus.SC_NO_CONTENT) {
          responseJson.put(EXCHANGE, exchangeName);
        } else {
          responseJson = Util.getResponseJson(statusCode, FAILURE, EXCHANGE_NOT_FOUND);
          LOGGER.debug("Delete Exchange final Response: {}", responseJson);
        }
        promise.complete(responseJson);
      } else {
        JsonObject errorJson = Util.getResponseJson(HttpStatus.SC_INTERNAL_SERVER_ERROR, ERROR,
            EXCHANGE_DELETE_ERROR);
        LOGGER.error("Error : " + requestHandler.cause());
        promise.fail(errorJson.toString());
      }
    });
    return promise.future();
  }

  public Future<JsonObject> deleteQueue(String queueName, String vhost) {
    LOGGER.debug("Info : RabbitClient#deleteQueue() started");
    Promise<JsonObject> promise = Promise.promise();
    JsonObject finalResponse = new JsonObject();
    LOGGER.debug("Deleting queue: {}", queueName);
    String url = "/api/queues/" + vhost + "/" + Util.encodeString(queueName);
    rabbitWebClient.requestAsync(REQUEST_DELETE, url).onComplete(ar -> {
      if (ar.succeeded()) {
        HttpResponse<Buffer> response = ar.result();
        if (response != null && !response.equals(" ")) {
          int status = response.statusCode();
          if (status == HttpStatus.SC_NO_CONTENT) {
            finalResponse.put(QUEUE, queueName);
          } else if (status == HttpStatus.SC_NOT_FOUND) {
            finalResponse.mergeIn(Util.getResponseJson(status, FAILURE, QUEUE_DOES_NOT_EXISTS));
          }
        }
        LOGGER.info(finalResponse);
        promise.complete(finalResponse);
      } else {
        LOGGER.error("Fail : deletion of queue failed - " + ar.cause());
        finalResponse.mergeIn(Util.getResponseJson(500, FAILURE, QUEUE_DELETE_ERROR));
        promise.fail(finalResponse.toString());
      }
    });
    return promise.future();
  }

  private Future<JsonObject> fetchExchange(String exchangeName, String vHost) {
    LOGGER.debug("INFO: Fetching Exchange: {} from vHost: {}", exchangeName, vHost);
    Promise<JsonObject> promise = Promise.promise();
    JsonObject result = new JsonObject();
    String exchangeUrl = Util.encodeString(exchangeName);
    String url = "/api/exchanges/" + vHost + "/" + exchangeUrl;
    rabbitWebClient.requestAsync(REQUEST_GET, url)
        .onComplete(ar -> {
          if (ar.succeeded()) {
            if (ar.result().statusCode() == HttpStatus.SC_OK) {
              LOGGER.debug("Given exchange exists");
              result.put(DOES_EXCHANGE_EXIST, true);
            } else {
              LOGGER.debug("Given exchange does not exists");
              result.put(DOES_EXCHANGE_EXIST, false);
            }
            promise.complete(result);
          } else {
            promise.fail(ar.cause());
          }
        });
    return promise.future();
  }
}
