import { Controller, Get, Req } from '@nestjs/common';
import type { ClientConfig } from './clients.service';
import { ClientsService } from './clients.service';
import type { Request } from 'express';
@Controller('config')
export class ClientsController {
  constructor(private readonly clientsService: ClientsService) {}

  @Get()
  getConfig(@Req() request: Request): ClientConfig {
    
    const host = request.headers.host;

    return this.clientsService.getConfigByHost(host ?? 'default-host');
  }
}