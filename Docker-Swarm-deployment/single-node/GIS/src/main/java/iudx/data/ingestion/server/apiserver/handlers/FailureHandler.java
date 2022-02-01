package iudx.data.ingestion.server.apiserver.handlers;

import io.vertx.core.Handler;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import iudx.data.ingestion.server.apiserver.exceptions.DxRuntimeException;
import iudx.data.ingestion.server.apiserver.response.ResponseUrn;
import iudx.data.ingestion.server.apiserver.response.RestResponse;
import iudx.data.ingestion.server.apiserver.util.Constants;
import iudx.data.ingestion.server.apiserver.util.HttpStatusCode;
import org.apache.http.HttpStatus;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class FailureHandler implements Handler<RoutingContext> {

  private static final Logger LOGGER = LogManager.getLogger(FailureHandler.class);

  @Override
  public void handle(RoutingContext context) {
    Throwable failure = context.failure();

    LOGGER.info("In failure handler.");
    if (failure instanceof DxRuntimeException) {
      DxRuntimeException exception = (DxRuntimeException) failure;
      LOGGER.error(exception.getUrn().getUrn() + " : " + exception.getMessage());
      HttpStatusCode code = HttpStatusCode.getByValue(exception.getStatusCode());

      JsonObject response = new RestResponse.Builder()
          .withType(exception.getUrn().getUrn())
          .withTitle(code.getDescription())
          .withMessage(code.getDescription())
          .build()
          .toJson();

      context.response()
          .putHeader(Constants.CONTENT_TYPE, Constants.APPLICATION_JSON)
          .setStatusCode(exception.getStatusCode())
          .end(response.toString());
    }

    if (failure instanceof RuntimeException) {
      LOGGER.error(failure.getMessage());
      String validationErrorMessage = Constants.MSG_BAD_QUERY;
      context.response()
          .putHeader(Constants.CONTENT_TYPE, Constants.APPLICATION_JSON)
          .setStatusCode(HttpStatus.SC_BAD_REQUEST)
          .end(validationFailureResponse(validationErrorMessage).toString());
    }

    context.next();
    return;
  }

  private JsonObject validationFailureResponse(String message) {
    ResponseUrn badReq=ResponseUrn.BAD_REQUEST;
    return new JsonObject()
        .put(Constants.JSON_TYPE, badReq.getUrn())
        .put(Constants.JSON_TITLE, badReq.getMessage())
        .put(Constants.JSON_DETAIL, message);
  }

}
