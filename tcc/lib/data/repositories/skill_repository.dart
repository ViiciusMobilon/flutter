import 'package:dio/dio.dart';
import '../config.dart';
import '../models/Skill.dart';

abstract class ISkillRepository {
  Future<List<SkillModel>> getSkill({required int id});
}

class SkillRepository implements ISkillRepository {
  final Dio client;

  SkillRepository({required this.client});

  @override
  Future<List<SkillModel>> getSkill({required int id}) async {
    try {
      final response = await client.get('$URLAPI/skills/$id');

      final List body = response.data;

      return body.map((e) => SkillModel.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Erro na API: ${e.response?.statusCode}');
      } else {
        throw Exception('Erro de conexão');
      }
    }
  }
}
