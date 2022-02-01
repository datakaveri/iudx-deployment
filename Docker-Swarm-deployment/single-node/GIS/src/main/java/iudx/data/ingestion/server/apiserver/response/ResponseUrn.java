package iudx.data.ingestion.server.apiserver.response;

import java.util.stream.Stream;

public enum ResponseUrn {

  SUCCESS_URN("urn:dx:rs:success", "successful operations"),
  SUCCESS("urn:dx:rs:success", "success"),
  INVALID_PARAM("urn:dx:rs:invalidParameter", "Invalid parameter passed"),
  INVALID_OPERATION("urn:dx:rs:invalidOperation", "Invalid operation"),
  UNAUTHORIZED_ENDPOINT("urn:dx:rs:unauthorizedEndpoint", "Access to endpoint is not available"),
  UNAUTHORIZED_RESOURCE("urn,dx:rs:unauthorizedResource", "Access to resource is not available"),
  EXPIRED_TOKEN("urn:dx:rs:expiredAuthorizationToken", "Token has expired"),
  MISSING_TOKEN("urn:dx:rs:missingAuthorizationToken", "Token needed and not present"),
  INVALID_TOKEN("urn:dx:rs:invalidAuthorizationToken", "Token is invalid"),
  RESOURCE_NOT_FOUND("urn:dx:rs:resourceNotFound", "Document of given id does not exist"),
  BAD_REQUEST("urn:dx:rs:badRequest","Bad request"),


  LIMIT_EXCEED("urn:dx:rs:requestLimitExceeded", "Operation exceeds the default value of limit"),


  // extra urn
  INVALID_ID_VALUE("urn:dx:rs:invalidIdValue", "Invalid id"),
  INVALID_PAYLOAD_FORMAT("urn:dx:rs:invalidPayloadFormat",
      "Invalid json format in post request [schema mismatch]"),
  INVALID_PARAM_VALUE("urn:dx:rs:invalidParameterValue", "Invalid parameter value passed"),
  INVALID_QUEUE_VALUE("urn:dx:rs:invalidQueueValue", "Invalid Queue value passed"),
  BAD_REQUEST_URN("urn:dx:rs:badRequest","bad request parameter"),
  BACKING_SERVICE_FORMAT("urn:dx:rs:backend", "format error from backing service [cat,auth etc.]"),
  SCHEMA_READ_ERROR("urn:dx:rs:readError", "Fail to read file"),
  YET_NOT_IMPLEMENTED("urn:dx:rs:general", "urn yet not implemented in backend verticle.");


  private final String urn;
  private final String message;

  ResponseUrn(String urn, String message) {
    this.urn = urn;
    this.message = message;
  }

  public static ResponseUrn fromCode(final String urn) {
    return Stream.of(values())
        .filter(v -> v.urn.equalsIgnoreCase(urn))
        .findAny()
        .orElse(YET_NOT_IMPLEMENTED); // if backend service dont respond with urn
  }

  public String getUrn() {
    return urn;
  }

  public String getMessage() {
    return message;
  }

  public String toString() {
    return "[" + urn + " : " + message + " ]";
  }

}
