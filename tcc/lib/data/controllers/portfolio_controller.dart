import 'package:flutter/material.dart';
import 'package:tcc/data/models/post.dart';
import 'package:tcc/data/services/portfolio_service.dart';

class PortfolioController extends ChangeNotifier {
  final PortfolioService _service = PortfolioService();
  List<Portfolio> _portfolios = [];
  Portfolio? _post;
  int _page = 1;
  bool _loading = false;
  bool _hasMore = true;

  List<Portfolio> get portfolios => _portfolios;
  Portfolio? get post => _post;
  bool get loading => _loading;

  Future<void> fetchPortfolioAuth({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
      _portfolios = [];
    }

    if (_loading || !_hasMore) return;

    _loading = true;
    notifyListeners();

    try {
      final newPosts = await _service.getPortfolioAuth(page: _page);
      print("newPosts: ${newPosts.length}");

      if (newPosts.isEmpty) {
        _hasMore = false;
      } else {
        _portfolios.addAll(newPosts);
        _page++;
      }
      print("portfolio controller: ${newPosts}");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // 🔹 Esse método é o que a tela está tentando chamar
  Future<void> loadMorePosts() async {
    await fetchPortfolioAuth();
  }

  Future<void> getPortfolioId({int id = 2}) async {
    try {
       _post = await _service.getPortfolioId(id: id);
    } catch (e) {
      print("Erro ao buscar portfólio: $e");
    } finally {
      notifyListeners();
      _loading = false;

    }
  }
}
