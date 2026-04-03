import {z} from "zod";

/**
 * Preferência de produto para permissão de sistema (evita repetir onboarding).
 */
export const permissionPromptRecordEntitySchema = z.object({
  seen: z.boolean().default(false),
  skipped: z.boolean().default(false),
  completedAt: z.coerce.date().optional(),
});

export type PermissionPromptRecordEntity = z.infer<
  typeof permissionPromptRecordEntitySchema
>;

/** Agregado das telas de permissão (notificação, localização, biometria). */
export const permissionPromptStateEntitySchema = z.object({
  notification: permissionPromptRecordEntitySchema.default({
    seen: false,
    skipped: false,
  }),
  location: permissionPromptRecordEntitySchema.default({
    seen: false,
    skipped: false,
  }),
  biometric: permissionPromptRecordEntitySchema.default({
    seen: false,
    skipped: false,
  }),
});

export type PermissionPromptStateEntity = z.infer<
  typeof permissionPromptStateEntitySchema
>;
