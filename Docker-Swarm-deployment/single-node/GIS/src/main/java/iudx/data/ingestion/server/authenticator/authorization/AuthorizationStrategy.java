package iudx.data.ingestion.server.authenticator.authorization;

import iudx.data.ingestion.server.authenticator.model.JwtData;

public interface AuthorizationStrategy {

  boolean isAuthorized(AuthorizationRequest authRequest, JwtData jwtData);

}
