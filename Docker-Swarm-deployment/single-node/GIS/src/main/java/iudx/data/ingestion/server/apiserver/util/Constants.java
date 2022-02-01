package iudx.data.ingestion.server.apiserver.util;

import java.util.List;
import java.util.regex.Pattern;

public class Constants {

  // date-time format
  public static final String API_ENDPOINT = "apiEndpoint";
  public static final String API_METHOD = "method";
  public static final String ID = "id";


  // NGSI-LD endpoints
  public static final String NGSILD_BASE_PATH = "/ngsi-ld/v1";
  public static final String NGSILD_ENTITIES_URL = NGSILD_BASE_PATH + "/entities";
  // path regex
  public static final String ENTITIES_URL_REGEX = NGSILD_ENTITIES_URL + "(.*)";
  public static final String NGSILD_INGESTION_URL = NGSILD_BASE_PATH + "/ingestion";
  public static final String INGESTION_URL_REGEX = NGSILD_INGESTION_URL + "(.*)";

  // ngsi-ld/IUDX query parameters
  public static final String NGSILD_QUERY_ID = "id";
  public static final String QUEUE = "queue";
  public static final String USER_ID = "userid";
  public static final String EXPIRY = "expiry";
  public static final String IID = "iid";
  public static final String API = "api";

  // Header params
  public static final String HEADER_TOKEN = "token";
  public static final String HEADER_HOST = "Host";
  public static final String HEADER_ACCEPT = "Accept";
  public static final String HEADER_CONTENT_LENGTH = "Content-Length";
  public static final String HEADER_CONTENT_TYPE = "Content-Type";
  public static final String HEADER_ORIGIN = "Origin";
  public static final String HEADER_REFERER = "Referer";
  public static final String HEADER_ALLOW_ORIGIN = "Access-Control-Allow-Origin";

  // request/response params
  public static final String CONTENT_TYPE = "content-type";
  public static final String APPLICATION_JSON = "application/json";

  // json fields
  public static final String JSON_TYPE = "type";
  public static final String JSON_TITLE = "title";
  public static final String JSON_DETAIL = "detail";

  /** API Documentation endpoint */
  public static final String ROUTE_STATIC_SPEC = "/apis/spec";
  public static final String ROUTE_DOC = "/apis";

  /** Accept Headers and CORS */
  public static final String MIME_APPLICATION_JSON = "application/json";
  public static final String MIME_TEXT_HTML = "text/html";

  // messages (Error, Exception, messages..)
  public static final String MSG_BAD_QUERY = "Bad query";

  // Validations
  public static final int VALIDATION_ID_MAX_LEN = 512;
  public static final Pattern VALIDATION_ID_PATTERN = Pattern.compile(
      "^[a-zA-Z0-9.]{4,100}/{1}[a-zA-Z0-9.]{4,100}/{1}[a-zA-Z.]{4,100}/{1}[a-zA-Z-_.]{4,100}/{1}[a-zA-Z0-9-_.]{4,100}$");
  public static final Pattern VALIDATION_QUEUE_PATTERN =
      Pattern.compile(
          "^[a-zA-Z0-9. _ \\/]{4,100}$");

}
