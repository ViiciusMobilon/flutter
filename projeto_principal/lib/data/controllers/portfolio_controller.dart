import 'package:flutter/material.dart';
import 'package:projeto_principal/data/models/post.dart';
import 'package:projeto_principal/data/services/portfolio_service.dart';

class PortfolioController extends ChangeNotifier {
  final PortfolioService _service = PortfolioService();
  List<Portfolio> _portfolios = [];
  int _page = 1;
  bool _loading = false;
  bool _hasMore = true;

  List<Portfolio> get portfolios => _portfolios;
  bool get loading => _loading;

  Future<void> fetchPortfolio({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
      _portfolios = [];
    }

    if (_loading || !_hasMore) return;

    _loading = true;
    notifyListeners();

    try {
      final newPosts = await _service.getPortfolio(page: _page);

      if (newPosts.isEmpty) {
        _hasMore = false;
      } else {
        _portfolios.addAll(newPosts);
        _page++;
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // 🔹 Esse método é o que a tela está tentando chamar
  Future<void> loadMorePosts() async {
    await fetchPortfolio();
  }
}
