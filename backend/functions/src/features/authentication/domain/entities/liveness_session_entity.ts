import {z} from "zod";

import {livenessSessionStatusSchema} from "./liveness_session_status.js";

/** Sessão de prova de vida (detalhes brutos no provedor ou storage privado). */
export const livenessSessionEntitySchema = z.object({
  id: z.string(),
  userId: z.string(),
  provider: z.string(),
  providerSessionId: z.string().optional(),
  status: livenessSessionStatusSchema,
  resultSummary: z.record(z.string(), z.unknown()).optional().nullable(),
  rawPayloadRef: z.string().optional().nullable(),
  createdAt: z.coerce.date(),
  completedAt: z.coerce.date().optional().nullable(),
});

export type LivenessSessionEntity = z.infer<typeof livenessSessionEntitySchema>;
