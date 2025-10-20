import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcc/data/config.dart';
import 'package:tcc/data/http/dio_client.dart';
import 'package:tcc/data/models/post.dart';

class PortfolioRepository {
  final Dio _dio = DioClient.dio;
  final _storage = FlutterSecureStorage();


  Future<List<Portfolio>> getPortfolioAuth({int page =1 }) async {
    try {
      final token = await _storage.read(key: 'token');
      
      final response = await _dio.post(
        '/portfolio/user?page=$page',
        options: Options(
          headers: {
          'Authorization': 'Bearer $token',
        },),
      );

      print('Portfolio:: ${response.data}');

      final List data = response.data['data'];

      return data.map((json) => Portfolio.fromJson(json)).toList();

    }    catch (e) {
      print('Error fetching portfolio: $e');
      rethrow;
    }
  
  }

  Future<List<Portfolio>> getPortfolios({int page =1 }) async {
    try {
      final response = await _dio.get(
        '/portfolio?page=$page'
      );

      print('Portfolio de geral: ${response.data}');

      final List data = response.data['portfolios'];

      return data.map((json) => Portfolio.fromJson(json)).toList();
    } catch (e) {
      print('Error portfolio geral repo: $e');
      rethrow;
    }
  }
  
  Future<Portfolio> getPortfolioId({required int id}) async {
    try {
      // final token = await _storage.read(key: 'token');
      
      final response = await _dio.get(
        '/portfolio/$id',
        // options: Options(
        //   headers: {
        //   'Authorization': 'Bearer $token',
        // },),
      );

      // Se o backend retornar um objeto:
      if (response.data['portfolio'] is Map) {
        return Portfolio.fromJson(response.data['portfolio']);
      }

      // Se retornar uma lista com 1 item:
      final data = response.data['portfolio'];
      if (data is List && data.isNotEmpty) {
        return Portfolio.fromJson(data[0]);
      }

      throw Exception('Portfolio não encontrado:, ${response.data}' );

    }    catch (e) {
      print('Error fetching portfolio: $e');
      rethrow;
    }
  
  }
}