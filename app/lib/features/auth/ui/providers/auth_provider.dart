import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_provider.dart';

part 'auth_provider.g.dart';

// Estado simples: null = não logado, String = token JWT
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  String? build() {
    return null; // Começa deslogado
  }

  Future<void> login(String email, String password) async {
    final dio = ref.read(dioProvider);
    
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final token = response.data['access_token'];
      
      // Atualiza o estado com o token
      state = token;
      
      // TODO: Aqui você salvaria no SharedPreferences para persistência
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Email ou senha inválidos');
      }
      throw Exception('Erro ao conectar com o servidor');
    }
  }

  void logout() {
    state = null;
  }
}