import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      // Se você digitar 'loja-do-joao.com:8000', isso pega 'loja-do-joao.com'
      final host = Uri.base.host;
      
      // Retorna 'http://loja-do-joao.com:3000'
      // Assim, a requisição vai com o Host header correto para o NestJS
      return 'http://$host:3000';
    }
    return 'http://localhost:3000';
  }
}