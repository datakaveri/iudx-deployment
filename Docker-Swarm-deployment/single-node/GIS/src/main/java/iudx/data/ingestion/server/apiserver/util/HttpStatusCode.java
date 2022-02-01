package iudx.data.ingestion.server.apiserver.util;

public enum HttpStatusCode {

  BAD_REQUEST(400, "Bad Request"),
  RESOURCE_NOT_FOUND(404, "Resource not in Catalogue."),
  INVALID_TOKEN(401, "Unauthorized");


  private final int value;
  private final String description;

  HttpStatusCode(int value, String description) {
    this.value = value;
    this.description = description;
  }

  public static HttpStatusCode getByValue(int value) {
    for (HttpStatusCode status : values()) {
      if (status.value == value) {
        return status;
      }
    }
    throw new IllegalArgumentException("Invalid status code: " + value);
  }

  public int getValue() {
    return value;
  }

  public String getDescription() {
    return description;
  }

  @Override
  public String toString() {
    return value + " " + description;
  }
}
