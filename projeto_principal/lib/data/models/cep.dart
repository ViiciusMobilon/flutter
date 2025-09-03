
class CepModel{
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;
  final String estado;

  CepModel
    (
      {
        required this.cep,
        required this.logradouro, 
        required this.complemento, 
        required this.bairro, 
        required this.localidade, 
        required this.uf, 
        required this.estado
      }
    );

  factory CepModel.fromJson(Map<String, dynamic> json) {
    return CepModel(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      complemento: json['complemento'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      estado: json['estado'] ?? '',
      uf: json['uf'] ?? '',
    );
  }
}