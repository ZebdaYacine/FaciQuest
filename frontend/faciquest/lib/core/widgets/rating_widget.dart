import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({
    super.key,
    this.value = 0,
    this.length = 5,
    this.size = RatingSize.small,
    this.onChanged,
    this.color = Colors.amber,
    this.shape = StarRatingShape.star,
  });
  final double value;
  final int length;
  final RatingSize size;
  final StarRatingShape shape;
  final Color color;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) {
          if (index < value.floor()) {
            return GestureDetector(
              onTap: () => onChanged?.call(index.toDouble() + 1),
              child: Icon(
                shape.fullIcon,
                color: color,
                size: size.size,
              ),
            );
          } else if (index == value.floor() && value % 1 != 0) {
            return GestureDetector(
              onTap: () => onChanged?.call(index.toDouble() + 1),
              child: Icon(
                shape.halfIcon,
                color: color,
                size: size.size,
              ),
            );
          }
          return GestureDetector(
            onTap: () => onChanged?.call(index.toDouble() + 1),
            child: Icon(
              shape.outlinedIcon,
              color: color,
              size: size.size,
            ),
          );
        },
      ),
    );
  }
}

enum RatingSize {
  small,
  medium,
  large,
  ;

  double get size {
    switch (this) {
      case RatingSize.small:
        return 24;
      case RatingSize.medium:
        return 32;
      case RatingSize.large:
        return 48;
    }
  }
}

