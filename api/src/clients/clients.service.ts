import { Injectable } from '@nestjs/common';

export interface ClientConfig {
  name: string;
  primaryColor: string;
}

@Injectable()
export class ClientsService {

  getConfigByHost(host: string): ClientConfig {
    console.log(`Recebida requisição do host: ${host}`);

    if (host && host.includes('loja-do-joao.com')) {
      return {
        name: 'Loja do João',
        primaryColor: '#FF5733', // Laranja
      };
    }

    if (host && host.includes('boutique-da-maria.com')) {
      return {
        name: 'Boutique da Maria',
        primaryColor: '#3375FF', // Azul
      };
    }

    return {
      name: 'Loja Genérica',
      primaryColor: '#808080', // Cinza
    };
  }
}