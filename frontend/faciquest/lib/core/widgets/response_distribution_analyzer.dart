import 'dart:math';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:faciquest/features/features.dart';

/// Analyzes survey response data and calculates distribution statistics
class ResponseDistributionAnalyzer {
  static ResponseDistribution analyzeQuestion(
    QuestionEntity question,
    List<SubmissionEntity> submissions,
  ) {
    final answers = submissions
        .expand((submission) => submission.answers)
        .where((answer) => answer.questionId == question.id)
        .toList();

    if (answers.isEmpty) {
      return ResponseDistribution.empty(question);
    }

    switch (question.type) {
      case QuestionType.multipleChoice:
        return _analyzeMultipleChoice(question as MultipleChoiceQuestion, answers);
      case QuestionType.checkboxes:
        return _analyzeCheckboxes(question as CheckboxesQuestion, answers);
      case QuestionType.starRating:
        return _analyzeStarRating(question as StarRatingQuestion, answers);
      case QuestionType.dropdown:
        return _analyzeDropdown(question as DropdownQuestion, answers);
      case QuestionType.slider:
        return _analyzeSlider(question as SliderQuestion, answers);
      case QuestionType.shortAnswer:
      case QuestionType.commentBox:
        return _analyzeTextResponses(question, answers);
      case QuestionType.matrix:
        return _analyzeMatrix(question as MatrixQuestion, answers);
      default:
        return _analyzeGeneric(question, answers);
    }
  }

  static ResponseDistribution _analyzeMultipleChoice(
    MultipleChoiceQuestion question,
    List<AnswerEntity> answers,
  ) {
    final choiceCount = <String, int>{};
    int totalResponses = answers.length;

    for (final choice in question.choices) {
      choiceCount[choice] = 0;
    }

    for (final answer in answers) {
      if (answer is MultipleChoiceAnswer) {
        final selectedChoice = answer.selectedChoice;
        if (selectedChoice.isNotEmpty && question.choices.contains(selectedChoice)) {
          choiceCount[selectedChoice] = (choiceCount[selectedChoice] ?? 0) + 1;
        }
      }
    }

    final distributionItems = choiceCount.entries
        .map((entry) => DistributionItem(
              label: entry.key,
              value: entry.value.toDouble(),
              percentage: totalResponses > 0 ? (entry.value / totalResponses) * 100 : 0,
            ))
        .toList();

    return ResponseDistribution(
      question: question,
      totalResponses: totalResponses,
      distributionItems: distributionItems,
      chartType: ChartType.bar,
      statistics: _calculateBasicStats(distributionItems),
    );
  }

  static ResponseDistribution _analyzeCheckboxes(
    CheckboxesQuestion question,
    List<AnswerEntity> answers,
  ) {
    final choiceCount = <String, int>{};
    int totalResponses = answers.length;

    for (final choice in question.choices) {
      choiceCount[choice] = 0;
    }

    for (final answer in answers) {
      if (answer is CheckboxesAnswer) {
        for (final selectedChoice in answer.selectedChoices) {
          if (question.choices.contains(selectedChoice)) {
            choiceCount[selectedChoice] = (choiceCount[selectedChoice] ?? 0) + 1;
          }
        }
      }
    }

    final distributionItems = choiceCount.entries
        .map((entry) => DistributionItem(
              label: entry.key,
              value: entry.value.toDouble(),
              percentage: totalResponses > 0 ? (entry.value / totalResponses) * 100 : 0,
            ))
        .toList();

    return ResponseDistribution(
      question: question,
      totalResponses: totalResponses,
      distributionItems: distributionItems,
      chartType: ChartType.bar,
      statistics: _calculateBasicStats(distributionItems),
    );
  }

  static ResponseDistribution _analyzeStarRating(
    StarRatingQuestion question,
    List<AnswerEntity> answers,
  ) {
    final ratingCount = <int, int>{};
    int totalResponses = answers.length;

    for (int i = 1; i <= question.maxRating; i++) {
      ratingCount[i] = 0;
    }

    for (final answer in answers) {
      if (answer is StarRatingAnswer) {
        final rating = answer.rating.round();
        if (rating >= 1 && rating <= question.maxRating) {
          ratingCount[rating] = (ratingCount[rating] ?? 0) + 1;
        }
      }
    }

    final distributionItems = ratingCount.entries
        .map((entry) => DistributionItem(
              label: '${entry.key} Star${entry.key > 1 ? 's' : ''}',
              value: entry.value.toDouble(),
              percentage: totalResponses > 0 ? (entry.value / totalResponses) * 100 : 0,
            ))
        .toList();

    final averageRating = totalResponses > 0
        ? ratingCount.entries
                .map((e) => e.key * e.value)
                .fold(0, (a, b) => a + b) /
            totalResponses
        : 0.0;

    return ResponseDistribution(
      question: question,
      totalResponses: totalResponses,
      distributionItems: distributionItems,
      chartType: ChartType.bar,
      statistics: DistributionStatistics(
        average: averageRating,
        median: _calculateMedian(answers.cast<StarRatingAnswer>().map((a) => a.rating.toDouble()).toList()),
        mode: _calculateMode(distributionItems),
        standardDeviation: _calculateStandardDeviation(
          answers.cast<StarRatingAnswer>().map((a) => a.rating.toDouble()).toList(),
          averageRating,
        ),
      ),
    );
  }

  static ResponseDistribution _analyzeDropdown(
    DropdownQuestion question,
    List<AnswerEntity> answers,
  ) {
    final choiceCount = <String, int>{};
    int totalResponses = answers.length;

    for (final choice in question.choices) {
      choiceCount[choice] = 0;
    }

    for (final answer in answers) {
      if (answer is DropdownAnswer) {
        final selectedChoice = answer.selectedChoice;
        if (selectedChoice != null && question.choices.contains(selectedChoice)) {
          choiceCount[selectedChoice] = (choiceCount[selectedChoice] ?? 0) + 1;
        }
      }
    }

    final distributionItems = choiceCount.entries
        .map((entry) => DistributionItem(
              label: entry.key,
              value: entry.value.toDouble(),
              percentage: totalResponses > 0 ? (entry.value / totalResponses) * 100 : 0,
            ))
        .toList();

    return ResponseDistribution(
      question: question,
      totalResponses: totalResponses,
      distributionItems: distributionItems,
      chartType: ChartType.pie,
      statistics: _calculateBasicStats(distributionItems),
    );
  }

  static ResponseDistribution _analyzeSlider(
    SliderQuestion question,
    List<AnswerEntity> answers,
  ) {
    final values = <double>[];
    int totalResponses = answers.length;

    for (final answer in answers) {
      if (answer is SliderAnswer) {
        values.add(answer.value);
      }
    }

    // Group slider values into ranges
    const int buckets = 5;
    final range = question.max - question.min;
    final bucketSize = range / buckets;
    final bucketCounts = <String, int>{};

    for (int i = 0; i < buckets; i++) {
      final start = question.min + (i * bucketSize);
      final end = question.min + ((i + 1) * bucketSize);
      final label = '${start.toStringAsFixed(1)} - ${end.toStringAsFixed(1)}';
      bucketCounts[label] = 0;
    }

    for (final value in values) {
      final bucketIndex = ((value - question.min) / bucketSize).floor().clamp(0, buckets - 1);
      final start = question.min + (bucketIndex * bucketSize);
      final end = question.min + ((bucketIndex + 1) * bucketSize);
      final label = '${start.toStringAsFixed(1)} - ${end.toStringAsFixed(1)}';
      bucketCounts[label] = (bucketCounts[label] ?? 0) + 1;
    }

    final distributionItems = bucketCounts.entries
        .map((entry) => DistributionItem(
              label: entry.key,
              value: entry.value.toDouble(),
              percentage: totalResponses > 0 ? (entry.value / totalResponses) * 100 : 0,
            ))
        .toList();

    final average = values.isNotEmpty ? values.reduce((a, b) => a + b) / values.length : 0.0;

    return ResponseDistribution(
      question: question,
      totalResponses: totalResponses,
      distributionItems: distributionItems,
      chartType: ChartType.histogram,
      statistics: DistributionStatistics(
        average: average,
        median: _calculateMedian(values),
        mode: _calculateMode(distributionItems),
        standardDeviation: _calculateStandardDeviation(values, average),
      ),
    );
  }

  static ResponseDistribution _analyzeTextResponses(
    QuestionEntity question,
    List<AnswerEntity> answers,
  ) {
    int totalResponses = answers.length;
    int filledResponses = 0;
    int emptyResponses = 0;

    for (final answer in answers) {
      String? text;
      if (answer is ShortAnswerAnswer) {
        text = answer.value;
      } else if (answer is CommentBoxAnswer) {
        text = answer.value;
      }

      if (text != null && text.trim().isNotEmpty) {
        filledResponses++;
      } else {
        emptyResponses++;
      }
    }

    final distributionItems = [
      DistributionItem(
        label: 'Filled Responses',
        value: filledResponses.toDouble(),
        percentage: totalResponses > 0 ? (filledResponses / totalResponses) * 100 : 0,
      ),
      DistributionItem(
        label: 'Empty Responses',
        value: emptyResponses.toDouble(),
        percentage: totalResponses > 0 ? (emptyResponses / totalResponses) * 100 : 0,
      ),
    ];

    return ResponseDistribution(
      question: question,
      totalResponses: totalResponses,
      distributionItems: distributionItems,
      chartType: ChartType.pie,
      statistics: _calculateBasicStats(distributionItems),
    );
  }

  static ResponseDistribution _analyzeMatrix(
    MatrixQuestion question,
    List<AnswerEntity> answers,
  ) {
    final responseCount = <String, Map<String, int>>{};
    int totalResponses = answers.length;

    // Initialize counts
    for (final row in question.rows) {
      responseCount[row] = <String, int>{};
      for (final col in question.cols) {
        responseCount[row]![col] = 0;
      }
    }

    for (final answer in answers) {
      if (answer is MatrixAnswer) {
        for (final rowEntry in answer.values.entries) {
          final row = rowEntry.key;
          final colValues = rowEntry.value;
          
          if (responseCount.containsKey(row)) {
            for (final colEntry in colValues.entries) {
              final col = colEntry.key;
              final isSelected = colEntry.value;
              
              if (isSelected && responseCount[row]!.containsKey(col)) {
                responseCount[row]![col] = responseCount[row]![col]! + 1;
              }
            }
          }
        }
      }
    }

    // Flatten matrix data for distribution items
    final distributionItems = <DistributionItem>[];
    for (final rowEntry in responseCount.entries) {
      final row = rowEntry.key;
      for (final colEntry in rowEntry.value.entries) {
        final col = colEntry.key;
        final count = colEntry.value;
        distributionItems.add(DistributionItem(
          label: '$row - $col',
          value: count.toDouble(),
          percentage: totalResponses > 0 ? (count / totalResponses) * 100 : 0,
        ));
      }
    }

    return ResponseDistribution(
      question: question,
      totalResponses: totalResponses,
      distributionItems: distributionItems,
      chartType: ChartType.matrix,
      statistics: _calculateBasicStats(distributionItems),
    );
  }

  static ResponseDistribution _analyzeGeneric(
    QuestionEntity question,
    List<AnswerEntity> answers,
  ) {
    int totalResponses = answers.length;

    final distributionItems = [
      DistributionItem(
        label: 'Total Responses',
        value: totalResponses.toDouble(),
        percentage: 100.0,
      ),
    ];

    return ResponseDistribution(
      question: question,
      totalResponses: totalResponses,
      distributionItems: distributionItems,
      chartType: ChartType.bar,
      statistics: _calculateBasicStats(distributionItems),
    );
  }

  static DistributionStatistics _calculateBasicStats(List<DistributionItem> items) {
    if (items.isEmpty) {
      return DistributionStatistics(
        average: 0,
        median: 0,
        mode: null,
        standardDeviation: 0,
      );
    }

    final values = items.map((item) => item.value).toList();
    final average = values.reduce((a, b) => a + b) / values.length;

    return DistributionStatistics(
      average: average,
      median: _calculateMedian(values),
      mode: _calculateMode(items),
      standardDeviation: _calculateStandardDeviation(values, average),
    );
  }

  static double _calculateMedian(List<double> values) {
    if (values.isEmpty) return 0;
    
    final sortedValues = List<double>.from(values)..sort();
    final middle = sortedValues.length ~/ 2;
    
    if (sortedValues.length % 2 == 0) {
      return (sortedValues[middle - 1] + sortedValues[middle]) / 2;
    } else {
      return sortedValues[middle];
    }
  }

  static String? _calculateMode(List<DistributionItem> items) {
    if (items.isEmpty) return null;
    
    final maxValue = items.map((item) => item.value).reduce(max);
    final modeItem = items.firstWhereOrNull((item) => item.value == maxValue);
    
    return modeItem?.label;
  }

  static double _calculateStandardDeviation(List<double> values, double average) {
    if (values.length <= 1) return 0;
    
    final squaredDiffs = values.map((value) => pow(value - average, 2)).toList();
    final variance = squaredDiffs.reduce((a, b) => a + b) / values.length;
    
    return sqrt(variance);
  }
}

/// Represents the distribution analysis of a single question
class ResponseDistribution extends Equatable {
  final QuestionEntity question;
  final int totalResponses;
  final List<DistributionItem> distributionItems;
  final ChartType chartType;
  final DistributionStatistics statistics;

  const ResponseDistribution({
    required this.question,
    required this.totalResponses,
    required this.distributionItems,
    required this.chartType,
    required this.statistics,
  });

  factory ResponseDistribution.empty(QuestionEntity question) {
    return ResponseDistribution(
      question: question,
      totalResponses: 0,
      distributionItems: [],
      chartType: ChartType.bar,
      statistics: DistributionStatistics(
        average: 0,
        median: 0,
        mode: null,
        standardDeviation: 0,
      ),
    );
  }

  @override
  List<Object?> get props => [question, totalResponses, distributionItems, chartType, statistics];
}

/// Represents a single item in the distribution
class DistributionItem extends Equatable {
  final String label;
  final double value;
  final double percentage;

  const DistributionItem({
    required this.label,
    required this.value,
    required this.percentage,
  });

  @override
  List<Object> get props => [label, value, percentage];
}

/// Statistical information about the distribution
class DistributionStatistics extends Equatable {
  final double average;
  final double median;
  final String? mode;
  final double standardDeviation;

  const DistributionStatistics({
    required this.average,
    required this.median,
    required this.mode,
    required this.standardDeviation,
  });

  @override
  List<Object?> get props => [average, median, mode, standardDeviation];
}

/// Types of charts available for visualization
enum ChartType {
  bar,
  pie,
  histogram,
  matrix,
}
