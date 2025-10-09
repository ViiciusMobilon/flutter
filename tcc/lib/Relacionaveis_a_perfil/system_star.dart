import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
  final double estrelas;

  const EstrelaPerfil({super.key, this.estrelas = 5});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: estrelas,
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
