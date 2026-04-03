import type {UserRepository} from "../repositories/user_repository.js";

export type CheckCpfExistsResult = {
  exists: boolean;
  phoneNumber: string | null;
};

/**
 * Mantém somente dígitos da string.
 * @param {string} value Texto (ex.: CPF mascarado).
 * @return {string} Apenas números.
 */
function onlyDigits(value: string): string {
  return value.replace(/\D/g, "");
}

/**
 * Verifica se o CPF já existe entre os usuários e retorna o telefone.
 */
export class CheckCpfExistsUseCase {
  /**
   * @param {UserRepository} userRepository Repositório de usuários.
   */
  constructor(private readonly userRepository: UserRepository) {}

  /**
   * Retorna se existe usuário com o CPF e o `phoneNumber` do documento.
   * @param {string} cpf CPF com ou sem máscara.
   * @return {Promise<CheckCpfExistsResult>} exists e phoneNumber.
   */
  async execute(cpf: string): Promise<CheckCpfExistsResult> {
    const target = onlyDigits(cpf);
    if (target.length === 0) {
      return {exists: false, phoneNumber: null};
    }

    const users = await this.userRepository.getAllUsers();
    const match = users.find(
      (u) => u.cpf !== undefined && onlyDigits(u.cpf) === target,
    );

    if (match === undefined) {
      return {exists: false, phoneNumber: null};
    }

    return {
      exists: true,
      phoneNumber: match.phoneNumber,
    };
  }
}
