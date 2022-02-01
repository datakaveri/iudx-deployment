package iudx.data.ingestion.server.apiserver.validation.types;

import static iudx.data.ingestion.server.apiserver.response.ResponseUrn.INVALID_PARAM_VALUE;
import static iudx.data.ingestion.server.apiserver.util.Constants.QUEUE;
import static iudx.data.ingestion.server.apiserver.util.Constants.VALIDATION_QUEUE_PATTERN;

import io.vertx.core.json.JsonObject;
import iudx.data.ingestion.server.apiserver.exceptions.DxRuntimeException;
import iudx.data.ingestion.server.apiserver.util.HttpStatusCode;
import iudx.data.ingestion.server.apiserver.validation.Validator;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class StringValidator implements Validator {

  private static final Logger LOGGER = LogManager.getLogger(StringValidator.class);
  private String value;
  private JsonObject body;

  public StringValidator(String value, JsonObject body) {
    this.body = body;
    this.value = value;
  }

  @Override
  public boolean isValid() {
    if(body.containsKey(QUEUE) && !VALIDATION_QUEUE_PATTERN.matcher(value).matches()){
      LOGGER.info("Invalid Queue Value");
      throw new DxRuntimeException(failureCode(), INVALID_PARAM_VALUE, failureMessage(value));
    }
     return true;
  }

  @Override
  public int failureCode() {
    return HttpStatusCode.BAD_REQUEST.getValue();
  }

  @Override
  public String failureMessage() {
    return INVALID_PARAM_VALUE.getMessage();
  }
}
