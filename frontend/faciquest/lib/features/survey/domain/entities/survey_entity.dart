// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:uuid/uuid.dart';

enum SurveyStatus { active, draft, published, deleted }

enum SurveyAction {
  newSurvey,
  edit,
  preview,
  analyze,
  delete,
  collectResponses,
  ;

  static SurveyAction? fromValue(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'newSurvey':
        return SurveyAction.newSurvey;
      case 'edit':
        return SurveyAction.edit;
      case 'preview':
        return SurveyAction.preview;
      case 'analyze':
        return SurveyAction.analyze;
      case 'delete':
        return SurveyAction.delete;
      case 'collectResponses':
        return SurveyAction.collectResponses;
    }
    return null;
  }
}

class SurveyEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final SurveyStatus status;
  final List<String> languages;
  final List<String> topics;
  final LikertScale? likertScale;
  final List<QuestionEntity> questions;
  final List<Submission> submissions;
  final DateTime createdAt;
  final DateTime? updatedAt;
  //
  final int responseCount;
  final int viewCount;
  final int questionCount;

  static final empty = SurveyEntity();

  final List<CollectorEntity> collectors;
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  SurveyEntity({
    this.id = '',
    this.name = '',
    this.description,
    this.status = SurveyStatus.draft,
    this.languages = const ['en', 'ar'],
    this.topics = const [],
    this.questions = const [],
    this.collectors = const [],
    this.submissions = const [],
    this.likertScale,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.responseCount = 0,
    this.viewCount = 0,
    this.questionCount = 0,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  SurveyEntity copyWith({
    String? name,
    String? description,
    SurveyStatus? status,
    List<String>? languages,
    List<String>? topics,
    LikertScale? likertScale,
    List<QuestionEntity>? questions,
    List<Submission>? submissions,
    List<CollectorEntity>? collectors,
  }) {
    return SurveyEntity(
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      languages: languages ?? this.languages,
      topics: topics ?? this.topics,
      likertScale: likertScale ?? this.likertScale,
      questions: questions ?? this.questions,
      submissions: submissions ?? this.submissions,
      collectors: collectors ?? this.collectors,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "name": name,
      "description": description,
      // 'status': status.name,
      "languages": ["en", "fr"],
      "topics": topics,
      // "likertScale": likertScale?.getScale().toString(),
      "likertScale": "5-point",
      "questions": questions.map((e) => e.toMap()).toList(),
    };
  }

  factory SurveyEntity.fromMap(Map<String, dynamic> map) {
    return SurveyEntity(
      id: map['id'] as String? ?? '',
      name: map['name'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      status: SurveyStatus.values.firstWhere(
        (element) => element.name == map['status'] as String?,
        orElse: () => SurveyStatus.draft,
      ),
      languages: map['languages'] != null && map['languages'] is List
          ? (map['languages'] as List<dynamic>)
              .map((e) => e.toString())
              .toList()
          : const [],
      topics: map['topics'] != null && map['topics'] is List
          ? (map['topics'] as List<dynamic>).map((e) => e.toString()).toList()
          : const [],
      likertScale: map['likertScale'] != null
          ? LikertScale.fromMap(map['likertScale'] as String)
          : null,
      questions: map['questions'] != null
          ? (map['questions'] as List)
              .map((e) => QuestionEntity.fromMap(e as Map<String, dynamic>))
              .toList()
          : <QuestionEntity>[],
      viewCount: map['views'] != null ? map['views'] as int : 0,
      questionCount:
          map['countQuestions'] != null ? map['countQuestions'] as int : 0,
      responseCount:
          map['countAnswers'] != null ? map['countAnswers'] as int : 0,
      createdAt: map['createdAt'] != null && map['createdAt'] is String
          ? DateTime.tryParse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null && map['updatedAt'] is String
          ? DateTime.tryParse(map['updatedAt'])
          : null,
      // answers: map['answers'] != null
      //     ? (map['answers'] as List<Map<String, dynamic>>)
      //         .map(AnswerEntity.fromMap)
      //         .toList()
      //     : <AnswerEntity>[],
      // collectors: map['collectors'] != null
      //     ? (map['collectors'] as List<Map<String, dynamic>>)
      //         .map(CollectorEntity.fromMap)
      //         .toList()
      //     : <CollectorEntity>[],
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
      submissions,
      collectors,
    ];
  }

  bool get isValid => name.isNotEmpty && questions.isNotEmpty;

  static Future<SurveyEntity?> dummy() {
    return Future.delayed(
      const Duration(milliseconds: 50),
      () => SurveyEntity(
        id: const Uuid().v4(),
        name: 'Test Survey',
        status: SurveyStatus.draft,
        questions: QuestionEntity.dummyList(),
        description: 'Test Description',
        languages: const ['en', 'ar'],
        topics: const ['test', 'test2'],
      ),
    );
  }

  static List<SurveyEntity> dummyList() {
    return [
      SurveyEntity(
        id: const Uuid().v4(),
        name: 'Test Survey',
        status: SurveyStatus.draft,
        responseCount: Random().nextInt(50),
        viewCount: 50 + Random().nextInt(10),
        questions: QuestionEntity.dummyList(),
        description: 'Test Description',
        languages: const ['en', 'ar'],
        topics: const ['test', 'test2'],
      ),
      SurveyEntity(
        id: const Uuid().v4(),
        name: 'Unit Test Survey',
        responseCount: Random().nextInt(50),
        viewCount: 50 + Random().nextInt(10),
        status: SurveyStatus.draft,
        questions: QuestionEntity.dummyList()..shuffle(),
        createdAt: DateTime.now().subtract(Duration(
          days: Random().nextInt(30),
        )),
        description: 'Test Description',
        languages: const ['en', 'ar'],
        topics: const ['test', 'test2'],
      ),
      SurveyEntity(
        id: const Uuid().v4(),
        name: 'Unit Test Survey',
        responseCount: Random().nextInt(50),
        viewCount: 50 + Random().nextInt(10),
        status: SurveyStatus.draft,
        questions: QuestionEntity.dummyList()..shuffle(),
        createdAt: DateTime.now().subtract(Duration(
          days: Random().nextInt(30),
        )),
        description: 'Test Description',
        languages: const ['en', 'ar'],
        topics: const ['test', 'test2'],
      ),
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

  int getScale() {
    switch (this) {
      case LikertScale.twoPoints:
        return 2;
      case LikertScale.threePoints:
        return 3;
      case LikertScale.fivePoints:
        return 5;
      case LikertScale.sevenPoints:
        return 7;
    }
  }

  static LikertScale fromMap(String name) {
    return LikertScale.values.firstWhere(
      (element) => element.name == name,
      orElse: () => LikertScale.twoPoints,
    );
  }
}
