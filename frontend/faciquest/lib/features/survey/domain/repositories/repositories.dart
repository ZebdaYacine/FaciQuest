import 'dart:io';

import 'package:faciquest/features/features.dart';

abstract class SurveyRepository {
  Future<List<SurveyEntity>> getSurveys();
  Future<SurveyEntity?> getSurveyById(String surveyId);
  Future<SurveyEntity?> createSurvey(SurveyEntity survey);
  Future<SurveyEntity?> updateSurvey(SurveyEntity survey);
  Future<void> deleteSurvey(String surveyId);

  Future<void> submitAnswers(SubmissionEntity submission);

  Future<List<SurveyEntity>> fetchMySurveys();

  Future<List<CollectorEntity>> getSurveyCollectors(String surveyId);
  Future<List<TargetingCriteria>> getTargetingCriteria();
  Future<void> createCollector(CollectorEntity collector);

  Future<void> deleteCollector(String collectorId);
  Future<void> confirmPayment(String collectorId, File profOfPayment);
  Future<double> estimatePrice(CollectorEntity collector);
}
