import 'dart:convert';

import 'package:tcc/data/models/post.dart';
import 'package:tcc/data/repositories/portfolio_repository.dart';

class PortfolioService {
  final PortfolioRepository _repository = PortfolioRepository();



  Future<List<Portfolio>> getPortfolio({int page = 1}) async {
    try{
      final post = await _repository.getPortfolioUser(page: page);
      print('Portfolio service: ${post.length}');
      return post;
    } catch (e) {
      print("Erro no Portfolio service: $e");
      rethrow;
    }

  }
}