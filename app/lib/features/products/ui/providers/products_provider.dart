import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

part 'products_provider.g.dart';

@riverpod
Future<List<ProductModel>> productsList(Ref ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
}