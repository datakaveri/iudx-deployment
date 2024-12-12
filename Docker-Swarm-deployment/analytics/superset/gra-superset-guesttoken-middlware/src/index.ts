import { serve } from "@hono/node-server";
import { Hono } from "hono";
import { envSchema } from "./envParser.js";
import dotenv from "dotenv";
import { cors } from "hono/cors";
import { SupersetService } from "./services/supersetService.js";
import { GuestTokenService } from "./services/guestTokenService.js";
import { GuestTokenController } from "./controllers/guestTokenController.js";
import { setupGuestTokenRoutes } from "./routes/guestTokenRoutes.js";

// Parse Environment variables
dotenv.config();
const parsedEnv = envSchema.safeParse(process.env);
if (!parsedEnv.success) {
  console.error("Invalid environment variables:", parsedEnv.error.format());
  process.exit(1);
}

const app = new Hono();

// Setup services and controllers
const supersetService = new SupersetService(parsedEnv.data.SUPERSET_URL);
const guestTokenService = new GuestTokenService(supersetService);
const guestTokenController = new GuestTokenController(guestTokenService);

const corsOptions = {
  origin: '*', 
  methods: 'GET,POST,PUT,DELETE',
  allowedHeaders: 'Content-Type,Authorization',
};
// Middleware
app.use(cors(corsOptions));

// Setup routes
setupGuestTokenRoutes(app, guestTokenController);

// Error Handling
app.onError((err, c) => {
  console.error("Application error:", err);
  return c.json({ message: "Internal Server Error" }, 500);
});

const port = parsedEnv.data.APP_PORT;
console.log(`Server is running on http://localhost:${port}`);

serve({
  fetch: app.fetch,
  port,
});
