import { Client } from '../../clients/entities/client.entity';
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  email: string;

  @Column()
  password_hash: string; 

  // Cada usuário está ligado a UM cliente.
  @ManyToOne(() => Client, (client) => client.users)
  client: Client;
}