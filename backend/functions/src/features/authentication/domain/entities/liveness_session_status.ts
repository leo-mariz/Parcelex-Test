import {z} from "zod";

export const livenessSessionStatusSchema = z.enum([
  "started",
  "succeeded",
  "failed",
  "expired",
]);

export type LivenessSessionStatus = z.infer<
  typeof livenessSessionStatusSchema
>;
