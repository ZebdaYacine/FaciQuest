import 'dart:io';

import 'package:faciquest/features/features.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final SurveyDataSource remoteDataSource;

  SurveyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SurveyEntity?> createSurvey(SurveyEntity survey) {
    return remoteDataSource.createSurvey(survey);
  }

  @override
  Future<void> deleteSurvey(String surveyId) {
    return remoteDataSource.deleteSurvey(surveyId);
  }

  @override
  Future<SurveyEntity?> getSurveyById(String surveyId) {
    return remoteDataSource.getSurveyById(surveyId);
  }

  @override
  Future<List<SurveyEntity>> getSurveys() {
    return remoteDataSource.getSurveys();
  }

  @override
  Future<SurveyEntity?> updateSurvey(SurveyEntity survey) {
    return remoteDataSource.updateSurvey(survey);
  }

  @override
  Future<void> submitAnswers(Submission submission) {
    return remoteDataSource.submitAnswers(submission);
  }

  @override
  Future<List<SurveyEntity>> fetchMySurveys() {
    return remoteDataSource.fetchMySurveys();
  }

  @override
  Future<void> confirmPayment(String collectorId, File profOfPayment) {
    return remoteDataSource.confirmPayment(collectorId, profOfPayment);
  }

  @override
  Future<void> createCollector(CollectorEntity collector) {
    return remoteDataSource.createCollector(collector);
  }

  @override
  Future<void> deleteCollector(String collectorId) {
    return remoteDataSource.deleteCollector(collectorId);
  }

  @override
  Future<double> estimatePrice(CollectorEntity collector) {
    return remoteDataSource.estimatePrice(collector);
  }

  @override
  Future<List<CollectorEntity>> getMyCollectors(String surveyId) {
    return remoteDataSource.getMyCollectors(surveyId);
  }

  @override
  Future<List<TargetingCriteria>> getTargetingCriteria() {
    return remoteDataSource.getTargetingCriteria();
  }

  @override
  Future<void> updateCollector(CollectorEntity collector) {
    return remoteDataSource.updateCollector(collector);
  }
}
