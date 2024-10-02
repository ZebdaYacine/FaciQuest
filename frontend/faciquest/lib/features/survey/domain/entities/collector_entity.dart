// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CollectorEntity {
  final String id;
  final String name;
  final CollectorStatus status;
  final CollectorType type;
  final int responsesCount;
  final int viewsCount;
  final DateTime? createdDate;
  final String surveyId;
  final String? webUrl;
  final List<TargetingCriteria> targetingCriteria;

  CollectorEntity({
    required this.id,
    required this.surveyId,
    this.type = CollectorType.link,
    this.webUrl,
    required this.name,
    required this.status,
    required this.responsesCount,
    required this.viewsCount,
    this.targetingCriteria = const [],
    this.createdDate,
  });
}

enum CollectorStatus { open, draft, deleted, checkingPayment }

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
}

class TargetingCriteria {
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
        id: const Uuid().v4(),
        category: 'Most popular',
        title: 'Education',
        description:
            'What is the highest level of school that you have completed?',
        choices: [
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'Elementary School',
          ),
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'High School',
          ),
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'College',
          ),
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'University',
          ),
        ],
      ),
      TargetingCriteria(
        id: const Uuid().v4(),
        category: 'Most popular',
        title: 'Marital Status',
        description: 'What is your marital status?',
        choices: [
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'Single',
          ),
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'Married',
          ),
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'Divorced',
          ),
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'Widowed',
          ),
        ],
      ),
      TargetingCriteria(
        id: const Uuid().v4(),
        category: 'Most popular',
        title: 'Parental Status',
        description: 'What is your parental status?',
        choices: [
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'No children',
          ),
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'Has children',
          ),
        ],
      ),
      TargetingCriteria(
        id: const Uuid().v4(),
        title: 'Race',
        category: 'Most popular',
        description: 'What is your ethnicity? (Please select all that apply.)',
        choices: [
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'American Indian or Alaska Native',
          ),
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'Asian',
          ),
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'Black or African American',
          ),
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'Native Hawaiian or Other Pacific Islander',
          ),
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'White',
          ),
        ],
      ),
      TargetingCriteria(
        title: 'Religion',
        id: const Uuid().v4(),
        category: 'Most popular',
        description: 'What is your religion? (Please select all that apply.)',
        choices: [
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'Islam',
          ),
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'No religion',
          ),
        ],
      ),
      TargetingCriteria(
        id: const Uuid().v4(),
        category: 'Employment',
        title: 'Employment Status',
        description:
            'Which of the following categories best describes your employment status?',
        choices: [
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'Employed part-time',
          ),
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'Employed full-time',
          ),
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'Unemployed',
          ),
          CriteriaChoices(
            id: const Uuid().v4(),
            title: 'Retired',
          ),
        ],
      ),
      TargetingCriteria(
          id: const Uuid().v4(),
          category: 'Employment',
          title: 'Job Level',
          description:
              'Which of the following best describes your current job level?',
          choices: [
            CriteriaChoices(
              id: const Uuid().v4(),
              title: 'Entry-level',
            ),
            CriteriaChoices(
              id: const Uuid().v4(),
              title: 'Mid-level',
            ),
            CriteriaChoices(
              id: const Uuid().v4(),
              title: 'Senior-level',
            ),
            CriteriaChoices(
              id: const Uuid().v4(),
              title: 'Manager',
            ),
            CriteriaChoices(
              id: const Uuid().v4(),
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
      category: category,
      title: title ?? this.title,
      description: description,
      choices: choices ?? this.choices,
    );
  }
}

class CriteriaChoices {
  final String id;
  final String title;

  CriteriaChoices({
    required this.id,
    required this.title,
  });
}
