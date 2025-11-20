import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = product.image ?? '';
    final String name = product.name ?? 'Produto';
    final String department = product.department ?? 'Geral';
    final String price = product.price?.toStringAsFixed(2) ?? '0.00';

    // Definindo o widget de Placeholder para reaproveitar
    Widget buildPlaceholder() {
      return Container(
        color: Colors.grey[100], // Fundo cinza bem claro
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined, // Ícone neutro de e-commerce
              size: 48,
              // Usa a cor da loja com transparência para ficar elegante
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 0, // Flat design fica mais moderno
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!), // Borda sutil
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Área da Imagem
          Expanded(
            child: imageUrl.isEmpty
                ? buildPlaceholder()
                : Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // Loading
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(color: Colors.grey[50]);
                    },
                    // Erro (se a URL existir mas não carregar)
                    errorBuilder: (_, __, ___) => buildPlaceholder(),
                  ),
          ),
          
          // Área de Texto
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  department,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'R\$ $price',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}