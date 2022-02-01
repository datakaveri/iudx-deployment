package iudx.data.ingestion.server.databroker.util;

public class Constants {
  public static final String REQUEST_GET = "GET";
  public static final String REQUEST_POST = "POST";
  public static final String REQUEST_PUT = "PUT";
  public static final String REQUEST_DELETE = "DELETE";

  public static final String TYPE = "type";
  public static final String FAILURE = "failure";
  public static final String SUCCESS = "success";
  public static final String TITLE = "title";
  public static final String DETAIL = "detail";
  public static final String NAME = "name";

  public static final String DOES_EXCHANGE_EXIST = "does_exchange_exist";
  public static final String ERROR_MESSAGE = "error_message";
  public static final String EXCHANGE_NAME = "exchangeName";
  public static final String EXCHANGE_URL = "exchangeUrl";

  public static final String ROUTING_KEY = "routingKey";
  public static final String ROUTING_KEY_ALL = ".*";

  public static final String USERNAME = "userName";
  public static final String PASSWORD = "password";

  public static final int CACHE_TIMEOUT_AMOUNT = 30;

  public static final String ALLOW = ".*";
  public static final String WRITE = "write";
  public static final String READ = "read";
  public static final String CONFIGURE = "configure";
  public static final String DENY = "";

  public static final String EXCHANGE_EXISTS = "Exchange already exists";
  public static final String EXCHANGE_EXISTS_WITH_DIFFERENT_PROPERTIES =
      "Exchange already exists with different properties";
  public static final String EXCHANGE_DELETE_ERROR = "Deletion of Exchange failed";
  public static final String EXCHANGE_CREATE_ERROR = "Creation of Exchange failed";
  public static final String EXCHANGE = "exchange";
  public static final String EXCHANGE_NOT_FOUND = "Exchange not found";
  public static final String EXCHANGE_TYPE = "topic";
  public static final String AUTO_DELETE = "auto_delete";
  public static final String DURABLE = "durable";

  public static final String X_MESSAGE_TTL_NAME = "x-message-ttl";
  public static final String X_MAXLENGTH_NAME = "x-max-length";
  public static final String X_QUEUE_MODE_NAME = "x-queue-mode";
  public static final long X_MESSAGE_TTL_VALUE = 86400000; // 24hours
  public static final int X_MAXLENGTH_VALUE = 10000;
  public static final String X_QUEUE_MODE_VALUE = "lazy";
  public static final String X_QUEUE_TYPE = "durable";
  public static final String X_QUEUE_ARGUMENTS = "arguments";

  public static final String ERROR = "error";

  public static final String TOPIC_PERMISSION = "topic_permissions";
  public static final String TOPIC_PERMISSION_SET_SUCCESS = "topic permission set";
  public static final String TOPIC_PERMISSION_ALREADY_SET = "topic permission already set";
  public static final String TOPIC_PERMISSION_SET_ERROR = "Error in setting Topic permissions";
  public static final String TAGS = "tags";

  public static final String QUEUE = "queue";
  public static final String QUEUE_FOUND = "Queue Found";
  public static final String QUEUE_NOT_FOUND = "Queue not Found";
  public static final String QUEUE_NAME = "queueName";
  public static final String DEFAULT_QUEUE = "database";
  public static final String QUEUE_ALREADY_EXISTS = "Queue already exists";
  public static final String QUEUE_ALREADY_EXISTS_WITH_DIFFERENT_PROPERTIES =
      "Queue already exists with different properties";
  public static final String QUEUE_DOES_NOT_EXISTS = "Queue does not exist";
  public static final String QUEUE_CREATE_ERROR = "Creation of Queue failed";
  public static final String QUEUE_DELETE_ERROR = "Deletion of Queue failed";
}
