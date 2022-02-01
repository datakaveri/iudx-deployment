package iudx.data.ingestion.server.apiserver.validation.types;

import static iudx.data.ingestion.server.apiserver.response.ResponseUrn.INVALID_ID_VALUE;
import static iudx.data.ingestion.server.apiserver.util.Constants.VALIDATION_ID_MAX_LEN;
import static iudx.data.ingestion.server.apiserver.util.Constants.VALIDATION_ID_PATTERN;

import iudx.data.ingestion.server.apiserver.exceptions.DxRuntimeException;
import iudx.data.ingestion.server.apiserver.util.HttpStatusCode;
import iudx.data.ingestion.server.apiserver.validation.Validator;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public final class IDTypeValidator implements Validator {

  private static final Logger LOGGER = LogManager.getLogger(IDTypeValidator.class);
  private final String value;
  private final boolean required;
  private Integer maxLength = VALIDATION_ID_MAX_LEN;

  public IDTypeValidator(final String value, final boolean required) {
    this.value = value;
    this.required = required;
  }

  public boolean isValidIUDXId(final String value) {
    return VALIDATION_ID_PATTERN.matcher(value).matches();
  }

  @Override
  public boolean isValid() {
    LOGGER.debug("value : " + value + " required : " + required);
    if (required && (value == null || value.isBlank())) {
      LOGGER.error("Validation error : null or blank value for required mandatory field");
      throw new DxRuntimeException(failureCode(), INVALID_ID_VALUE, failureMessage());
    } else {
      if (value == null) {
        return true;
      }
      if (value.isBlank()) {
        LOGGER.error("Validation error :  blank value for passed");
        throw new DxRuntimeException(failureCode(), INVALID_ID_VALUE, failureMessage(value));
      }
    }
    if (value.length() > maxLength) {
      LOGGER.error("Validation error : Value exceed max character limit.");
      throw new DxRuntimeException(failureCode(), INVALID_ID_VALUE, failureMessage(value));
    }
    if (!isValidIUDXId(value)) {
      LOGGER.error("Validation error : Invalid id.");
      throw new DxRuntimeException(failureCode(), INVALID_ID_VALUE, failureMessage(value));
    }
    LOGGER.info("ID is Valid");
    return true;
  }

  @Override
  public int failureCode() {
    return HttpStatusCode.BAD_REQUEST.getValue();
  }

  @Override
  public String failureMessage() {
    return INVALID_ID_VALUE.getMessage();
  }

}
