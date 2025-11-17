class DadosUsuario {
  final int id;
  final int userId;
  final bool disponivel;
  final String? nome;
  final String? razao_social;
  final String? cpf;
  final String? cnpj;
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
    this.razao_social,
    this.cpf,
    this.cnpj,
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
      disponivel: json['disponivel'] ?? false,
      nome: json['nome'],
      razao_social: json['razao_social'],
      cpf: json['cpf'],
      cnpj: json['cnpj'],
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
      ramoNome: json['ramo']?['nome'],
      categoriaNome: json['categoria']?['nome'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'userId': userId,
      'disponivel':disponivel,
      'nome':nome,
      'razaosocial':razao_social,
      'cpf':cpf,
      'cnpj':cnpj,
      'descricao': descricao,
      'foto': foto,
      'capa':capa,
      'localidade':localidade,
      'uf':uf,
      'estado':estado,
      'cep':cep,
      'numero':numero,
      'rua':rua,
      'infoadd':infoadd,
      'ramoNome':ramoNome,
      'categoriaNome': categoriaNome,
      'createdAt':createdAt,
      'updatedAt':updatedAt,
    };
  }
}