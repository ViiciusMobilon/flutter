

class RamoModel{
  final int id;
  final String nome;

  RamoModel({required this.id, required this.nome});

  factory RamoModel.fromJson(Map<String, dynamic> json){
    return
      RamoModel(
        id: json['id'] ?? '',
        nome: json['nome'] ?? '',
      );
  } 
}