// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:faciquest/features/survey/survey.dart';

enum surveyStatus { draft, published, deleted }

class SurveyEntity extends Equatable {
  final String name;
  final String? description;
  final surveyStatus status;
  final List<String> languages;
  final List<String> topics;
  final LikertScale? likertScale;
  final List<QuestionEntity> questions;
  const SurveyEntity({
    this.name = '',
    this.description,
    this.status = surveyStatus.draft,
    this.languages = const [],
    this.topics = const [],
    this.questions = const [],
    this.likertScale,
  });

  SurveyEntity copyWith(
      {String? name,
      String? description,
      surveyStatus? status,
      List<String>? languages,
      List<String>? topics,
      LikertScale? likertScale,
      List<QuestionEntity>? questions}) {
    return SurveyEntity(
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      languages: languages ?? this.languages,
      topics: topics ?? this.topics,
      likertScale: likertScale ?? this.likertScale,
      questions: questions ?? this.questions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'status': status.name,
      'languages': languages,
      'topics': topics,
      'likertScale': likertScale?.name,
      'questions': questions.map((e) => e.toMap()),
    };
  }

  factory SurveyEntity.fromMap(Map<String, dynamic> map) {
    return SurveyEntity(
      name: map['name'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      status: surveyStatus.values.firstWhere(
        (element) => element.name == map['status'] as String?,
        orElse: () => surveyStatus.draft,
      ),
      languages: List<String>.from((map['languages'] as List<String>)),
      topics: List<String>.from((map['topics'] as List<String>)),
      likertScale: map['likertScale'] != null
          ? LikertScale.fromMap(map['likertScale'] as String)
          : null,
      questions: map['questions'] != null
          ? (map['questions'] as List<Map<String, dynamic>>)
              .map(QuestionEntity.fromMap)
              .toList()
          : <QuestionEntity>[],
    );
  }

  String toJson() => json.encode(toMap());

  factory SurveyEntity.fromJson(String source) =>
      SurveyEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      name,
      description,
      languages,
      topics,
      likertScale,
      status,
      questions,
    ];
  }
}

enum LikertScale {
  twoPoints,
  threePoints,
  fivePoints,
  sevenPoints,
  ;

  String getValue() {
    switch (this) {
      case LikertScale.twoPoints:
        return '2-point Likert scale';
      case LikertScale.threePoints:
        return '3-point Likert scale';
      case LikertScale.fivePoints:
        return '5-point Likert scale';
      case LikertScale.sevenPoints:
        return '7-point Likert scale';
    }
  }

  static LikertScale fromMap(String name) {
    return LikertScale.values.firstWhere(
      (element) => element.name == name,
      orElse: () => LikertScale.twoPoints,
    );
  }
}
