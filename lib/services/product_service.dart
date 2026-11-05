import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/product.dart';

class ProductService {
  ProductService._();
  static final ProductService instance = ProductService._();

  final http.Client _client = http.Client();

  Future<List<Product>> fetchProducts({int offset = 0, int limit = 50}) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/products').replace(
      queryParameters: {'offset': '$offset', 'limit': '$limit'},
    );

    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(AppConfig.requestTimeout);
      if (response.statusCode != 200) {
        throw ProductApiException(
          'Could not load products (HTTP ${response.statusCode}).',
        );
      }
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! List) {
        throw ProductApiException('Unexpected products response from the API.');
      }
      return decoded
          .whereType<Map>()
          .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
          .where((product) => product.id > 0)
          .toList();
    } on ProductApiException {
      rethrow;
    } catch (error) {
      throw ProductApiException('Network error while loading products: $error');
    }
  }

  Future<Product> fetchProductById(int id) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/products/$id');
    final response = await _client
        .get(uri, headers: {'Accept': 'application/json'})
        .timeout(AppConfig.requestTimeout);
    if (response.statusCode != 200) {
      throw ProductApiException('Could not load product (HTTP ${response.statusCode}).');
    }
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map) throw ProductApiException('Invalid product response.');
    return Product.fromJson(Map<String, dynamic>.from(decoded));
  }
}

class ProductApiException implements Exception {
  final String message;
  ProductApiException(this.message);
  @override
  String toString() => message;
}
