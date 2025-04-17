import type { Context } from "hono";
import { GuestTokenService } from "../services/guestTokenService.js";
import { jwtDecode } from "jwt-decode";
import type { TokenPayload, GuestTokenRequest } from "../types.js";

export class GuestTokenController {
  private guestTokenService: GuestTokenService;

  constructor(guestTokenService: GuestTokenService) {
    this.guestTokenService = guestTokenService;
  }

  async generateToken(c: Context) {
    try {
      const { access_token, dashboard_id } = c.req.valid(
        "json"
      ) as GuestTokenRequest;
      const token = jwtDecode(access_token) as TokenPayload;

      if (!token.email) {
        return c.json({ message: "Unauthorized - Please login" }, 401);
      }

      const guestToken = await this.guestTokenService.generateGuestToken(
        dashboard_id
      );
      return c.json({ token: guestToken }, 200);
    } catch (error) {
      console.error("Error processing guest token request:", error);
      return c.json({ message: "Failed to generate guest token" }, 500);
    }
  }
}
