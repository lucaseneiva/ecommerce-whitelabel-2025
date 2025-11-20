import { Body, Controller, Post, HttpCode, HttpStatus, Req } from '@nestjs/common';
import { AuthService } from './auth.service';
import type { Request } from 'express';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @HttpCode(HttpStatus.OK)
  @Post('login')
  signIn(@Body() signInDto: Record<string, any>, @Req() request: Request) {
    // Captura o host para garantir segurança multitenant (opcional mas recomendado)
    const requestHost = request.headers.host ?? ''; 
    const host = requestHost.split(':')[0];

    return this.authService.signIn(signInDto.email, signInDto.password, host);
  }
}