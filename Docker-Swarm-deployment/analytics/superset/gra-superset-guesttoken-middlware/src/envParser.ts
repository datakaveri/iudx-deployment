import z from "zod";

export const envSchema = z.object({
	SUPERSET_URL: z.string(),
	SUPERSET_ADMIN: z.string(),
	SUPERSET_ADMIN_PASSWORD: z.string(),
	APP_PORT: z.string().transform((val) => parseInt(val, 10)),
});
