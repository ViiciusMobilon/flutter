import 'package:flutter/widgets.dart';
import 'package:projeto_principal/feed.dart';

class FeedImage extends Feed {
  final String text;
  final String url;

  FeedImage({required this.text, required this.url}) : super(text: text);

  @override
  Widget renderContent() {
    return Column(
      children: [ super.renderContent(),
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/imagens/LOGO.png"), //fundo da imagem
          fit: BoxFit.fill,
            
            )
          ),
        ),
       
      ],
    );
  }
}
