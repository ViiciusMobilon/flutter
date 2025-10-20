import 'package:flutter_test/flutter_test.dart';
import 'package:tcc/data/repositories/portfolio_repository.dart';
import 'package:tcc/data/services/portfolio_service.dart';
import 'package:tcc/data/controllers/portfolio_controller.dart';

void main() {
  test('Fluxo completo Repository → Service → Controller', () async {
    final repository = PortfolioRepository();
    final service = PortfolioService();
    final controller = PortfolioController();

    final _repoP = await repository.getPortfolios();
    final _serviceP = await service.getPortfolios();
    controller.fetchPortfolios();

    print('Repository Portfolios: $_repoP');
    print('Service Portfolios: $_serviceP');
    print('Controller Portfolios: ${controller}');


    // Aqui você pode fazer asserts se o controller guardar estado
    // expect(controller.userName, equals("Usuário: Jailton"));
  });
}
