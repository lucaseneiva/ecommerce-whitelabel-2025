import { Controller, Get, Req } from '@nestjs/common';
import type { ClientConfig } from './clients.service';
import { ClientsService } from './clients.service';
import type { Request } from 'express';

@Controller('config')
export class ClientsController {
  constructor(private readonly clientsService: ClientsService) {}

  @Get()
  async getConfig(@Req() request: Request): Promise<ClientConfig> {
    const requestHost = request.headers.host ?? 'default-host:8000';
    const host = requestHost.split(':')[0]; // 'loja-do-joao.com:3000' -> 'loja-do-joao.com'

    return this.clientsService.getConfigByHost(host);
  }
}
