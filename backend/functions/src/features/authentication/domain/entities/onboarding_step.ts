import {z} from "zod";

/**
 * Etapa atual do onboarding (fonte da verdade no servidor após autenticação).
 */
export const onboardingStepSchema = z.enum([
  "none",
  "emailOtpPending",
  "profileComplete",
  "selfie",
  "liveness",
  "verification",
  "permissions",
  "done",
]);

export type OnboardingStep = z.infer<typeof onboardingStepSchema>;
