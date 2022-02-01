package iudx.data.ingestion.server.databroker;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.eventbus.MessageConsumer;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.client.WebClientOptions;
import io.vertx.rabbitmq.RabbitMQClient;
import io.vertx.rabbitmq.RabbitMQOptions;
import io.vertx.serviceproxy.ServiceBinder;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import static iudx.data.ingestion.server.databroker.util.Constants.*;

public class DataBrokerVerticle extends AbstractVerticle {

  private static final String BROKER_SERVICE_ADDRESS = "iudx.data.ingestion.broker.service";
  private static final Logger LOGGER = LogManager.getLogger(DataBrokerVerticle.class);
  private DataBrokerService databroker;
  private RabbitMQOptions config;
  private RabbitMQClient client;
  private String dataBrokerIP;
  private int dataBrokerPort;
  private int dataBrokerManagementPort;
  private String dataBrokerVhost;
  private String dataBrokerUserName;
  private String dataBrokerPassword;
  private int connectionTimeout;
  private int requestedHeartbeat;
  private int handshakeTimeout;
  private int requestedChannelMax;
  private int networkRecoveryInterval;
  private ServiceBinder binder;
  private MessageConsumer<JsonObject> consumer;
  private RabbitWebClient rabbitWebClient;
  private WebClientOptions webConfig;

  @Override
  public void start() throws Exception {

    /* Read the configuration and set the rabbitMQ server properties. */
    dataBrokerIP = config().getString("dataBrokerIP");
    dataBrokerPort = config().getInteger("dataBrokerPort");
    dataBrokerManagementPort = config().getInteger("dataBrokerManagementPort");
    dataBrokerVhost = config().getString("dataBrokerVhost");
    dataBrokerUserName = config().getString("dataBrokerUserName");
    dataBrokerPassword = config().getString("dataBrokerPassword");
    connectionTimeout = config().getInteger("connectionTimeout");
    requestedHeartbeat = config().getInteger("requestedHeartbeat");
    handshakeTimeout = config().getInteger("handshakeTimeout");
    requestedChannelMax = config().getInteger("requestedChannelMax");
    networkRecoveryInterval = config().getInteger("networkRecoveryInterval");

    /* Configure the RabbitMQ Data Broker client with input from config files. */

    config = new RabbitMQOptions()
        .setUser(dataBrokerUserName)
        .setPassword(dataBrokerPassword)
        .setHost(dataBrokerIP)
        .setPort(dataBrokerPort)
        .setVirtualHost(dataBrokerVhost)
        .setConnectionTimeout(connectionTimeout)
        .setRequestedHeartbeat(requestedHeartbeat)
        .setHandshakeTimeout(handshakeTimeout)
        .setRequestedChannelMax(requestedChannelMax)
        .setNetworkRecoveryInterval(networkRecoveryInterval)
        .setAutomaticRecoveryEnabled(true);

    webConfig = new WebClientOptions()
        .setKeepAlive(true)
        .setConnectTimeout(86400000)
        .setDefaultHost(dataBrokerIP)
        .setDefaultPort(dataBrokerManagementPort)
        .setKeepAliveTimeout(86400000);

    JsonObject webClientProperties = new JsonObject()
        .put(USERNAME, dataBrokerUserName)
        .put(PASSWORD, dataBrokerPassword);
    /*
     * Create a RabbitMQ Client with the configuration and vertx cluster instance.
     */

    client = RabbitMQClient.create(vertx, config);

    rabbitWebClient = new RabbitWebClient(vertx, webConfig, webClientProperties);

    binder = new ServiceBinder(vertx);
    databroker = new DataBrokerServiceImpl(client, rabbitWebClient, dataBrokerVhost);

    /* Publish the Data Broker service with the Event Bus against an address. */

    consumer = binder.setAddress(BROKER_SERVICE_ADDRESS).register(DataBrokerService.class, databroker);
  }

  @Override
  public void stop() {
    binder.unregister(consumer);
  }

}
