// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';
import 'package:objectid/objectid.dart';

class CollectorEntity extends Equatable {
  final String id;
  final String name;
  final CollectorStatus status;
  final CollectorType type;
  final int responsesCount;
  final int viewsCount;
  final DateTime? createdDate;
  final String surveyId;
  final String? webUrl;
  // audience criteria props
  final double? population;
  final Gender? gender;
  final RangeValues? ageRange;
  final List<String> countries;
  final List<Province> provinces;
  final List<City> cities;
  final List<TargetingCriteria> targetingCriteria;

  const CollectorEntity({
    this.id = '-',
    required this.name,
    this.status = CollectorStatus.draft,
    this.type = CollectorType.link,
    this.responsesCount = 0,
    this.viewsCount = 0,
    this.createdDate,
    required this.surveyId,
    this.webUrl,
    this.population,
    this.gender,
    this.ageRange,
    this.countries = const [],
    this.provinces = const [],
    this.cities = const [],
    this.targetingCriteria = const [],
  });

  CollectorEntity copyWith({
    String? id,
    String? name,
    CollectorStatus? status,
    CollectorType? type,
    int? responsesCount,
    int? viewsCount,
    DateTime? createdDate,
    String? surveyId,
    String? webUrl,
    double? population,
    Gender? gender,
    RangeValues? ageRange,
    List<String>? countries,
    List<Province>? provinces,
    List<City>? cities,
    List<TargetingCriteria>? targetingCriteria,
  }) {
    return CollectorEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      type: type ?? this.type,
      responsesCount: responsesCount ?? this.responsesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      createdDate: createdDate ?? this.createdDate,
      surveyId: surveyId ?? this.surveyId,
      webUrl: webUrl ?? this.webUrl,
      population: population ?? this.population,
      gender: gender ?? this.gender,
      ageRange: ageRange ?? this.ageRange,
      countries: countries ?? this.countries,
      provinces: provinces ?? this.provinces,
      cities: cities ?? this.cities,
      targetingCriteria: targetingCriteria ?? this.targetingCriteria,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type.name,
      'surveyId': surveyId,
      'targetAudience': {
        'population': population?.toInt() ?? 0,
        'gender': gender?.toMap() ?? Gender.male.toMap(),
        'ageRange': {
          'start': ageRange?.start.toInt() ?? 0,
          'end': ageRange?.end.toInt() ?? 120,
        },
        'country': countries.firstOrNull ?? '',
        'state': provinces.map((x) => x.toMap()).toList(),
        'city': cities.map((x) => x.toMap()).toList(),
        'targetingCriteria': targetingCriteria.map((x) => x.toMap()).toList()
      }
    };
  }

  factory CollectorEntity.fromMap(Map<String, dynamic> map) {
    final targetAudience = map['targetAudience'] as Map<String, dynamic>?;
    final ageRange = targetAudience?['ageRange'] as Map<String, dynamic>?;

    return CollectorEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      status: CollectorStatus.fromMap(map['status'] as String?) ?? CollectorStatus.draft,
      type: CollectorType.fromMap(map['type'] as String?) ?? CollectorType.targetAudience,
      responsesCount: (map['responsesCount'] as num?)?.toInt() ?? 0,
      viewsCount: (map['viewsCount'] as num?)?.toInt() ?? 0,
      createdDate:
          map['createdDate'] != null ? DateTime.fromMillisecondsSinceEpoch((map['createdDate'] as num).toInt()) : null,
      surveyId: map['surveyId'] as String,
      webUrl: map['webUrl'] as String?,
      population: targetAudience?['population'] != null ? (targetAudience!['population'] as num).toDouble() : null,
      gender: targetAudience?['gender'] != null
          ? Gender.fromMap(targetAudience!['gender'] as String?) ?? Gender.both
          : null,
      ageRange: ageRange != null && ageRange['start'] is double && ageRange['end'] is double
          ? RangeValues(ageRange['start'], ageRange['end'])
          : null,
      countries: targetAudience?['countries'] != null ? List<String>.from(targetAudience!['countries'] as List) : [],
      provinces: targetAudience?['provinces'] != null
          ? List<Province>.from(
              (targetAudience!['provinces'] as List).map((x) => Province.fromMap(x as Map<String, dynamic>)),
            )
          : [],
      cities: targetAudience?['cities'] != null
          ? List<City>.from(
              (targetAudience!['cities'] as List).map((x) => City.fromMap(x as Map<String, dynamic>)),
            )
          : [],
      targetingCriteria: targetAudience?['targetingCriteria'] != null
          ? List<TargetingCriteria>.from(
              (targetAudience!['targetingCriteria'] as List)
                  .map((x) => TargetingCriteria.fromMap(x as Map<String, dynamic>)),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory CollectorEntity.fromJson(String source) =>
      CollectorEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      status,
      type,
      responsesCount,
      viewsCount,
      createdDate,
      surveyId,
      webUrl,
      population,
      gender,
      ageRange,
      countries,
      provinces,
      cities,
      targetingCriteria,
    ];
  }
}

enum CollectorStatus {
  open,
  draft,
  deleted,
  checkingPayment;

  String get displayName {
    switch (this) {
      case CollectorStatus.open:
        return 'Open';
      case CollectorStatus.draft:
        return 'Draft';
      case CollectorStatus.deleted:
        return 'Deleted';
      case CollectorStatus.checkingPayment:
        return 'Checking Payment';
    }
  }

  String toMap() {
    switch (this) {
      case CollectorStatus.open:
        return 'open';
      case CollectorStatus.draft:
        return 'draft';
      case CollectorStatus.deleted:
        return 'deleted';
      case CollectorStatus.checkingPayment:
        return 'checkingPayment';
    }
  }

  static CollectorStatus? fromMap(String? status) {
    switch (status) {
      case 'open':
        return CollectorStatus.open;
      case 'draft':
        return CollectorStatus.draft;
      case 'deleted':
        return CollectorStatus.deleted;
      case 'checkingPayment':
        return CollectorStatus.checkingPayment;
    }
    return null;
  }
}

enum CollectorType {
  link,
  targetAudience;

  IconData? get icon {
    switch (this) {
      case CollectorType.link:
        return Icons.link;
      case CollectorType.targetAudience:
        return Icons.person;
    }
  }

  Color get color {
    switch (this) {
      case CollectorType.link:
        return Colors.blue;
      case CollectorType.targetAudience:
        return Colors.purple;
    }
  }

  String toMap() {
    switch (this) {
      case CollectorType.link:
        return 'link';
      case CollectorType.targetAudience:
        return 'targetAudience';
    }
  }

  static CollectorType? fromMap(String? type) {
    switch (type) {
      case 'link':
        return CollectorType.link;
      case 'targetAudience':
        return CollectorType.targetAudience;
    }
    return null;
  }
}

class TargetingCriteria extends Equatable {
  const TargetingCriteria({
    this.id = '',
    this.category,
    this.title = '',
    this.description,
    this.choices = const [],
  });
  final String id;
  final String? category;
  final String title;
  final String? description;
  final List<CriteriaChoices> choices;

  static List<TargetingCriteria> dummy() {
    return [
      TargetingCriteria(
        id: ObjectId().hexString,
        category: 'Most popular',
        title: 'Education',
        description: 'What is the highest level of school that you have completed?',
        choices: [
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'Elementary School',
          ),
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'High School',
          ),
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'College',
          ),
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'University',
          ),
        ],
      ),
      TargetingCriteria(
        id: ObjectId().hexString,
        category: 'Most popular',
        title: 'Marital Status',
        description: 'What is your marital status?',
        choices: [
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'Single',
          ),
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'Married',
          ),
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'Divorced',
          ),
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'Widowed',
          ),
        ],
      ),
      TargetingCriteria(
        id: ObjectId().hexString,
        category: 'Most popular',
        title: 'Parental Status',
        description: 'What is your parental status?',
        choices: [
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'No children',
          ),
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'Has children',
          ),
        ],
      ),
      TargetingCriteria(
        id: ObjectId().hexString,
        title: 'Race',
        category: 'Most popular',
        description: 'What is your ethnicity? (Please select all that apply.)',
        choices: [
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'American Indian or Alaska Native',
          ),
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'Asian',
          ),
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'Black or African American',
          ),
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'Native Hawaiian or Other Pacific Islander',
          ),
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'White',
          ),
        ],
      ),
      TargetingCriteria(
        title: 'Religion',
        id: ObjectId().hexString,
        category: 'Most popular',
        description: 'What is your religion? (Please select all that apply.)',
        choices: [
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'Islam',
          ),
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'No religion',
          ),
        ],
      ),
      TargetingCriteria(
        id: ObjectId().hexString,
        category: 'Employment',
        title: 'Employment Status',
        description: 'Which of the following categories best describes your employment status?',
        choices: [
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'Employed part-time',
          ),
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'Employed full-time',
          ),
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'Unemployed',
          ),
          CriteriaChoices(
            id: ObjectId().hexString,
            title: 'Retired',
          ),
        ],
      ),
      TargetingCriteria(
          id: ObjectId().hexString,
          category: 'Employment',
          title: 'Job Level',
          description: 'Which of the following best describes your current job level?',
          choices: [
            CriteriaChoices(
              id: ObjectId().hexString,
              title: 'Entry-level',
            ),
            CriteriaChoices(
              id: ObjectId().hexString,
              title: 'Mid-level',
            ),
            CriteriaChoices(
              id: ObjectId().hexString,
              title: 'Senior-level',
            ),
            CriteriaChoices(
              id: ObjectId().hexString,
              title: 'Manager',
            ),
            CriteriaChoices(
              id: ObjectId().hexString,
              title: 'Director',
            ),
          ]),
    ];
  }

  TargetingCriteria copyWith({
    String? id,
    String? category,
    String? title,
    String? description,
    List<CriteriaChoices>? choices,
  }) {
    return TargetingCriteria(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      choices: choices ?? this.choices,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category,
      'title': title,
      'description': description,
      'choices': choices.map((x) => x.toMap()).toList(),
    };
  }

  factory TargetingCriteria.fromMap(Map<String, dynamic> map) {
    return TargetingCriteria(
      id: map['id'] as String,
      category: map['category'] != null ? map['category']['Name'] as String : null,
      title: map['title'] as String,
      description: map['description'] != null ? map['description'] as String : null,
      choices: List<CriteriaChoices>.from(
        (map['choices'] as List).map<CriteriaChoices>(
          (x) => CriteriaChoices.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory TargetingCriteria.fromJson(String source) =>
      TargetingCriteria.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      category,
      title,
      description,
      choices,
    ];
  }
}

class CriteriaChoices extends Equatable {
  final String id;
  final String title;

  const CriteriaChoices({
    required this.id,
    required this.title,
  });

  CriteriaChoices copyWith({
    String? id,
    String? title,
  }) {
    return CriteriaChoices(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
    };
  }

  factory CriteriaChoices.fromMap(Map<String, dynamic> map) {
    return CriteriaChoices(
      id: map['id'] as String,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CriteriaChoices.fromJson(String source) =>
      CriteriaChoices.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, title];
}
