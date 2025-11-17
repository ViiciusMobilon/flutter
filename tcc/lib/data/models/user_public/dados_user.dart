class DadosUsuario {
  final int id;
  final int userId;
  final int disponivel;
  final String? nome;
  final String? cpf;
  final String? descricao;
  final String? foto;
  final String? capa;
  final String? localidade;
  final String? uf;
  final String? estado;
  final String? cep;
  final String? numero;
  final String? rua;
  final String? infoadd;
  final String? ramoNome;
  final String? categoriaNome;
  final String? createdAt;
  final String? updatedAt;

  DadosUsuario({
    required this.id,
    required this.userId,
    required this.disponivel,
    this.nome,
    this.cpf,
    this.descricao,
    this.foto,
    this.capa,
    this.localidade,
    this.uf,
    this.estado,
    this.cep,
    this.numero,
    this.rua,
    this.infoadd,
    this.ramoNome,
    this.categoriaNome,
    this.createdAt,
    this.updatedAt,
  });

  factory DadosUsuario.fromJson(Map<String, dynamic> json) {
    return DadosUsuario(
      id: json['id'],
      userId: json['user_id'],
      disponivel: json['disponivel'] ?? 0,
      nome: json['nome'],
      cpf: json['cpf'],
      descricao: json['descricao'],
      foto: json['foto'],
      capa: json['capa'],
      localidade: json['localidade'],
      uf: json['uf'],
      estado: json['estado'],
      cep: json['cep'],
      numero: json['numero'],
      rua: json['rua'],
      infoadd: json['infoadd'],
      ramoNome: json['ramo']['nome'],
      categoriaNome: json['categoria']['nome'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
