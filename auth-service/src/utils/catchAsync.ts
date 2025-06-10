import { Request, Response, NextFunction } from "express";
type MiddlewareFunction = (req: Request, res: Response) => Promise<void>;
export default (controller: MiddlewareFunction) =>
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      await controller(req, res);
    } catch (err) {
      next(err);
    }
  };
