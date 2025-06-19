import * as controller from "../controllers/auth";
import { Router } from "express";
import permission from "../middlewares/permission";

const router = Router();

router.route("/signup").post([permission, controller.signupUser]);
router.route("/signin").post(controller.signinUser);
router.route("/token").post(controller.renewToken);
router.route("/logout").post(controller.logout);

export default router;
