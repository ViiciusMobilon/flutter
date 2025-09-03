import 'package:projeto_principal/data/models/ramo.dart';
import 'package:projeto_principal/data/http/http_client.dart';
import 'package:projeto_principal/data/repositories/cep_repository.dart';

abstract class IRamoRepository{
  Future<RamoModel> getRamo();
}

class RamoRepository {

  final IHttpClient client;

  RamoRepository({required this.client});

  @override
  Future<RamoModel> getRamo() async {

    final response = client.get(url: 'api/ramo');

    if (response.statusCode == 200) {
      // final List<CepModel> ceps = [];

      final body = jsonDecode(response.body);

      return RamoModel.fromJson(body);

  }


}