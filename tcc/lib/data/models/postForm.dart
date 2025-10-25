import 'dart:io';

class Postform {
  String? descricao;
  List<File?>? foto;
  List<File?>? video;


  Postform({
    this.descricao,
    this.foto,
    this.video
  });

  @override
  String toString(){
    return 'PostForm: (desc: $descricao, fotos: $foto, videos:$video)';
  }


  Map<String, dynamic> toMap(){
    return{
      'descricao': descricao,
      'foto': foto,
      'video': video,
    };
  }
}