import 'dart:io';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'questions/star_rating_question.dart';
part 'questions/multiple_choice_question.dart';
part 'questions/checkboxes_question.dart';
part 'questions/dropdown_question.dart';
part 'questions/file_upload_question.dart';
part 'questions/audio_record_question.dart';
part 'questions/short_answer_question.dart';
part 'questions/comment_box_question.dart';
part 'questions/slider_question.dart';
part 'questions/date_time_question.dart';
part 'questions/matrix_question.dart';
part 'questions/image_choice_question.dart';
part 'questions/name_question.dart';
part 'questions/email_address_question.dart';
part 'questions/phone_question.dart';
part 'questions/address_question.dart';
part 'questions/text_question.dart';
part 'questions/image_question.dart';

enum QuestionType {
  starRating,
  multipleChoice,
  imageChoice,
  checkboxes,
  dropdown,
  matrix,
  fileUpload,
  audioRecord,
  shortAnswer,
  commentBox,
  slider,
  dateTime,
  nameType,
  emailAddress,
  phoneNumber,
  address,
  text,
  image,
  ;

  String get name {
    switch (this) {
      case QuestionType.starRating:
        return 'Star Rating';
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.checkboxes:
        return 'Checkboxes';
      case QuestionType.dropdown:
        return 'Dropdown';
      case QuestionType.fileUpload:
        return 'File Upload';
      case QuestionType.commentBox:
        return 'Comment Box';
      case QuestionType.slider:
        return 'Slider';
      case QuestionType.dateTime:
        return 'Date / Time';
      case QuestionType.audioRecord:
        return 'Audio Record';
      case QuestionType.shortAnswer:
        return 'Short Answer';
      case QuestionType.matrix:
        return 'Matrix';
      case QuestionType.imageChoice:
        return 'Image Choice';
      case QuestionType.nameType:
        return 'Name';
      case QuestionType.emailAddress:
        return 'Email Address';
      case QuestionType.phoneNumber:
        return 'Phone Number';
      case QuestionType.address:
        return 'Address';
      case QuestionType.text:
        return 'Text';
      case QuestionType.image:
        return 'Image';
    }
  }

  IconData get icon {
    switch (this) {
      case QuestionType.starRating:
        return Icons.star_outline_rounded;
      case QuestionType.multipleChoice:
        return Icons.radio_button_checked;
      case QuestionType.checkboxes:
        return Icons.check_box_outlined;
      case QuestionType.dropdown:
        return Icons.arrow_drop_down_circle_outlined;
      case QuestionType.fileUpload:
        return Icons.cloud_upload_outlined;
      case QuestionType.commentBox:
        return Icons.comment_outlined;
      case QuestionType.slider:
        return Icons.slideshow;
      case QuestionType.dateTime:
        return Icons.calendar_today;
      case QuestionType.audioRecord:
        return Icons.mic_outlined;
      case QuestionType.shortAnswer:
        return Icons.short_text_outlined;
      case QuestionType.matrix:
        return Icons.table_rows_outlined;
      case QuestionType.imageChoice:
        return Icons.image_outlined;
      case QuestionType.nameType:
        return Icons.person_outline;
      case QuestionType.emailAddress:
        return Icons.email_outlined;
      case QuestionType.phoneNumber:
        return Icons.phone_outlined;
      case QuestionType.address:
        return Icons.location_on_outlined;
      case QuestionType.text:
        return Icons.text_fields_outlined;
      case QuestionType.image:
        return Icons.image_outlined;
    }
  }
}

sealed class QuestionEntity extends Equatable {
  final String title;
  final int order;
  final QuestionType type;
  final bool isRequired;

  @override
  List<Object?> get props => [
        title,
        type,
        order,
        isRequired,
      ];

  const QuestionEntity({
    required this.title,
    required this.order,
    required this.type,
    this.isRequired = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'order': order,
      'type': type.name,
      'isRequired': isRequired,
    };
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    final type = QuestionType.values.firstWhere(
      (e) => e.name == map['type'],
    );
    switch (type) {
      case QuestionType.starRating:
        return StarRatingQuestion.fromMap(map);
      case QuestionType.multipleChoice:
        return MultipleChoiceQuestion.fromMap(map);
      case QuestionType.checkboxes:
        return CheckboxesQuestion.fromMap(map);
      case QuestionType.dropdown:
        return DropdownQuestion.fromMap(map);
      case QuestionType.fileUpload:
        return FileUploadQuestion.fromMap(map);
      case QuestionType.audioRecord:
        return AudioRecordQuestion.fromMap(map);
      case QuestionType.shortAnswer:
        return ShortAnswerQuestion.fromMap(map);
      case QuestionType.commentBox:
        return CommentBoxQuestion.fromMap(map);
      case QuestionType.slider:
        return SliderQuestion.fromMap(map);
      case QuestionType.dateTime:
        return DateTimeQuestion.fromMap(map);
      case QuestionType.imageChoice:
        return ImageChoiceQuestion.fromMap(map);
      case QuestionType.matrix:
        return MatrixQuestion.fromMap(map);
      case QuestionType.nameType:
        return NameQuestion.fromMap(map);
      case QuestionType.emailAddress:
        return EmailAddressQuestion.fromMap(map);
      case QuestionType.phoneNumber:
        return PhoneQuestion.fromMap(map);
      case QuestionType.address:
        return AddressQuestion.fromMap(map);
      case QuestionType.text:
        return TextQuestion.fromMap(map);
      case QuestionType.image:
        return ImageQuestion.fromMap(map);
    }
  }

  QuestionEntity copyWith({
    String? title,
    int? order,
    QuestionType? type,
  });
}

final Map<String, List<List<String>>> scaleOptions = {
  'Agree - Disagree': [
    ['Agree', 'Disagree'], // Scale 2
    [
      'Strongly agree',
      'Neither agree nor disagree',
      'Strongly disagree'
    ], // Scale 3

    [
      'Strongly agree',
      'Agree',
      'Neither agree nor disagree',
      'Disagree',
      'Strongly disagree',
    ], // Scale 5
    [
      'Strongly agree',
      'Agree',
      'Somewhat agree',
      'Neither agree nor disagree',
      'Somewhat disagree',
      'Disagree',
      'Strongly disagree',
    ],
  ],
  'Satisfied - Dissatisfied': [
    ['Satisfied', 'Dissatisfied'], // Scale 2
    [
      'Very satisfied',
      'Neither satisfied nor dissatisfied',
      'Very dissatisfied'
    ], // Scale 3

    [
      'Very satisfied',
      'Satisfied',
      'Neither satisfied nor dissatisfied',
      'Dissatisfied',
      'Very dissatisfied'
    ], // Scale 5
    [
      'Very satisfied',
      'Satisfied',
      'Somewhat satisfied',
      'Neither satisfied nor dissatisfied',
      'Somewhat dissatisfied',
      'Dissatisfied',
      'Very dissatisfied'
    ],
  ],
  'Yes - No': [
    ['Yes', 'No']
  ],
  'Likely - Unlikely': [
    ['Likely', 'Unlikely'], // Scale 2
    ['Very likely', 'Neither likely nor unlikely', 'Very unlikely'], // Scale 3

    [
      'Very likely',
      'Likely',
      'Neither likely nor unlikely',
      'Unlikely',
      'Very unlikely'
    ], // Scale 5
    [
      'Very likely',
      'Likely',
      'Somewhat likely',
      'Neither likely nor unlikely',
      'Somewhat unlikely',
      'Unlikely',
      'Very unlikely'
    ], // Scale 7
  ],
  'Familiar - Not familiar': [
    [
      'Extremely familiar',
      'Very Familiar',
      'somewhat familiar',
      'Not so familiar',
      'Not at all familiar',
    ]
  ],
  'A great deal - None at all': [
    ['A great deal', 'A lot', 'A moderate amount', 'A little', 'None at all']
  ],
  'Interested - Not interested': [
    [
      'Extremely interested',
      'Very Interested',
      'somewhat interested',
      'Not so interested',
      'Not at all interested',
    ]
  ],
  'Easy - Difficult': [
    ['Easy', 'Difficult'], // Scale 2
    ['Very easy', 'Neither easy nor difficult', 'Very difficult'], // Scale 3

    [
      'Very easy',
      'Easy',
      'Neither easy nor difficult',
      'Difficult',
      'Very difficult'
    ], // Scale 5
    [
      'Very easy',
      'Easy',
      'Somewhat easy',
      'Neither easy nor difficult',
      'Somewhat difficult',
      'Difficult',
      'Very difficult'
    ], // Scale 7
  ],
  'Always - Never': [
    ['Always', 'Usually', 'Sometimes', 'Rarely', 'Never']
  ],
  'Better - Worse': [
    ['Better', 'Worse'], // Scale 2
    ['Better', 'About the same', 'Worse'], // Scale 3

    [
      'Much better',
      'Better',
      'About the same',
      'Worse',
      'Much worse'
    ], // Scale 5
  ],
  'Approve - Disapprove': [
    ['Approve', 'Disapprove'], // Scale 2
    ['Approve', 'Somewhat Approve', 'Somewhat Disapprove', 'Disapprove'],
    // Scale 3
    [
      'Approve',
      'Somewhat Approve',
      'Neither Approve nor Disapprove',
      'Somewhat Disapprove',
      'Disapprove'
    ], // Scale 5
    [
      'Approve',
      'Somewhat Approve',
      'Neither Approve nor Disapprove',
      'Somewhat Disapprove',
      'Disapprove'
    ], // Scale 7
  ],
  'Above average - Below average': [
    ['Above average', 'Average', 'Below average'],
    [
      'Far above average',
      'Above average',
      'Average',
      'Below average',
      'Far below average'
    ],
  ],
  'High quality - Low quality': [
    ['High quality', 'Low quality'], // Scale 2
    ['High quality', 'Neither high nor low quality', 'Low quality'], // Scale 3
    [
      'Very high quality',
      'High quality',
      'Low quality',
      'Very low quality'
    ], // scale 4
    [
      'Very high quality',
      'High quality',
      'Neither high nor low quality',
      'Low quality',
      'Very low quality'
    ], // scale 5
    [
      'Very high quality',
      'High quality',
      'Somewhat high quality',
      'Neither high nor low quality',
      'Somewhat low quality',
      'Low quality',
      'Very low quality'
    ], // scale 7
  ],
  'True - False': [
    ['True', 'False']
  ],
  'Definitely would - Definitely would not': [
    [
      'Definitely would',
      'Probably would',
      'Probably would not',
      'Definitely would not'
    ]
  ],
  'Useful - Not useful': [
    [
      'Extremely useful',
      'Very Useful',
      'Somewhat useful',
      'Not so useful',
      'Not at all useful'
    ]
  ],
  'Valuable - Not valuable': [
    [
      'Extremely valuable',
      'Very Valuable',
      'Somewhat valuable',
      'Not so valuable',
      'Not at all valuable',
    ]
  ],
  'Clear - Not clear': [
    [
      'Extremely clear',
      'Very Clear',
      'Somewhat clear',
      'Not so clear',
      'Not at all clear',
    ]
  ],
  'Helpful - Not helpful': [
    [
      'Extremely helpful',
      'Very Helpful',
      'Somewhat helpful',
      'Not so helpful',
      'Not at all helpful',
    ]
  ],
  'All - None': [
    ['All', 'Most', 'Some', 'A Few', 'None']
  ],
  'Friendly - Not friendly': [
    [
      'Extremely friendly',
      'Very Friendly',
      'Somewhat friendly',
      'Not so friendly',
      'Not at all friendly',
    ]
  ],
  'Effective - Not effective': [
    [
      'Extremely effective',
      'Very Effective',
      'Somewhat effective',
      'Not so effective',
      'Not at all effective',
    ]
  ],
  'Positive - Negative': [
    ['Positive', 'Negative'],
    ['Positive', 'Neutral', 'Negative'],
    ['Very Positive', 'Positive', 'Negative', 'Very Negative'],
    ['Very Positive', 'Positive', 'Neutral', 'Negative', 'Very Negative'],
    [
      'Very Positive',
      'Positive',
      'Somewhat Positive',
      'Neutral',
      'Somewhat Negative',
      'Negative',
      'Very Negative'
    ],
  ],
  'Too short - Too long': [
    ['Too short', 'About the right length', 'Too long'],
    [
      'Much too short',
      'Too short',
      'About the right length',
      'Too long',
      'Much too long'
    ],
  ],
  'Responsive - Not responsive': [
    [
      'Extremely responsive',
      'Very Responsive',
      'Somewhat responsive',
      'Not so responsive',
      'Not at all responsive',
    ]
  ],
  'Top priority - Not a priority': [
    [
      'The most important priority',
      'A top priority, but not the most important',
      'Not very important',
      'Not at all important',
    ]
  ],
  'Important - Not important': [
    [
      'Extremely important',
      'Very Important',
      'Somewhat important',
      'Not so important',
      'Not at all important',
    ]
  ],
  'Aware - Not aware': [
    [
      'Extremely aware',
      'Very Aware',
      'Somewhat aware',
      'Not so aware',
      'Not at all aware',
    ]
  ],
  'Desirable - Not desirable': [
    [
      'Extremely desirable',
      'Very Desirable',
      'Somewhat desirable',
      'Not so desirable',
      'Not at all desirable',
    ]
  ],
  'Confident - Not confident': [
    [
      'Extremely confident',
      'Very Confident',
      'Somewhat confident',
      'Not so confident',
      'Not at all confident',
    ]
  ],
  'Professional - Not professional': [
    [
      'Extremely professional',
      'Very Professional',
      'Somewhat professional',
      'Not so professional',
      'Not at all professional',
    ]
  ],
  'Clearly - Not clearly': [
    [
      'Extremely clearly',
      'Very Clearly',
      'Somewhat clearly',
      'Not so clearly',
      'Not at all clearly',
    ]
  ],
  'Exceeded expectations - Below expectations': [
    ['Exceeded expectations', 'Met expectations', 'Below expectations']
  ],
  'Attentive - Not attentive': [
    [
      'Extremely attentive',
      'Very Attentive',
      'Somewhat attentive',
      'Not so attentive',
      'Not at all attentive',
    ]
  ],
  'Early - Late': [
    ['Early', 'About the right time', 'Late'],
  ],
  'Months': [
    [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ],
  ],
  'Days': [
    [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ],
  ],
  'Race/Ethnicity': [
    [
      'Black',
      'White',
      'Another race',
    ],
  ],
  'Age': [
    [
      'Under 18',
      '18-24',
      '25-34',
      '35-44',
      '45-54',
      '55-64',
      '65+',
      'Prefer not to say'
    ],
  ],
  'Quarters': [
    ['Monthly', 'Twice annually', 'Quarterly', 'Yearly']
  ],
  'Frequency': [
    [
      'Every day',
      'A few times a week',
      'About once a week',
      'A few times a month',
      'once a month',
      'Never'
    ],
  ],
  'Recent Experience': [
    [
      'In the last week',
      'More than a week, less than a month',
      'More than a month ago',
    ]
  ]
};

List<String> getScaleOptions(String? scaleName, int? scaleSize) {
  if (scaleOptions.containsKey(scaleName)) {
    final option = scaleOptions[scaleName]!;
    return option.firstWhere(
      (scale) => scale.length == scaleSize,
      orElse: () => option.lastOrNull ?? [],
    );
  }
  return [];
}

List<int> getScaleOptionsSize(String? scaleName) {
  if (scaleOptions.containsKey(scaleName)) {
    final option = scaleOptions[scaleName]!;
    return option.map((e) => e.length).toList();
  }
  return [];
}
