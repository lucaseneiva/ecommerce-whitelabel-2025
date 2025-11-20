import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/product_model.dart';

part 'product_repository.g.dart';

class ProductRepository {
  final Dio _dio;

  ProductRepository(this._dio);

  Future<List<ProductModel>> getProducts() async {
    final response = await _dio.get('/products');
    final List data = response.data;
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}

@riverpod
ProductRepository productRepository(Ref ref) {
  return ProductRepository(ref.watch(dioProvider));
}