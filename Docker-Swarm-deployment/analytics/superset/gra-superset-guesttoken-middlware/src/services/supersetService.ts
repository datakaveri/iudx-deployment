import axios from "axios";
import dotenv from "dotenv";
import { envSchema } from "../envParser.js";

dotenv.config();
const parsedEnv = envSchema.safeParse(process.env);
if (!parsedEnv.success) {
	console.error("Invalid environment variables:", parsedEnv.error.format());
	process.exit(1);
}

export class SupersetService {
	private baseUrl: string;

	constructor(baseUrl: string) {
		this.baseUrl = baseUrl;
	}

	async login() {
		const loginBody = {
			password: parsedEnv.data?.SUPERSET_ADMIN_PASSWORD,
			username: parsedEnv.data?.SUPERSET_ADMIN,
			provider: "db",
			refresh: true,
		};

		const { data } = await axios.post(`${this.baseUrl}login`, loginBody, {
			headers: { "Content-Type": "application/json" },
		});

		return data.access_token;
	}

	async getGuestToken(dashboardId: string, accessToken: string) {
		const guestTokenBody = {
			resources: [
				{
					type: "dashboard",
					id: dashboardId,
				},
			],
			rls: [],
			user: {
				username: "",
				first_name: "",
				last_name: "",
			},
		};

		const { data } = await axios.post(
			`${this.baseUrl}guest_token/`,
			guestTokenBody,
			{
				headers: {
					"Content-Type": "application/json",
					Authorization: `Bearer ${accessToken}`,
				},
			}
		);

		return data.token;
	}
}
