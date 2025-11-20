import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors();

  // Configuração do Swagger
  const config = new DocumentBuilder()
    .setTitle('E-commerce Whitelabel API')
    .setDescription('API para gerenciamento de produtos e clientes multi-tenant')
    .setVersion('1.0')
    .addBearerAuth() // Adiciona suporte a JWT no Swagger
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();