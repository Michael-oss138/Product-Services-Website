import * as controller from "../controllers/auth";
import { Router } from "express";
import permission from "../middlewares/permission";

const router = Router();

router.route("/signup").post([permission, controller.signupUser]);

export default router;
