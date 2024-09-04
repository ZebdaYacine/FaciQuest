part of '../question_entity.dart';

class StarRatingQuestion extends QuestionEntity {
  final int maxRating;
  final StarRatingShape shape;
  final Color color;

  const StarRatingQuestion({
    required super.title,
    required super.order,
    super.type = QuestionType.starRating,
    this.maxRating = 5,
    this.shape = StarRatingShape.star,
    this.color = Colors.amber,
  });

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return StarRatingQuestion(
      title: map['title'],
      order: map['order'],
      maxRating: map['maxRating'],
      shape: StarRatingShape.values
          .firstWhere((element) => element.name == map['shape']),
      color: Color(int.parse(map['color'])),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'maxRating': maxRating,
      'shape': shape.name,
      'color': color.value.toString(),
    };
  }

  @override
  QuestionEntity copyWith({
    String? title,
    int? order,
    QuestionType? type,
    int? maxRating,
    StarRatingShape? shape,
    Color? color,
  }) {
    return StarRatingQuestion(
      title: title ?? this.title,
      order: order ?? this.order,
      type: type ?? this.type,
      maxRating: maxRating ?? this.maxRating,
      shape: shape ?? this.shape,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [title, maxRating, shape, color];

  static StarRatingQuestion copyFrom(QuestionEntity question) {
    return StarRatingQuestion(
      title: question.title,
      order: question.order,
    );
  }
}

enum StarRatingShape {
  star,
  circle,
  diamond,
  square,
  hexagon;

  IconData get fullIcon {
    switch (this) {
      case StarRatingShape.star:
        return Icons.star_rounded;
      case StarRatingShape.circle:
        return Icons.circle;
      case StarRatingShape.diamond:
        return Icons.diamond_rounded;
      case StarRatingShape.square:
        return Icons.square;
      case StarRatingShape.hexagon:
        return Icons.hexagon;
    }
  }

  IconData get outlinedIcon {
    switch (this) {
      case StarRatingShape.star:
        return Icons.star_outline_rounded;
      case StarRatingShape.circle:
        return Icons.circle_outlined;
      case StarRatingShape.diamond:
        return Icons.diamond_rounded;
      case StarRatingShape.square:
        return Icons.square_outlined;
      case StarRatingShape.hexagon:
        return Icons.hexagon_outlined;
    }
  }

  IconData get halfIcon {
    switch (this) {
      case StarRatingShape.star:
        return Icons.star_half_rounded;
      case StarRatingShape.circle:
        return Icons.circle_outlined;
      case StarRatingShape.diamond:
        return Icons.diamond_rounded;
      case StarRatingShape.square:
        return Icons.square_outlined;
      case StarRatingShape.hexagon:
        return Icons.hexagon_outlined;
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
