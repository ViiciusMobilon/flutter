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
      id: json['id'] as int,
      userId: json['user_id'] as int,
      disponivel: (json['disponivel'] as int?) == 1, // <-- conversão
      nome: json['nome'] as String?,
      razao_social: json['razao_social'] as String?,
      cpf: json['cpf'] as String?,
      cnpj: json['cnpj'] as String?,
      descricao: json['descricao'] as String?,
      foto: json['foto'] as String?,
      capa: json['capa'] as String?,
      localidade: json['localidade'] as String?,
      uf: json['uf'] as String?,
      estado: json['estado'] as String?,
      cep: json['cep'] as String?,
      numero: json['numero'] as String?,
      rua: json['rua'] as String?,
      infoadd: json['infoadd'] as String?,
      ramoNome: json['ramo']?['nome'] as String?,
      categoriaNome: json['categoria']?['nome'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
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