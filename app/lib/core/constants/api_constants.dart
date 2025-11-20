import 'package:flutter/foundation.dart';

class ApiConstants {
  // Ajuste aqui se necessário. Para Web local, localhost:3000 costuma funcionar
  // se a API estiver rodando na mesma máquina.
  static String get baseUrl {
    if (kIsWeb) {
      // Pega a URL do navegador para montar a base, caso a API esteja no mesmo host/porta
      // Mas como a API NestJS está na 3000 e o Flutter na 8080 (geralmente):
      return 'http://localhost:3000'; 
    }
    return 'http://localhost:3000';
  }
}