import {z} from "zod";

import {onboardingStepSchema} from "./onboarding_step.js";
import {
  permissionPromptStateEntitySchema,
} from "./permission_prompt_state_entity.js";

/** Conta do usuário autenticado.
 *
 * [cpfFingerprint] existe no servidor (hash/HMAC); o cliente em geral não o
 * recebe.
 */
export const userEntitySchema = z.object({
  id: z.string().optional(),
  email: z.string(),
  fullName: z.string(),
  phoneNumber: z.string().nullable().optional(),
  onboardingStep: onboardingStepSchema,
  permissionPrompts: permissionPromptStateEntitySchema.default({
    notification: {seen: false, skipped: false},
    location: {seen: false, skipped: false},
    biometric: {seen: false, skipped: false},
  }),
  createdAt: z.coerce.date(),
  updatedAt: z.coerce.date(),
  cpf: z.string().optional(),
}).transform((row) => ({
  ...row,
  phoneNumber: row.phoneNumber ?? null,
}));

export type UserEntity = z.infer<typeof userEntitySchema>;
