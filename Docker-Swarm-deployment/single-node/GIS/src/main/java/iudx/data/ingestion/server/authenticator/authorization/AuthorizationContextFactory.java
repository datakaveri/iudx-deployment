package iudx.data.ingestion.server.authenticator.authorization;

import static iudx.data.ingestion.server.authenticator.Constants.JSON_DELEGATE;
import static iudx.data.ingestion.server.authenticator.Constants.JSON_PROVIDER;


public class AuthorizationContextFactory {

  public static AuthorizationStrategy create(String role) {
    switch (role) {
      case JSON_PROVIDER: {
        return new ProviderAuthStrategy();
      }
      case JSON_DELEGATE: {
        return new DelegateAuthStrategy();
      }
      default:
        throw new IllegalArgumentException(role + "role is not defined in IUDX");
    }
  }

}