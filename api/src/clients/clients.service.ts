import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Client } from './entities/client.entity';

// Para definir o formato da resposta
export interface ClientConfig {
  name: string;
  primaryColor: string;
}

@Injectable()
export class ClientsService implements OnModuleInit {
  constructor(
    @InjectRepository(Client)
    private clientRepository: Repository<Client>,
  ) {}
  

// Popular bd com dados iniciais.
  async onModuleInit() {
    const count = await this.clientRepository.count();
    if (count === 0) {
      console.log('Banco de dados de clientes vazio. Populando...');
      await this.clientRepository.save([
        this.clientRepository.create({
          name: 'Devnology',
          url: 'devnology.com', // Ajustado conforme enunciado
          primaryColor: '#2ecc71', // Verde (conforme enunciado)
        }),
        this.clientRepository.create({
          name: 'In8',
          url: 'in8.com', // Ajustado conforme enunciado
          primaryColor: '#9b59b6', // Roxo (conforme enunciado)
        }),
      ]);
      console.log('Banco de dados populado com sucesso.');
    }
  }

  async getConfigByHost(host: string): Promise<ClientConfig> {
    console.log(`Buscando configuração para o host: ${host}`);

    const client = await this.clientRepository.findOne({
      where: { url: host },
    });

    if (client) {
      return {
        name: client.name,
        primaryColor: client.primaryColor,
      };
    }

    return {
      name: 'Loja Genérica',
      primaryColor: '#808080',
    };
  }
}