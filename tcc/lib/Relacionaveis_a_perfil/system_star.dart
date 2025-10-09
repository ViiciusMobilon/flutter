import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EstrelaRating extends StatelessWidget {
  final double estrelas;
  EstrelaRating({super.key, required this.estrelas});

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

class estrelaperfil extends StatefulWidget {
  const estrelaperfil({super.key});

  @override
  State<estrelaperfil> createState() => _estrelaperfilState();
}

class _estrelaperfilState extends State<estrelaperfil> {
  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
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
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EstrelaRating extends StatelessWidget {
  const EstrelaRating({super.key});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: 5,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
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

class estrelaperfil extends StatefulWidget {
  const estrelaperfil({super.key});

  @override
  State<estrelaperfil> createState() => _estrelaperfilState();
}

class _estrelaperfilState extends State<estrelaperfil> {
  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
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