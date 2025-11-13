import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EstrelaRating extends StatelessWidget {
  const EstrelaRating({super.key});

  void _mostrarConfirmacao(BuildContext context, double rating) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Confirmar avaliação",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("Deseja avaliar este perfil com $rating estrelas?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Você avaliou com $rating estrelas!"),
                  backgroundColor: Colors.blueAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: const Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: 5,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      updateOnDrag: false,
      glow: false,
      itemCount: 5,
      itemSize: 32,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        _mostrarConfirmacao(context, rating);
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
