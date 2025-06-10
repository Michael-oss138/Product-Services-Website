import ApiService from "./apiService";
import Security from "../database/models/Security";

const apiRequest = new ApiService("http://localhost:4848/user");

class AuthService {
  async signupUser(body: any, headers: any) {
    try {
      const resp = await apiRequest.post("/create", body, headers);
      const data = resp.data.body;
      await Security.create({
        userId: data.userId,
        password: body.password,
        role: body.role,
      });
    } catch (error) {
      throw error;
    }
  }
}

export default new AuthService();
