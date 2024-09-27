part of '../question_entity.dart';

class ImageChoiceQuestion extends QuestionEntity {
  const ImageChoiceQuestion({
    required super.id,
    required super.title,
    required super.order,
    super.type = QuestionType.imageChoice,
    this.choices = const [ImageChoice.empty],
    this.multipleSelect = false,
  });
  final List<ImageChoice> choices;
  final bool multipleSelect;
  @override
  bool get isValid =>
      super.isValid &&
      choices.isNotEmpty &&
      choices.every(
        (element) => element.isNotEmpty,
      );

  @override
  QuestionEntity copyWith({
    String? id,
    String? title,
    int? order,
    QuestionType? type,
    List<ImageChoice>? choices,
    bool? useCheckbox,
  }) {
    return ImageChoiceQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      choices: choices ?? this.choices,
      multipleSelect: useCheckbox ?? this.multipleSelect,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return ImageChoiceQuestion(
      id: map['id'],
      title: map['title'],
      order: map['order'],
      choices: List<ImageChoice>.from(
          map['choices'].map((e) => ImageChoice.fromMap(e))),
      multipleSelect: map['useCheckbox'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'choices': choices.map((e) => e.toMap()).toList(),
      'useCheckbox': multipleSelect,
    };
  }

  @override
  List<Object?> get props => [...super.props, choices, multipleSelect];
  static ImageChoiceQuestion copyFrom(QuestionEntity question) {
    return ImageChoiceQuestion(
      id: question.id,
      title: question.title,
      order: question.order,
    );
  }
}

class ImageChoice with EquatableMixin {
  final String id;
  final String? caption;
  final String? altText;
  final File? image;
  final String? url;

  const ImageChoice({
    required this.id,
    this.caption,
    this.altText,
    this.image,
    this.url,
  });
  @override
  List<Object?> get props => [id, caption, altText, image, url];

  ImageChoice copyWith({
    String? id,
    String? caption,
    String? altText,
    File? image,
    String? url,
  }) {
    return ImageChoice(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      altText: altText ?? this.altText,
      image: image ?? this.image,
      url: url ?? this.url,
    );
  }

  static ImageChoice fromMap(Map<String, dynamic> map) {
    return ImageChoice(
      id: map['id'],
      caption: map['caption'],
      altText: map['altText'],
      url: map['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'caption': caption,
      'altText': altText,
      'url': url,
      // Todo: add image
      // 'image': await image?.readAsBytes()
    };
  }

  static const empty = ImageChoice(id: '');
  bool get isEmpty => this == ImageChoice.empty;

  bool get isNotEmpty => this != ImageChoice.empty;
}
