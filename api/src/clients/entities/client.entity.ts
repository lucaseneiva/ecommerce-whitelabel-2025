import { User } from '../../users/entities/user.entity';
import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';

@Entity()
export class Client {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column({ unique: true })
  url: string;

  @Column()
  primaryColor: string;
  
  // Cada cliente está ligado a muitos usuários
  @OneToMany(() => User, (user) => user.client)
  users: User[];
}