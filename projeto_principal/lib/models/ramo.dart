class ramo{
  int? id;
  String? nome;
  String? modalidade;

  ramo({this.id, this.nome, this.modalidade});

  ramo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    modalidade = json['modalidade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['modalidade'] = modalidade;
    return data;
  }
}