package iudx.data.ingestion.server.authenticator.authorization;

import static iudx.data.ingestion.server.authenticator.authorization.Api.ENTITIES;
import static iudx.data.ingestion.server.authenticator.authorization.Api.INGESTION;
import static iudx.data.ingestion.server.authenticator.authorization.DelegateAuthStrategy.delegateAuthorizationRules;
import static iudx.data.ingestion.server.authenticator.authorization.Method.DELETE;
import static iudx.data.ingestion.server.authenticator.authorization.Method.GET;
import static iudx.data.ingestion.server.authenticator.authorization.Method.POST;

import io.vertx.core.json.JsonArray;
import iudx.data.ingestion.server.authenticator.model.JwtData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class ProviderAuthStrategy implements AuthorizationStrategy {

  private static final Logger LOGGER = LogManager.getLogger(ProviderAuthStrategy.class);

  static Map<String, List<AuthorizationRequest>> providerAuthorizationRules = new HashMap<>();

  static {
    // api access list/rules
    List<AuthorizationRequest> apiAccessList = new ArrayList<>();
    apiAccessList.add(new AuthorizationRequest(POST, ENTITIES));
    providerAuthorizationRules.put("api", apiAccessList);

    // ingestion access list/rules
    List<AuthorizationRequest> ingestAccessList = new ArrayList<>();
    ingestAccessList.add(new AuthorizationRequest(POST, INGESTION));
    ingestAccessList.add(new AuthorizationRequest(DELETE, INGESTION));
    providerAuthorizationRules.put("ingestion", ingestAccessList);
  }

  @Override
  public boolean isAuthorized(AuthorizationRequest authRequest, JwtData jwtData) {
    return true;
  }

}
