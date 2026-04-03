import {
  type UserEntity,
  userEntitySchema,
} from "../domain/entities/user_entity.js";

/** Linha de usuário vinda do Firestore (mesmo shape de [UserEntity]). */
export const userRepositoryRowSchema = userEntitySchema;

export type UserRepositoryRow = UserEntity;

export interface UserRepository {
  getAllUsers(): Promise<UserRepositoryRow[]>;
}
