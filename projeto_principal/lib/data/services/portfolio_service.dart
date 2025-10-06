import 'dart:convert';

import 'package:projeto_principal/data/models/post.dart';
import 'package:projeto_principal/data/repositories/portfolio_repository.dart';

class PortfolioService {
  final PortfolioRepository _repository = PortfolioRepository();



  Future<Portfolio?> getPortfolio({int page = 1}) async {
    try{
      final post = await _repository.getPortfolioUser(page: page);
      print('Portfolio service: ${post?.descricao}');
      return post;
    } catch (e) {
      print("Erro no Portfolio service: $e");
      rethrow;
    }

  }
}