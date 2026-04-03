import {z} from "zod";

/** Desafio de código enviado por e-mail.
 *
 * [codeHash] fica no servidor; o app só envia o código em texto na validação.
 */
export const emailOtpChallengeEntitySchema = z.object({
  id: z.string(),
  userId: z.string(),
  codeHash: z.string(),
  expiresAt: z.coerce.date(),
  attemptCount: z.number().int().nonnegative().default(0),
  consumedAt: z.coerce.date().optional().nullable(),
  createdAt: z.coerce.date(),
});

export type EmailOtpChallengeEntity = z.infer<
  typeof emailOtpChallengeEntitySchema
>;
