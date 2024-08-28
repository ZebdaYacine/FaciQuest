part of '../question_entity.dart';

class ImageQuestion extends QuestionEntity {
  ImageQuestion({
    required super.title,
    required super.order,
    this.image = const ImageChoice(),
    super.type = QuestionType.image,
  });

  final ImageChoice image;

  @override
  QuestionEntity copyWith({
    String? title,
    int? order,
    QuestionType? type,
    ImageChoice? image,
  }) {
    return ImageQuestion(
      title: title ?? this.title,
      order: order ?? this.order,
      image: image ?? this.image,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return ImageQuestion(
      title: map['title'],
      order: map['order'],
      image: ImageChoice.fromMap(map['image']),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'type': type.name,
      'image': image.toMap(),
    };
  }

  static ImageQuestion copyFrom(QuestionEntity question) {
    return ImageQuestion(
      title: question.title,
      order: question.order,
    );
  }
}
