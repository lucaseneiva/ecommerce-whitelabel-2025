import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_web_plugins/url_strategy.dart'; // Descomente se quiser remover o # da URL

import 'core/routing/app_router.dart';
import 'features/whitelabel/ui/providers/config_provider.dart';

void main() {
  // usePathUrlStrategy(); // Descomente se quiser remover o # da URL
  runApp(const ProviderScope(child: AppBootstrap()));
}

class AppBootstrap extends ConsumerWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // O segredo do Whitelabel:
    // Monitoramos a configuração ANTES de renderizar o MaterialApp final
    // para injetar a cor primária correta no tema.
    final configAsync = ref.watch(clientConfigProvider);

    return configAsync.when(
      data: (config) => _MainApp(
        primaryColor: config.primaryColor.toColor(),
        title: config.name,
      ),
      // Tela de loading inicial enquanto descobre "qual loja sou eu"
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        debugShowCheckedModeBanner: false,
      ),
      // Fallback simples em caso de erro fatal na config
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Erro fatal de configuração: $error')),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class _MainApp extends ConsumerWidget {
  final Color primaryColor;
  final String title;

  const _MainApp({
    required this.primaryColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: title,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
    );
  }
}