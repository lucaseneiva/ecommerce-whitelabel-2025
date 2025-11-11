// lib/main.dart

import 'dart:convert'; // Para decodificar o JSON
import 'package:flutter/foundation.dart'; // Para usar a variável kIsWeb
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Damos um apelido 'http' para o pacote

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Variáveis de estado para guardar as informações do cliente
  String _clientName = 'Carregando...';
  Color _primaryColor = Colors.grey; // Cor padrão enquanto carrega
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Quando o widget é iniciado, chamamos nossa função para buscar os dados
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Apenas para Flutter Web, pegamos o hostname da URL do navegador
    // Ex: "loja-do-joao.com" ou "boutique-da-maria.com"
    final String hostname = kIsWeb ? Uri.base.host : 'localhost';
    
    // Montamos a URL base da nossa API NestJS que está na porta 3000
    final String apiBaseUrl = 'http://$hostname:3000';

    // Chamamos as duas funções em paralelo para carregar tudo
    await Future.wait([
      _fetchClientConfig(apiBaseUrl),
      _fetchProducts(apiBaseUrl),
    ]);

    // Após tudo carregar, mudamos o estado para remover o loading
    setState(() {
      _isLoading = false;
    });
  }

  // Função para buscar a configuração do cliente (Whitelabel)
  Future<void> _fetchClientConfig(String apiBaseUrl) async {
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/config'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Atualizamos o estado com os dados recebidos da API
        setState(() {
          _clientName = data['name'];
          // Convertemos a string Hex da cor para um objeto Color do Flutter
          final colorString = 'FF${data['primaryColor'].replaceAll('#', '')}';
          _primaryColor = Color(int.parse(colorString, radix: 16));
        });
      }
    } catch (e) {
      print('Erro ao buscar configuração do cliente: $e');
      setState(() {
        _clientName = 'Erro de Conexão';
      });
    }
  }

  // Função para buscar a lista de produtos
  Future<void> _fetchProducts(String apiBaseUrl) async {
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/products'));
      if (response.statusCode == 200) {
        // Por enquanto, apenas imprimimos no console para provar que funcionou
        print('Produtos recebidos com sucesso!');
        print('Tamanho da resposta: ${response.body.length} caracteres.');
      }
    } catch (e) {
      print('Erro ao buscar produtos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce Whitelabel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        // Usamos nossa cor dinâmica na AppBar
        appBar: AppBar(
          backgroundColor: _primaryColor,
          // Usamos nosso nome dinâmico no título
          title: Text(_clientName),
        ),
        // Mostramos um indicador de progresso enquanto os dados não chegam
        body: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Configuração carregada. Produtos no console!'),
        ),
      ),
    );
  }
}