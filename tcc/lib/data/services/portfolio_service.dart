import 'dart:convert';

import 'package:tcc/data/models/post.dart';
import 'package:tcc/data/repositories/portfolio_repository.dart';

class PortfolioService {
  final PortfolioRepository _repository = PortfolioRepository();



  Future<List<Portfolio>> getPortfolioAuth({int page = 1}) async {
    try{
      final post = await _repository.getPortfolioAuth(page: page);
      print('Portfolio service: ${post.length}');
      return post;
    } catch (e) {
      print("Erro no Portfolio service: $e");
      rethrow;
    }

  }

  Future<List<Portfolio>?> getPortfolios({int page =1 }) async {
    try {
      final posts = await _repository.getPortfolios();
      print('portfolio geral service: ${posts.length}');
      return posts;
    } catch (e) {
      print("Erro no Portfolio service: $e");
      rethrow;
    }
  }

  Future<Portfolio> getPortfolioId({required int id}) async {
    try{
      final post = await _repository.getPortfolioId(id: id);
      print('Portfolio id service: ${post.id}');
      return post;
    } catch (e) {
      print("Erro no Portfolio service: $e");
      rethrow;
    }

  }
}