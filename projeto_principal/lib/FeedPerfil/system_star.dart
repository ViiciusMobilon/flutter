import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EstrelaRating extends StatelessWidget {
  const EstrelaRating({super.key});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      updateOnDrag: false, // ❌ não arrasta
      glow: false,         // ❌ sem sombra ao tocar
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
  }
}
