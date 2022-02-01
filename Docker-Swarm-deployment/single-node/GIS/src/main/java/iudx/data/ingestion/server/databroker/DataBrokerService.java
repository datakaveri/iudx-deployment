package iudx.data.ingestion.server.databroker;

import io.vertx.codegen.annotations.Fluent;
import io.vertx.codegen.annotations.GenIgnore;
import io.vertx.codegen.annotations.ProxyGen;
import io.vertx.codegen.annotations.VertxGen;
import io.vertx.core.AsyncResult;
import io.vertx.core.Handler;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonObject;

/**
 * The Data Broker Service.
 * <h1>Data Broker Service</h1>
 * <p>
 * The Data Broker Service in the IUDX Resource Server defines the operations to
 * be performed with the IUDX Data Broker server.
 * </p>
 *
 * @version 1.0
 * @see io.vertx.codegen.annotations.ProxyGen
 * @see io.vertx.codegen.annotations.VertxGen
 * @since 2020-05-31
 */

@VertxGen
@ProxyGen
public interface DataBrokerService {

  /**
   * The ingestDataPost implements the registration of adaptor functionality with the data
   * broker.
   *
   * @param request which is a JsonObject
   * @param handler which is a Request Handler
   * @return DataBrokerService which is a Service
   **/
  @Fluent
  DataBrokerService ingestDataPost(JsonObject request, Handler<AsyncResult<JsonObject>> handler);

  /**
   * The ingestDataDelete implements the deletion of exchange
   * broker.
   *
   * @param request which is a JsonObject
   * @param handler which is a Request Handler
   * @return DataBrokerService which is a Service
   **/
  @Fluent
  DataBrokerService ingestDataDelete(JsonObject request, Handler<AsyncResult<JsonObject>> handler);

  /**
   * The publishData implements the publish data functionality with the data
   * broker.
   *
   * @param request which is a JsonObject
   * @param handler which is a Request Handler
   * @return DataBrokerService which is a Service
   **/
  @Fluent
  DataBrokerService publishData(JsonObject request, Handler<AsyncResult<JsonObject>> handler);

  @GenIgnore
  static DataBrokerService createProxy(Vertx vertx, String address) {
    return new DataBrokerServiceVertxEBProxy(vertx, address);
  }
}
