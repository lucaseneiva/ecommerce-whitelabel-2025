import { Injectable } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';

export interface Product {
  id: string;
  createdAt: string;
  nome: string;
  descricao: string;
  imagem: string;
  preco: string;
  categoria: string;
  material: string;
  departamento: string;
}

@Injectable()
export class ProductsService {
  private readonly brazilianProviderUrl = 'http://616d6bdb6dacbb001794ca17.mockapi.io/devnology/brazilian_provider';
  private readonly europeanProviderUrl = 'http://616d6bdb6dacbb001794ca17.mockapi.io/devnology/european_provider';

  constructor(private readonly httpService: HttpService) {}

  async findAll(): Promise<Product[]> {
    console.log('Buscando produtos dos fornecedores...');

    const brazilianProductsPromise = firstValueFrom(
      this.httpService.get<Product[]>(this.brazilianProviderUrl),
    );

    const europeanProductsPromise = firstValueFrom(
      this.httpService.get<Product[]>(this.europeanProviderUrl),
    );

    const [brazilianResponse, europeanResponse] = await Promise.all([
      brazilianProductsPromise,
      europeanProductsPromise,
    ]);

    const brazilianProducts = brazilianResponse.data;
    const europeanProducts = europeanResponse.data;

    console.log(`Encontrados ${brazilianProducts.length} produtos brasileiros.`);
    console.log(`Encontrados ${europeanProducts.length} produtos europeus.`);
    
    return [...brazilianProducts, ...europeanProducts];
  }
}