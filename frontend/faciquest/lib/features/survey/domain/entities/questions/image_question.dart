part of '../question_entity.dart';

class ImageQuestion extends QuestionEntity {
  ImageQuestion({
    required super.title,
    this.image = const ImageChoice(),
    super.type = QuestionType.image,
  });

  final ImageChoice image;

  @override
  QuestionEntity copyWith({
    String? title,
    QuestionType? type,
    ImageChoice? image,
  }) {
    return ImageQuestion(
      title: title ?? this.title,
      image: image ?? this.image,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return ImageQuestion(
      title: map['title'],
      image: ImageChoice.fromMap(map['image']),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'type': type.name,
      'image': image.toMap(),
    };
  }

  static ImageQuestion copyFrom(QuestionEntity question) {
    return ImageQuestion(title: question.title);
  }
}
