import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingWidget extends StatelessWidget {
  final bool? isIgnoreGesture;
  final double? initialRating;
  final double? itemSize;
  const RatingWidget(
      {super.key, this.isIgnoreGesture, this.initialRating, this.itemSize});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: initialRating ?? 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      ignoreGestures: isIgnoreGesture ?? true,
      itemCount: 5,
      itemSize: itemSize ?? 16,
      glowColor: Colors.orange,
      itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.orange,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}
