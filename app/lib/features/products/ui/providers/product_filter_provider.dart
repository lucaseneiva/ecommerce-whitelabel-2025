import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/product_model.dart';
import 'products_provider.dart';

part 'product_filter_provider.g.dart';

@riverpod
class ProductSearchQuery extends _$ProductSearchQuery {
  @override
  String build() {
    return ''; // Começa vazio
  }

  void setQuery(String query) {
    state = query;
  }
}

@riverpod
Future<List<ProductModel>> filteredProducts(Ref ref) async {
  
  final allProducts = await ref.watch(productsListProvider.future);
  
  
  final query = ref.watch(productSearchQueryProvider);

  if (query.isEmpty) {
    return allProducts;
  }

  final lowerQuery = query.toLowerCase();
  return allProducts.where((product) {
    final name = (product.name ?? '').toLowerCase();
    final department = (product.department ?? '').toLowerCase();
    
    return name.contains(lowerQuery) || department.contains(lowerQuery);
  }).toList();
}