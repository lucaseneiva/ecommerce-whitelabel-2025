import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../constants/api_constants.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // Interceptor para simular o Host header correto baseado na URL do navegador
  // Isso permite testar o Whitelabel localmente (ex: se você acessar loja-do-joao.com no /etc/hosts)
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      // No Flutter Web, o browser gerencia o Host header, mas podemos passar
      // informações extras se a API precisar entender quem está chamando
      // caso estejamos rodando em localhost.
      
      // Opcional: Adicionar log
      print('Request: ${options.uri}');
      return handler.next(options);
    },
  ));

  return dio;
}