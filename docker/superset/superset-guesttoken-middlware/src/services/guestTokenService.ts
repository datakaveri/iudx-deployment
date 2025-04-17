import { SupersetService } from "./supersetService.js";

export class GuestTokenService {
  private supersetService: SupersetService;

  constructor(supersetService: SupersetService) {
    this.supersetService = supersetService;
  }

  async generateGuestToken(dashboardId: string): Promise<string> {
    const supersetAccessToken = await this.supersetService.login();
    return await this.supersetService.getGuestToken(
      dashboardId,
      supersetAccessToken
    );
  }
}
