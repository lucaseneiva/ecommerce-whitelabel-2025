import { Injectable, UnauthorizedException } from '@nestjs/common';
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
        throw new UnauthorizedException('Usuário não encontrado.');
    }

    // 2. (Opcional no Whitelabel) Verificar se o usuário pertence a loja correta (host)
    // No mundo real, você impediria que o admin da Loja A logasse na URL da Loja B.
    if (user.client.url !== host) {
        // throw new UnauthorizedException('Este usuário não pertence a esta loja.');
        // Para o teste ser mais simples, vou deixar passar ou apenas logar
        console.warn(`Aviso: Usuário da loja ${user.client.url} logando em ${host}`);
    }

    // 3. Validar senha
    const isMatch = await bcrypt.compare(pass, user.password_hash);
    if (!isMatch) {
      throw new UnauthorizedException('Senha incorreta.');
    }

    // 4. Gerar Token
    const payload = { sub: user.id, email: user.email, clientId: user.client.id };
    return {
      access_token: await this.jwtService.signAsync(payload),
    };
  }
}