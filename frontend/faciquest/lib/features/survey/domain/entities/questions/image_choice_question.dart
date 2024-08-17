part of '../question_entity.dart';

class ImageChoiceQuestion extends QuestionEntity {
  ImageChoiceQuestion({
    required super.title,
    super.type = QuestionType.imageChoice,
    this.choices = const [ImageChoice()],
    this.useCheckbox = false,
  });
  final List<ImageChoice> choices;
  final bool useCheckbox;

  @override
  QuestionEntity copyWith({
    String? title,
    QuestionType? type,
    List<ImageChoice>? choices,
    bool? useCheckbox,
  }) {
    return ImageChoiceQuestion(
      title: title ?? this.title,
      choices: choices ?? this.choices,
      useCheckbox: useCheckbox ?? this.useCheckbox,
    );
  }

 static QuestionEntity fromMap(Map<String, dynamic> map) {
    return ImageChoiceQuestion(
      title: map['title'],
      choices: List<ImageChoice>.from(map['choices']),
      useCheckbox: map['useCheckbox'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'choices': choices.map((e) => e.toMap()),
      'useCheckbox': useCheckbox,
      'type': type.name,
    };
  }

  @override
  List<Object?> get props => [title, choices, useCheckbox];
  static ImageChoiceQuestion copyFrom(QuestionEntity question) {
    return ImageChoiceQuestion(title: question.title);
  }
}

class ImageChoice with EquatableMixin {
  final String? caption;
  final String? altText;
  final File? image;
  final String? url;

  const ImageChoice({
    this.caption,
    this.altText,
    this.image,
    this.url,
  });
  @override
  List<Object?> get props => [caption, altText, image, url];

  ImageChoice copyWith({
    String? caption,
    String? altText,
    File? image,
    String? url,
  }) {
    return ImageChoice(
      caption: caption ?? this.caption,
      altText: altText ?? this.altText,
      image: image ?? this.image,
      url: url ?? this.url,
    );
  }

  ImageChoice fromMap(Map<String, dynamic> map) {
    return ImageChoice(
      caption: map['caption'],
      altText: map['altText'],
      url: map['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'caption': caption,
      'altText': altText,
      'url': url,
      // Todo: add image
      // 'image': await image?.readAsBytes()
    };
  }
}
