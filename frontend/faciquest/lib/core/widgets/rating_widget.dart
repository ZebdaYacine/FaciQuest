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
    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(
        length,
        (index) {
          final IconData icon;
          if (index < value.floor()) {
            icon = shape.fullIcon;
          } else if (index == value.floor() && value % 1 != 0) {
            icon = shape.halfIcon;
          } else {
            icon = shape.outlinedIcon;
          }

          final label = '${index + 1} / $length';
          return Semantics(
            button: onChanged != null,
            selected: index < value.ceil(),
            label: label,
            excludeSemantics: true,
            child: IconButton(
              tooltip: label,
              onPressed: onChanged == null
                  ? null
                  : () => onChanged?.call(index.toDouble() + 1),
              icon: Icon(icon, color: color, size: size.size),
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
