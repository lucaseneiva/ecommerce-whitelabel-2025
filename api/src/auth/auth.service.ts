import { Injectable, UnauthorizedException, ForbiddenException } from '@nestjs/common'; // Adicione ForbiddenException
import { UsersService } from '../users/users.service';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
  ) {}

  async signIn(email: string, pass: string, host: string): Promise<{ access_token: string }> {
    // 1. Buscar usuário pelo email
    const user = await this.usersService.findByEmail(email);
    
    if (!user) {
        throw new UnauthorizedException('Credenciais inválidas.');
    }

    // 2. VERIFICAÇÃO WHITELABEL (Agora obrigatória)
    // Se o usuário pertence à "loja-do-joao.com" e tenta logar via "boutique-da-maria.com", bloqueia.
    if (user.client.url !== host) {
        // Em produção, por segurança, você pode retornar a mesma mensagem genérica "Credenciais inválidas"
        // para não expor que o usuário existe em outra loja. Mas para o teste, Forbidden explica melhor.
        throw new ForbiddenException(`Este usuário não possui acesso a esta loja (${host}).`);
    }

    // 3. Validar senha
    const isMatch = await bcrypt.compare(pass, user.password_hash);
    if (!isMatch) {
      throw new UnauthorizedException('Credenciais inválidas.');
    }

    // 4. Gerar Token
    const payload = { sub: user.id, email: user.email, clientId: user.client.id };
    return {
      access_token: await this.jwtService.signAsync(payload),
    };
  }
}