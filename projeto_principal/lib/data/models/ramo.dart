

class RamoModel{
  final int id;
  final String nome;
  final String modalidade;

  RamoModel({required this.id, required this.nome, required this.modalidade});

  factory RamoModel.fromJson(Map<String, dynamic> json){

    return
      RamoModel(
        id: json['id'] ?? '',
        nome: json['nome'] ?? '',
        modalidade: json['modalidade'] ?? '',
      );
  } 
}