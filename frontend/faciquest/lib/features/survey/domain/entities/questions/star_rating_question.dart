part of '../question_entity.dart';

class StarRatingQuestion extends QuestionEntity {
  final int maxRating;
  final StarRatingShape shape;
  final Color color;

  const StarRatingQuestion({
    required super.title,
    this.maxRating = 5,
    this.shape = StarRatingShape.star,
    this.color = Colors.amber,
  });

  @override
  QuestionEntity fromMap(Map<String, dynamic> map) {
    return StarRatingQuestion(
      title: map['title'],
      maxRating: map['maxRating'],
      shape: StarRatingShape.values
          .firstWhere((element) => element.name == map['shape']),
      color: Color(int.parse(map['color'])),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'maxRating': maxRating,
      'shape': shape.name,
      'color': color.value.toString(),
    };
  }

  @override
  QuestionEntity copyWith({
    String? title,
    int? maxRating,
    StarRatingShape? shape,
    Color? color,
  }) {
    return StarRatingQuestion(
      title: title ?? this.title,
      maxRating: maxRating ?? this.maxRating,
      shape: shape ?? this.shape,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [title, maxRating, shape, color];
}

enum StarRatingShape {
  star,
  circle,
  diamond,
  square,
  hexagon;

  IconData get icon {
    switch (this) {
      case StarRatingShape.star:
        return Icons.star;
      case StarRatingShape.circle:
        return Icons.circle;
      case StarRatingShape.diamond:
        return Icons.diamond;
      case StarRatingShape.square:
        return Icons.square;

      case StarRatingShape.hexagon:
        return Icons.hexagon;
    }
  }
}

enum StarRatingColors {
  yellow,
  grey,
  green,
  red;

  Color get color {
    switch (this) {
      case StarRatingColors.yellow:
        return Colors.amber;
      case StarRatingColors.grey:
        return Colors.grey;
      case StarRatingColors.green:
        return Colors.green;
      case StarRatingColors.red:
        return Colors.red;
    }
  }
}
