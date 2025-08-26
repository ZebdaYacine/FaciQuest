part of '../question_entity.dart';

class ImageQuestion extends QuestionEntity {
  const ImageQuestion({
    required super.id,
    required super.title,
    required super.order,
    this.image = ImageChoice.empty,
    super.type = QuestionType.image,
  });

  final ImageChoice image;
  @override
  bool get isValid => image.isNotEmpty;

  @override
  QuestionEntity copyWith({
    String? id,
    String? title,
    int? order,
    QuestionType? type,
    ImageChoice? image,
  }) {
    return ImageQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      image: image ?? this.image,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return ImageQuestion(
      id: map['id'],
      title: map['title'],
      order: map['order'],
      image: ImageChoice.fromMap(map['image']),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'image': image.toMap(),
    };
  }

  static ImageQuestion copyFrom(QuestionEntity question) {
    return ImageQuestion(
      id: question.id,
      title: question.title,
      order: question.order,
    );
  }
}
