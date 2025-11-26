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