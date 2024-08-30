part of '../question_entity.dart';

enum FileUploadType {
  pdf,
  doc,
  jpg,
  png,
  gif,
  ;

  String get name {
    switch (this) {
      case FileUploadType.pdf:
        return 'PDF';
      case FileUploadType.doc:
        return 'DOC, DOCX';
      case FileUploadType.jpg:
        return 'JPG, JPEG';
      case FileUploadType.png:
        return 'PNG';
      case FileUploadType.gif:
        return 'GIF';
    }
  }

  List<String> get allowedExtensions => extensions[this]!;

  static Set<FileUploadType> fromMap(List<String> map) {
    final set = <FileUploadType>{};
    for (final e in map) {
      final temp = extensions.entries
          .firstWhereOrNull(
            (element) => element.value.contains(e),
          )
          ?.key;
      if (temp != null) {
        set.add(temp);
      }
    }
    return set;
  }
}

final Map<FileUploadType, List<String>> extensions = {
  FileUploadType.pdf: ['pdf'],
  FileUploadType.doc: ['doc', 'docx'],
  FileUploadType.jpg: ['jpg', 'jpeg'],
  FileUploadType.png: ['png'],
  FileUploadType.gif: ['gif'],
};

class FileUploadQuestion extends QuestionEntity {
  const FileUploadQuestion({
    required super.title,
    required super.order,
    super.type = QuestionType.fileUpload,
    this.allowedExtensions = const {},
    this.instructions,
  });

  final String? instructions;
  final Set<FileUploadType> allowedExtensions;
  @override
  bool get isValid => super.isValid && allowedExtensions.isNotEmpty;
  @override
  QuestionEntity copyWith({
    String? title,
    int? order,
    QuestionType? type,
    List<FileUploadType>? allowedExtensions,
    String? instructions,
  }) {
    return FileUploadQuestion(
      title: title ?? this.title,
      order: order ?? this.order,
      allowedExtensions: allowedExtensions?.toSet() ?? this.allowedExtensions,
      instructions: instructions ?? this.instructions,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return FileUploadQuestion(
      title: map['title'],
      order: map['order'],
      instructions: map['instructions'],
      allowedExtensions: FileUploadType.fromMap(map['allowedExtensions']),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final List<String> allowedExtensions = this
        .allowedExtensions
        .map((e) => e.allowedExtensions)
        .expand(
          (element) => element,
        )
        .toList();
    return <String, dynamic>{
      ...super.toMap(),
      'instructions': instructions,
      'allowedExtensions': allowedExtensions,
    };
  }

  @override
  List<Object?> get props => [title, instructions, allowedExtensions];

  static FileUploadQuestion copyFrom(QuestionEntity question) {
    return FileUploadQuestion(
      title: question.title,
      order: question.order,
    );
  }
}
