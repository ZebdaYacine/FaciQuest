import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

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

class AnswerEntity extends Equatable {
  final String questionId;

  const AnswerEntity({required this.questionId});

  @override
  List<Object?> get props => [questionId];

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
    };
  }
}

class Submission {
  final List<AnswerEntity> answers;
  final String surveyId;

  Submission({
    required this.answers,
    required this.surveyId,
  });

  Map<String, dynamic> toMap() {
    return {
      'surveyId': surveyId,
      'answers': answers.map((answer) => answer.toMap()).toList(),
    };
  }
}
