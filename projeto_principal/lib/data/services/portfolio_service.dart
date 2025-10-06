import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projeto_principal/data/models/post.dart';
import 'package:projeto_principal/data/repositories/portfolio_repository.dart';

class PortfolioService {
  final PortfolioRepository _repository = PortfolioRepository();



  Future<Portfolio?> getPortfolio() async {
    try{
      final post = await _repository.getPortfolioUser();
      print('Portfolio service: $post.descricao');
      return post;
    } catch (e) {
      print("Erro no Portfolio service: $e");
      rethrow;
    }

  }
}