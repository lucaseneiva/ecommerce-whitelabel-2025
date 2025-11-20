import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../whitelabel/ui/providers/config_provider.dart';
import '../../../auth/ui/providers/auth_provider.dart'; // Import do Auth para o logout
import '../providers/product_filter_provider.dart'; // <--- NOVO IMPORT
import '../widgets/product_card.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(clientConfigProvider);
    
    // MUDANÇA 1: Agora observamos a lista FILTRADA, e não mais a lista bruta
    final productsAsync = ref.watch(filteredProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: configAsync.when(
          data: (config) => Text(config.name),
          loading: () => const Text('Carregando...'),
          error: (_, __) => const Text('Loja'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
            },
          )
        ],
      ),
      body: Column(
        children: [
          // MUDANÇA 2: Barra de Busca
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                // Atualiza o provider de busca a cada letra digitada
                ref.read(productSearchQueryProvider.notifier).setQuery(value);
              },
              decoration: InputDecoration(
                hintText: 'Buscar por nome ou departamento...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),

          // Lista de Produtos (Expanded para ocupar o resto da tela)
          Expanded(
            child: productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhum produto encontrado.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }
                return LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth > 1200 
                        ? 5 
                        : constraints.maxWidth > 800 
                            ? 4 
                            : constraints.maxWidth > 600 
                                ? 3 
                                : 2;
                    
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              error: (err, stack) => Center(child: Text('Erro: $err')),
            ),
          ),
        ],
      ),
    );
  }
}