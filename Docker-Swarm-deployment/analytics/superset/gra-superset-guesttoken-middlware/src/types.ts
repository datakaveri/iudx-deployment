export interface EnvConfig {
  SUPERSET_URL: string;
  APP_PORT: number;
}

export interface TokenPayload {
  email: string;
}

export interface GuestTokenRequest {
  access_token: string;
  dashboard_id: string;
}
