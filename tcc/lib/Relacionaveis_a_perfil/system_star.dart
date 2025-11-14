import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:tcc/data/controllers/auth_controller.dart';

/// EstrelaRating: barra de avaliação interativa
class EstrelaRating extends StatelessWidget {
  final double initialRating;
  final bool isInteractive;

  const EstrelaRating({
    super.key,
    this.initialRating = 5,
    this.isInteractive = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isInteractive) {
      return RatingBar.builder(
        initialRating: initialRating,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        updateOnDrag: false, // não arrasta
        glow: false,         // sem sombra ao tocar
        itemCount: 5,
        itemSize: 32,
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {
          print("Usuário avaliou: $rating estrelas");
        },
      );
    } else {
      return RatingBarIndicator(
        rating: initialRating,
        direction: Axis.horizontal,
        itemCount: 5,
        itemSize: 32,
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
      );
    }
  }
}

/// EstrelaPerfil: apenas exibe estrelas (não interativa)
class EstrelaPerfil extends StatelessWidget {
  // final double estrelas;

  const EstrelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AuthController>();
    final user = controller.usuario;
    var estrelas = user!.avaliacaoMedia;
    print("Estrelas do usuario: ${estrelas}");
    return RatingBarIndicator(
      rating: estrelas == null ? estrelas = 5 : estrelas,
      direction: Axis.horizontal,
      itemCount: 5,
      itemSize: 32,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
    );
  }
}
