import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/client_config_model.dart';

part 'config_repository.g.dart';

class ConfigRepository {
  final Dio _dio;

  ConfigRepository(this._dio);

  Future<ClientConfigModel> getClientConfig() async {
    try {
      // A API NestJS lê o host header.
      // GET /config
      final response = await _dio.get('/config');
      return ClientConfigModel.fromJson(response.data);
    } catch (e) {
      // Fallback em caso de erro
      return ClientConfigModel(name: 'Loja Padrão', primaryColor: '#000000');
    }
  }
}

@riverpod
ConfigRepository configRepository(Ref ref) {
  return ConfigRepository(ref.watch(dioProvider));
}