import 'dart:io';

class Postform {
  int? id;
  String? descricao;
  List<File?>? foto;
  List<File?>? video;


  Postform({

    this.id,
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