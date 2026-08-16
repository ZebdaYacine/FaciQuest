import 'dart:async';
import 'dart:io';

import 'package:faciquest/features/features.dart';

class FakeSurveyRepository implements SurveyRepository {
  final surveysController = StreamController<List<SurveyEntity>>.broadcast();

  List<SurveyEntity> mySurveys = const [];
  List<CollectorEntity> collectors = const [];
  List<SubmissionEntity> submissions = const [];
  List<TargetingCriteria> criteria = const [];
  SurveyEntity survey = SurveyEntity.empty;
  Object? fetchError;
  SubmissionEntity? submittedAnswers;

  @override
  Stream<List<SurveyEntity>> getSurveys() => surveysController.stream;

  @override
  Future<List<SurveyEntity>> fetchMySurveys() async {
    if (fetchError case final error?) throw error;
    return mySurveys;
  }

  @override
  Future<SurveyEntity?> getSurveyById(String surveyId) async {
    if (fetchError case final error?) throw error;
    return survey;
  }

  @override
  Future<SurveyEntity?> createSurvey(SurveyEntity survey) async => survey;

  @override
  Future<SurveyEntity?> updateSurvey(SurveyEntity survey) async => survey;

  @override
  Future<void> deleteSurvey(String surveyId) async {}

  @override
  Future<void> submitAnswers(SubmissionEntity submission) async {
    submittedAnswers = submission;
  }

  @override
  Future<List<SubmissionEntity>> getSubmissions({
    required String surveyId,
    int page = 1,
    int pageSize = 10,
  }) async =>
      submissions;

  @override
  Future<List<CollectorEntity>> getSurveyCollectors(String surveyId) async =>
      collectors;

  @override
  Future<List<TargetingCriteria>> getTargetingCriteria() async => criteria;

  @override
  Future<void> createCollector(CollectorEntity collector) async {}

  @override
  Future<void> deleteCollector(String collectorId) async {}

  @override
  Future<void> confirmPayment(String collectorId, File profOfPayment) async {}

  @override
  Future<double> estimatePrice(CollectorEntity collector) async => 0;

  Future<void> close() => surveysController.close();
}
