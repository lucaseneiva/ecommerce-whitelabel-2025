import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ProductsModule } from './products/products.module';
import { ClientsModule } from './clients/clients.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersModule } from './users/users.module';

@Module({
  imports: [ProductsModule, ClientsModule, TypeOrmModule.forRoot({
      type: 'sqlite', 
      database: 'db/database.sqlite',
      entities: [__dirname + '/**/*.entity{.ts,.js}'],
      synchronize: true, // Em desenvolvimento, cria o schema do DB automaticamente. NUNCA use em produção!
    }), UsersModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
