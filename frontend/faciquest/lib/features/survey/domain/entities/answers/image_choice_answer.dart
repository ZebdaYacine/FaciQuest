part of '../answer_entity.dart';

class ImageChoiceAnswer extends AnswerEntity {
  const ImageChoiceAnswer({
    required super.questionId,
    required this.selectedChoices,
    required this.multipleSelect,
  });
  final bool multipleSelect;
  final Set<String> selectedChoices;

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'selectedChoices': selectedChoices.toList(),
    };
  }

  @override
  List<Object?> get props => [super.props, selectedChoices];

  ImageChoiceAnswer copyWith({Set<String>? selectedChoices}) {
    return ImageChoiceAnswer(
      questionId: questionId,
      selectedChoices: selectedChoices ?? this.selectedChoices,
      multipleSelect: multipleSelect,
    );
  }

  ImageChoiceAnswer setValue(String value) {
    final newSelectedChoices = <String>{...selectedChoices};
    if (multipleSelect) {
      if (newSelectedChoices.contains(value)) {
        newSelectedChoices.remove(value);
      } else {
        newSelectedChoices.add(value);
      }
    } else {
      newSelectedChoices.clear();
      newSelectedChoices.add(value);
    }
    return copyWith(selectedChoices: newSelectedChoices);
  }

  String? getSelectedChoice(String id) {
    if (multipleSelect) return null;
    return selectedChoices.firstWhereOrNull(
      (element) => element == id,
    );
  }
}
