import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/products/ui/pages/products_screen.dart';
import '../../features/auth/ui/pages/login_screen.dart';
import '../../features/auth/ui/providers/auth_provider.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  // Ouve mudanças no estado de autenticação para triggerar o redirecionamento
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState != null;
      final isLoggingIn = state.uri.toString() == '/login';

      // Se não está logado e não está na tela de login, manda pro login
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // Se já está logado e tenta acessar login, manda pra home
      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null; // Não faz nada
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}