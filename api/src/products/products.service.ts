import { Injectable } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';

export interface Product {
  id: string;
  name: string;
  description: string;
  image: string;
  price: number;
  department: string;
}

@Injectable()
export class ProductsService {
  // URLs dos mocks
  private readonly brazilianProviderUrl = 'http://616d6bdb6dacbb001794ca17.mockapi.io/devnology/brazilian_provider';
  private readonly europeanProviderUrl = 'http://616d6bdb6dacbb001794ca17.mockapi.io/devnology/european_provider';

  constructor(private readonly httpService: HttpService) {}

  async findAll(): Promise<Product[]> {
    // 1. Busca dados (com tratamento de erro básico)
    const [brazilianResponse, europeanResponse] = await Promise.all([
      firstValueFrom(this.httpService.get(this.brazilianProviderUrl)).catch(() => ({ data: [] })),
      firstValueFrom(this.httpService.get(this.europeanProviderUrl)).catch(() => ({ data: [] })),
    ]);

    let allProducts: any[] = [];

    // 2. Tratamento do JSON "sujo" do Brasil
    const rawBrazilian = brazilianResponse.data;
    if (Array.isArray(rawBrazilian)) {
      rawBrazilian.forEach((item) => {
        // Se o item não tem nome mas é um objeto, tenta extrair os valores internos (bug do mock)
        if (!item.nome && !item.name && typeof item === 'object') {
           const nested = Object.values(item);
           allProducts.push(...nested);
        } else {
           allProducts.push(item);
        }
      });
    }

    // 3. Adiciona Europeus
    if (Array.isArray(europeanResponse.data)) {
      allProducts = [...allProducts, ...europeanResponse.data];
    }

    // 4. Normaliza
    return allProducts
      .map((item) => this.normalizeProduct(item))
      .filter((p) => p !== null) as Product[];
  }

  private normalizeProduct(item: any): Product | null {
    // Validação mínima
    if (!item || (!item.nome && !item.name)) return null;

    const name = item.nome || item.name || 'Produto';
    const description = item.descricao || item.description || '';
    const department = item.departamento || item.categoria || 'Geral';

    // Preço
    let price = 0;
    const rawPrice = item.preco || item.price;
    if (typeof rawPrice === 'string') price = parseFloat(rawPrice);
    else if (typeof rawPrice === 'number') price = rawPrice;

    // --- LIMPEZA DE IMAGEM ---
    // Tenta pegar a URL
    let image = '';
    if (item.gallery && item.gallery.length > 0) image = item.gallery[0];
    else if (item.imagem) image = item.imagem;

    // Se for lixo (local, placeimg fora do ar, etc), deixa vazio.
    // O Frontend vai decidir como mostrar "sem imagem".
    if (typeof image === 'string') {
        if (image.includes('fakepath') || 
            image.includes('placeimg') || 
            !image.startsWith('http')) {
            image = ''; 
        }
    } else {
        image = '';
    }
    // -------------------------

    const id = item.id ? item.id.toString() : Math.random().toString(36).substr(2, 9);

    return { id, name, description, department, price, image };
  }
}