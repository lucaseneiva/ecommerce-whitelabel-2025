import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/client_config_model.dart';
import '../../data/repositories/config_repository.dart';

part 'config_provider.g.dart';

// Provider que busca a configuração assim que o app inicia
@Riverpod(keepAlive: true)
Future<ClientConfigModel> clientConfig(Ref ref) async {
  final repository = ref.watch(configRepositoryProvider);
  return repository.getClientConfig();
}

// Helper para transformar a string HEX (#FF0000) em Color do Flutter
extension ColorExtension on String {
  Color toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}