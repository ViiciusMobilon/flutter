class SkillModel{
  final int id;
  final String nome;
  final int id_ramo;

  SkillModel({required this.id, required this.nome, required this.id_ramo});

  factory SkillModel.fromJson(Map<String, dynamic> json){

    return
      SkillModel(
        id: json['id'] ?? '',
        nome: json['nome'] ?? '',
        id_ramo: json['id'] ?? ''
      );
  } 
}