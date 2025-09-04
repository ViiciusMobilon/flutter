class CidadeModel{
  final int id;
  final int id_estado;
  final String nome;

  CidadeModel({required this.id, required this.id_estado, required this.nome});

  factory CidadeModel.fromJson(Map<String, dynamic> json){
    return CidadeModel(
      id: json['id'] ?? '',
      id_estado: json['id_estado'] ?? '',
      nome: json['nome'] ?? '');
  }
}