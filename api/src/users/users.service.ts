// src/users/users.service.ts

import { Injectable, OnModuleInit, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { Client } from '../clients/entities/client.entity';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService implements OnModuleInit {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,

    @InjectRepository(Client)
    private clientRepository: Repository<Client>,
  ) {}

  async onModuleInit() {
    const userCount = await this.userRepository.count();
    if (userCount > 0) {
      return; // O banco já tem usuários, não faz nada.
    }

    console.log('Banco de dados de usuários vazio. Populando...');

    const lojaDoJoao = await this.clientRepository.findOne({ where: { url: 'devnology.com' } });
    const boutiqueDaMaria = await this.clientRepository.findOne({ where: { url: 'in8.com' } });

    if (!lojaDoJoao || !boutiqueDaMaria) {
      console.error('ERRO: Clientes não encontrados. O seeding de usuários falhou.');
      return;
    }

    const salt = await bcrypt.genSalt();
    const passwordHash = await bcrypt.hash('123456', salt);

    const userJoao = this.userRepository.create({
      email: 'joao@email.com',
      password_hash: passwordHash,
      client: lojaDoJoao,
    });

    const userMaria = this.userRepository.create({
      email: 'maria@email.com',
      password_hash: passwordHash,
      client: boutiqueDaMaria,
    });

    await this.userRepository.save([userJoao, userMaria]);

    console.log('Usuários de teste criados com sucesso.');
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.userRepository.findOne({
      where: { email },
      relations: ['client'], // Importante para checar de qual loja ele é
    });
  }
}