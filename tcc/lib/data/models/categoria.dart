class CategoriaModel{
   final int id;
  final String nome;

  CategoriaModel({required this.id, required this.nome});

  factory CategoriaModel.fromJson(Map<String, dynamic> json){
    return
      CategoriaModel(
        id: json['id'] ?? '',
        nome: json['nome'] ?? '',
      );
  } 
}