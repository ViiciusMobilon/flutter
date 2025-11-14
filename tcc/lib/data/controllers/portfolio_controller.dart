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
  bool _loading = false;
  bool _hasMoreAuth = true;
  bool _carregadoAuth = false;
  bool _loadingGeral = false;
  bool _hasMoreGeral = true;

  List<Portfolio> get portfoliosAuth => _portfoliosAuth;
  List<Portfolio> get portfoliosGeral => _portfoliosGeral;
  Portfolio? get post => _post;
  bool get loading => _loading;
  bool get loadingAuth => _loadingAuth;
  bool get hasMoreAuth => _hasMoreAuth;
  bool get carregadoAuth => _carregadoAuth;

  bool get loadingGeral => _loadingGeral;
  bool get hasMoreGeral => _hasMoreGeral;

  void resetarFeed(){
    _carregadoAuth = false;
    _pageAuth = 1;
    _hasMoreAuth = true;
    _portfoliosAuth.clear();
    notifyListeners();
  }

//   Future<void> fetchPortfolioAuth({bool refresh = false}) async {
//     portfoliosAuth.clear();
//     if (_loadingAuth) return;

    
//     if (refresh) {
//       _pageAuth = 1;
//       _hasMoreAuth = true;
//       _portfoliosAuth = [];
//       _carregadoAuth = false;
//     }

//     if (_carregadoAuth && !refresh) return;


//     _loadingAuth = true;
//     notifyListeners();

//     try {
//       final newPosts = await _service.getPortfolioAuth(page: _pageAuth);
//       print("newPosts: ${newPosts.length}");
//       if (newPosts.isEmpty) {
//         _hasMoreAuth = false;
//       } else {
//       final idsExistentes = _portfoliosAuth.map((p) => p.id).toSet();
//       final postsFiltrados = newPosts.where((p) => !idsExistentes.contains(p.id)).toList();

//       if (postsFiltrados.isEmpty) {
//         _hasMoreAuth = false;
//       } else {
//         _portfoliosAuth.addAll(postsFiltrados);
//         _pageAuth++;
//         _carregadoAuth = true; // ✅ só marca se de fato adicionou novos
//       }
// }
//     } finally {
//       _loadingAuth = false;
//       notifyListeners();
//     }
//   }


  // Future<void> fetchPortfolioAuth({bool refresh = false}) async {
  //   if (_loadingAuth) return;

  //   if (refresh) {
  //     _pageAuth = 1;
  //     _hasMoreAuth = true;
  //     _portfoliosAuth.clear();
  //     _carregadoAuth = false;
  //   }

  //   // Se já foi carregado e não é refresh, não faz nada
  //   if (_carregadoAuth && !refresh) return;

  //   _loadingAuth = true;
  //   notifyListeners();

  //   try {
  //     final newPosts = await _service.getPortfolioAuth(page: _pageAuth);
  //     print("newPosts: ${newPosts.length}");

  //     if (newPosts.isEmpty) {
  //       _hasMoreAuth = false;
  //     } else {
  //       // evita duplicados
  //       final idsExistentes = _portfoliosAuth.map((p) => p.id).toSet();
  //       final postsFiltrados =
  //           newPosts.where((p) => !idsExistentes.contains(p.id)).toList();

  //       if (postsFiltrados.isNotEmpty) {
  //         _portfoliosAuth.addAll(postsFiltrados);
  //         _pageAuth++;
  //       } else {
  //         _hasMoreAuth = false;
  //       }

  //       _carregadoAuth = true;
  //     }
  //   } finally {
  //     _loadingAuth = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> fetchPortfolioAuth({bool refresh = false}) async {
    if (_loadingAuth) return;

    if (refresh) {
      _pageAuth = 1;
      _hasMoreAuth = true;
      _portfoliosAuth.clear(); // limpa a lista
      _carregadoAuth = false;
    }

    if (_carregadoAuth && !refresh && _pageAuth > 1 && !_hasMoreAuth) return;

    _loadingAuth = true;
    notifyListeners();

    try {
      final newPosts = await _service.getPortfolioAuth(page: _pageAuth);

      if (newPosts.isEmpty) {
        _hasMoreAuth = false;
      } else {
        // Sempre adiciona somente novos posts, sem duplicados
        final idsExistentes = _portfoliosAuth.map((p) => p.id).toSet();
        final postsFiltrados =
            newPosts.where((p) => !idsExistentes.contains(p.id)).toList();

        if (postsFiltrados.isNotEmpty) {
          _portfoliosAuth.addAll(postsFiltrados);
          _pageAuth++;
        } else {
          _hasMoreAuth = false;
        }
      }
    } finally {
      _loadingAuth = false;
      _carregadoAuth = true;
      notifyListeners();
    }
  }



  Future<Portfolio> create(Postform form) async{
    print("Portfolio Controller: $form");
    final portfolio = await _service.createPortfolio(form);
    return portfolio;
  }

  // 🔹 Esse método é o que a tela está tentando chamar
  Future<void> loadMorePostsAuth({bool refresh = false}) async {
    if (_loadingAuth || !_hasMoreAuth) return;
    await fetchPortfolioAuth(refresh: refresh);
  }
  Future<void> loadMorePostsAll({bool refresh = false}) async {
    await fetchPortfolios(refresh: refresh);
  }

  void setPost(Portfolio portfolio){
    _post = portfolio;
    notifyListeners();
  }

  Future<void> getPortfolioId({required int id}) async {
    try {
       _post = await _service.getPortfolioId(id: id);
       print("getportfolioidcontroller: ${_post.toString()}");
    } catch (e) {
      print("Erro ao buscar portfólio: $e");
    } finally {
      notifyListeners();
      _loading = false;

    }
  }


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


  Future<Portfolio> updade(Postform form,{required int idPost}) async {
    try {
      final result = await _service.update( form,idPost: idPost);
      if(result != null){
        _post = result;
        notifyListeners();
      }
      

      return result;
    } catch (e) {
      print("erro update post controller: $e");
      rethrow;
    }
  }
}
