import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";
import { GuestTokenController } from "../controllers/guestTokenController.js";

export function setupGuestTokenRoutes(
	app: Hono,
	controller: GuestTokenController
) {
	const guestTokenValidator = zValidator(
		"json",
		z.object({
			access_token: z.string(),
			dashboard_id: z.string(),
		})
	);

	app.post("/middleware/guest_token", guestTokenValidator, (c) =>
		controller.generateToken(c)
	);
}
