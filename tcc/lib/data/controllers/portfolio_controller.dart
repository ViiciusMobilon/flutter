import 'package:flutter/material.dart';
import 'package:tcc/data/models/post.dart';
import 'package:tcc/data/models/postForm.dart';
import 'package:tcc/data/services/portfolio_service.dart';

class PortfolioController extends ChangeNotifier {
  final PortfolioService _service = PortfolioService();
  List<Portfolio> _portfoliosGeral = [];
  List<Portfolio> _portfoliosAuth = [];
  Portfolio? _post;
  int _pageAuth = 1;
  int _pageGeral = 1;
  bool _loadingAuth = false;
  bool _hasMoreAuth = true;
  bool _loadingGeral = false;
  bool _hasMoreGeral = true;

  List<Portfolio> get portfoliosAuth => _portfoliosAuth;
  List<Portfolio> get portfoliosGeral => _portfoliosGeral;
  Portfolio? get post => _post;
  bool get loadingAuth => _loadingAuth;
  bool get hasMoreAuth => _hasMoreAuth;

  bool get loadingGeral => _loadingGeral;
  bool get hasMoreGeral => _hasMoreGeral;

  Future<void> fetchPortfolioAuth({bool refresh = false}) async {
    if (refresh) {
      _pageAuth = 1;
      _hasMoreAuth = true;
      _portfoliosAuth = [];
    }

    if (_loadingAuth || !_hasMoreAuth) return;

    _loadingAuth = true;
    notifyListeners();

    try {
      final newPosts = await _service.getPortfolioAuth(page: _pageAuth);
      print("newPosts: ${newPosts.length}");

      if (newPosts.isEmpty) {
        _hasMoreAuth = false;
      } else {
        _portfoliosAuth.addAll(newPosts);
        _pageAuth++;
      }
      print("portfolio controller: ${newPosts}");
    } finally {
      _loadingAuth = false;
      notifyListeners();
    }
  }

  Future<Portfolio> create(Postform form) async{
    print("Portfolio Controller: $form");
    final portfolio = await _service.createPortfolio(form);
    return portfolio;
  }

  // 🔹 Esse método é o que a tela está tentando chamar
  Future<void> loadMorePostsAuth() async {
    await fetchPortfolioAuth();
  }
  Future<void> loadMorePostsAll({bool refresh = false}) async {
    await fetchPortfolios(refresh: refresh);
  }

  // Future<void> getPortfolioId({int id = 2}) async {
  //   try {
  //      _post = await _service.getPortfolioId(id: id);
  //   } catch (e) {
  //     print("Erro ao buscar portfólio: $e");
  //   } finally {
  //     notifyListeners();
  //     _loading = false;

  //   }
  // }


  Future<void> fetchPortfolios({bool refresh = false}) async {

    if (refresh) {
      _pageGeral = 1;
      _hasMoreGeral = true;
      _portfoliosGeral = [];
    }

    if(_loadingGeral || !_hasMoreGeral) return;

    _loadingGeral = true;
    notifyListeners();
    print('fetchPortfolios chamado em ${DateTime.now()} com refresh=$refresh');

    try {
      final newPosts = await _service.getPortfolios(page: _pageGeral);
      print("newPosts: ${newPosts!.data}");

      if (newPosts.data.isEmpty) {
        _hasMoreGeral = false;
      } else {
        _portfoliosGeral.addAll(newPosts.data);
        _pageGeral = newPosts.currentPage + 1;
        _hasMoreGeral = newPosts.currentPage < newPosts.lastPage;
      }


      print("portfolio controller geral: ${newPosts}");
    } finally {
      _loadingGeral = false;
      notifyListeners();
    }
  }

}
