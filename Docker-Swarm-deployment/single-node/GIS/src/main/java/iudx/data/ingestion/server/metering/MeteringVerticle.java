package iudx.data.ingestion.server.metering;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.eventbus.MessageConsumer;
import io.vertx.core.json.JsonObject;
import io.vertx.serviceproxy.ServiceBinder;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class MeteringVerticle extends AbstractVerticle {

  private static final String METERING_SERVICE_ADDRESS = "iudx.data.ingestion.metering.service";
  private static final Logger LOGGER = LogManager.getLogger(MeteringVerticle.class);
  private String databaseIP;
  private int databasePort;
  private String databaseName;
  private String databaseUserName;
  private String databasePassword;
  private int poolSize;
  private ServiceBinder binder;
  private MessageConsumer<JsonObject> consumer;
  private MeteringService metering;

  @Override
  public void start() throws Exception {

    databaseIP = config().getString("meteringDatabaseIP");
    databasePort = config().getInteger("meteringDatabasePort");
    databaseName = config().getString("meteringDatabaseName");
    databaseUserName = config().getString("meteringDatabaseUserName");
    databasePassword = config().getString("meteringDatabasePassword");
    poolSize = config().getInteger("meteringPoolSize");

    JsonObject propObj = new JsonObject();
    propObj.put("meteringDatabaseIP", databaseIP);
    propObj.put("meteringDatabasePort", databasePort);
    propObj.put("meteringDatabaseName", databaseName);
    propObj.put("meteringDatabaseUserName", databaseUserName);
    propObj.put("meteringDatabasePassword", databasePassword);
    propObj.put("meteringPoolSize", poolSize);

    binder = new ServiceBinder(vertx);
    metering = new MeteringServiceImpl(propObj, vertx);
    consumer =
        binder.setAddress(METERING_SERVICE_ADDRESS).register(MeteringService.class, metering);
    LOGGER.info("Metering Verticle Started");
  }

  @Override
  public void stop() {
    binder.unregister(consumer);
  }
}
