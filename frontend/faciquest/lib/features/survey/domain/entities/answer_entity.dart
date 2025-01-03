import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:faciquest/features/features.dart';
import 'package:pluto_grid/pluto_grid.dart';

part 'answers/address_answer.dart';
part 'answers/star_rating_answer.dart';
part 'answers/multiple_choice_answer.dart';
part 'answers/checkboxes_answer.dart';
part 'answers/dropdown_answer.dart';
part 'answers/file_upload_answer.dart';
part 'answers/audio_record_answer.dart';
part 'answers/short_answer_answer.dart';
part 'answers/comment_box_answer.dart';
part 'answers/slider_answer.dart';
part 'answers/date_time_answer.dart';
part 'answers/matrix_answer.dart';
part 'answers/image_choice_answer.dart';
part 'answers/name_answer.dart';
part 'answers/email_address_answer.dart';
part 'answers/phone_answer.dart';
part 'answers/text_answer.dart';
part 'answers/image_answer.dart';

abstract class AnswerEntity extends Equatable {
  final String questionId;

  PlutoCell get plutoCell;

  const AnswerEntity({required this.questionId});

  @override
  List<Object?> get props => [questionId];

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
    };
  }
}

class SubmissionEntity {
  final List<AnswerEntity> answers;
  final String surveyId;
  final String collectorId;

  SubmissionEntity({
    required this.answers,
    required this.surveyId,
    required this.collectorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'surveyId': surveyId,
      'collectorId': collectorId,
      'answers': answers.map((answer) => answer.toMap()).toList(),
    };
  }

  factory SubmissionEntity.fromMap(Map<String, dynamic> map) {
    return SubmissionEntity(
      answers: List<AnswerEntity>.from(
        map['answers']?.map((answer) {
              return switch (getType(answer['type'])) {
                QuestionType.shortAnswer => ShortAnswerAnswer.fromMap(answer),
                QuestionType.commentBox => CommentBoxAnswer.fromMap(answer),
                QuestionType.slider => SliderAnswer.fromMap(answer),
                QuestionType.dateTime => DateTimeAnswer.fromMap(answer),
                QuestionType.matrix => MatrixAnswer.fromMap(answer),
                QuestionType.imageChoice => ImageChoiceAnswer.fromMap(answer),
                QuestionType.nameType => NameAnswer.fromMap(answer),
                QuestionType.emailAddress => EmailAddressAnswer.fromMap(answer),
                QuestionType.phoneNumber => PhoneAnswer.fromMap(answer),
                QuestionType.text => TextAnswer.fromMap(answer),
                QuestionType.image => ImageAnswer.fromMap(answer),
                QuestionType.starRating => StarRatingAnswer.fromMap(answer),
                QuestionType.multipleChoice =>
                  MultipleChoiceAnswer.fromMap(answer),
                QuestionType.checkboxes => CheckboxesAnswer.fromMap(answer),
                QuestionType.dropdown => DropdownAnswer.fromMap(answer),
                QuestionType.fileUpload => FileUploadAnswer.fromMap(answer),
                QuestionType.audioRecord => AudioRecordAnswer.fromMap(answer),
                QuestionType.address => AddressAnswer.fromMap(answer),
              };
            }) ??
            [],
      ),
      surveyId: map['surveyId'] ?? '',
      collectorId: map['collectorId'] ?? '',
    );
  }
}

QuestionType getType(String type) {
  return switch (type) {
    'shortAnswer' => QuestionType.shortAnswer,
    'commentBox' => QuestionType.commentBox,
    'slider' => QuestionType.slider,
    'dateTime' => QuestionType.dateTime,
    'matrix' => QuestionType.matrix,
    'imageChoice' => QuestionType.imageChoice,
    'nameType' => QuestionType.nameType,
    'emailAddress' => QuestionType.emailAddress,
    'phoneNumber' => QuestionType.phoneNumber,
    'text' => QuestionType.text,
    'image' => QuestionType.image,
    'starRating' => QuestionType.starRating,
    'multipleChoice' => QuestionType.multipleChoice,
    'checkboxes' => QuestionType.checkboxes,
    'dropdown' => QuestionType.dropdown,
    'fileUpload' => QuestionType.fileUpload,
    'audioRecord' => QuestionType.audioRecord,
    'address' => QuestionType.address,
    _ => throw Exception('Unknown question type: $type')
  };
}
