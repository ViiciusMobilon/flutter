
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcc/data/http/dio_client.dart';
import 'package:tcc/data/models/paginate.dart';
import 'package:tcc/data/models/post.dart';
import 'package:tcc/data/models/postForm.dart';

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
      print('URL PORTFOLIO AUTH: ${response.realUri}');


      print('Portfolio:: ${response.data}');

      final List data = response.data['data'];

      return data.map((json) => Portfolio.fromJson(json)).toList();

    }    catch (e) {
      print('Error fetching portfolio: $e');
      rethrow;
    }
  
  }

  Future<PaginationResult<Portfolio>> getPortfolios({int page =1 }) async {
    try {
      final response = await _dio.get(
        '/portfolio?page=$page'
      );
      print('URL PORTFOLIO all: ${response.realUri}');

      print('Portfolio de geral: ${response.data}');
      print('status code getportfolios: ${response.statusCode}');

      final json = response.data;
      final List data = response.data['data'];
      final last_page = response.data['last_page'] ?? 1;
      print('last: ${last_page}');

      return PaginationResult<Portfolio>(
        data: data.map((e) => Portfolio.fromJson(e)).toList(),
        currentPage: json['current_page'] ?? 1,
        lastPage: json['last_page'] ?? 1,
      );
      
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

  Future<Portfolio> createPortfolio(Postform post) async{
      final token = await _storage.read(key: 'token');
    try {
      final map = post.toMap();


      FormData formData = FormData.fromMap({
        ...map,
        if (post.foto != null)
          "imagens[]": [
            for (final f in post.foto!)
              if (f != null)
                await MultipartFile.fromFile(
                  f.path,
                  filename: f.path.split('/').last,
                )
          ],

          if (post.video != null)
          "videos[]":[
            for(final v in post.video!)
              if(v != null)
                await MultipartFile.fromFile(
                  v.path,
                  filename: v.path.split('/').last,
                )
          ]
      });

      final response = await _dio.post('/portfolio/cadastro', data: formData, options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },)
        );


      print('Cadastro Portfolio response.data: ${response.data}');
      final code = response.statusCode;
      print('Cadastro Portfolio response.code: ${code}');
      
      return Portfolio.fromJson(response.data);

    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Erro no cadastro do portfolio');
      } else {
        throw Exception('Erro de conexão');
      }
      
    }
  }


}