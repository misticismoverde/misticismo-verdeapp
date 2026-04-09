import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/carta_model.dart';
import 'storage_service.dart';

class NoInternetException implements Exception {}

class ApiTimeoutException implements Exception {}

class ApiFailureException implements Exception {
  final String message;
  ApiFailureException(this.message);
}

class ApiService {
  static const String _url =
      'https://misticismoverde.com.br/api/sussurro-hoje';

  Future<CartaModel> fetchSussurroHoje() async {
    try {
      final response = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final carta = CartaModel.fromMap(decoded);
        await StorageService.cacheCarta(carta);
        return carta;
      }

      throw ApiFailureException(
        'Erro da API: ${response.statusCode}',
      );
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw ApiTimeoutException();
    } on FormatException {
      throw ApiFailureException('Resposta inválida da API.');
    } catch (e) {
      if (e is NoInternetException ||
          e is ApiTimeoutException ||
          e is ApiFailureException) {
        rethrow;
      }
      throw ApiFailureException('Falha inesperada ao carregar dados.');
    }
  }
}