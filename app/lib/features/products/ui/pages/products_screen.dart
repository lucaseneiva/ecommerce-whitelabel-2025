import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../whitelabel/ui/providers/config_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtém o título dinâmico do whitelabel
    final configAsync = ref.watch(clientConfigProvider);
    final productsAsync = ref.watch(productsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: configAsync.when(
          data: (config) => Text(config.name),
          loading: () => const Text('Carregando loja...'),
          error: (_, __) => const Text('Loja'),
        ),
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              // Responsividade simples para Web
              int crossAxisCount = constraints.maxWidth > 1200 
                  ? 5 
                  : constraints.maxWidth > 800 
                      ? 4 
                      : constraints.maxWidth > 600 
                          ? 3 
                          : 2;
              
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: products[index]);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erro ao carregar produtos: $err'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(productsListProvider),
                child: const Text('Tentar Novamente'),
              )
            ],
          ),
        ),
      ),
    );
  }
}