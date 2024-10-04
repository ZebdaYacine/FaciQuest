import 'dart:io';

import 'package:dio/dio.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';

abstract class SurveyDataSource {
  Future<List<SurveyEntity>> getSurveys();
  Future<SurveyEntity?> getSurveyById(String surveyId);
  Future<SurveyEntity?> createSurvey(SurveyEntity survey);
  Future<SurveyEntity?> updateSurvey(SurveyEntity survey);
  Future<void> deleteSurvey(String surveyId);
  Future<void> submitAnswers(Submission submission);
  Future<List<SurveyEntity>> fetchMySurveys();
  //
  Future<List<CollectorEntity>> getMyCollectors(String surveyId);
  Future<List<TargetingCriteria>> getTargetingCriteria();
  Future<void> createCollector(CollectorEntity collector);
  Future<void> updateCollector(CollectorEntity collector);
  Future<void> deleteCollector(String collectorId);
  Future<void> confirmPayment(String collectorId, File profOfPayment);
  Future<double> estimatePrice(CollectorEntity collector);
}

class SurveyDataSourceImpl implements SurveyDataSource {
  final Dio dioClient;

  SurveyDataSourceImpl({required this.dioClient});
  @override
  Future<SurveyEntity?> createSurvey(SurveyEntity survey) async {
    logInfo('SurveyDataSourceImpl:createSurvey');
    final response = await dioClient.post(
      AppUrls.createSurvey,
      data: survey.toMap(),
    );

    if (response.statusCode == 200 &&
        response.data?['date'] != null &&
        response.data?['date'] is Map) {
      return SurveyEntity.fromMap(response.data['date']);
    }
    return null;
  }

  @override
  Future<void> deleteSurvey(String surveyId) async {
    logInfo('SurveyDataSourceImpl:deleteSurvey');
    await dioClient.delete(
      AppUrls.deleteSurvey,
      data: {
        'surveyId': surveyId,
      },
    );
  }

  @override
  Future<SurveyEntity?> getSurveyById(String surveyId) async {
    logInfo('SurveyDataSourceImpl:getSurveyById $surveyId');

    final response = await dioClient.get(
      AppUrls.getSurvey,
      data: {
        'surveyId': surveyId,
      },
    );
    if (response.statusCode == 200 &&
        response.data?['date'] != null &&
        response.data?['date'] is Map) {
      return SurveyEntity.fromMap(response.data['date']);
    }
    return null;
  }

  @override
  Future<List<SurveyEntity>> getSurveys() async {
    logInfo('SurveyDataSourceImpl:getSurveys');
    final response = await dioClient.get<Map<String, dynamic>>(
      AppUrls.getSurveys,
    );
    if (response.statusCode == 200 &&
        response.data?['date'] != null &&
        response.data?['date'] is List) {
      return (response.data!['date'] as List? ?? [])
          .map((e) => SurveyEntity.fromMap(e))
          .toList();
    }
    return [];
  }

  @override
  Future<SurveyEntity?> updateSurvey(SurveyEntity survey) async {
    logInfo('SurveyDataSourceImpl:updateSurvey');
    // Todo implement updateSurvey
    return null;
  }

  @override
  Future<void> submitAnswers(Submission submission) async {
    logInfo('SurveyDataSourceImpl:submitAnswers');
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Future<List<SurveyEntity>> fetchMySurveys() async {
    logInfo('SurveyDataSourceImpl:fetchMySurveys');
    final response = await dioClient.get<Map<String, dynamic>>(
      AppUrls.getMySurveys,
    );
    if (response.statusCode == 200 &&
        response.data?['date'] != null &&
        response.data?['date'] is List) {
      return (response.data!['date'] as List? ?? [])
          .map((e) => SurveyEntity.fromMap(e))
          .toList();
    }
    return [];
  }

  @override
  Future<void> confirmPayment(String collectorId, File profOfPayment) async {}

  @override
  Future<void> createCollector(CollectorEntity collector) async {}

  @override
  Future<void> deleteCollector(String collectorId) async {}

  @override
  Future<List<CollectorEntity>> getMyCollectors(String surveyId) async {
    return [];
  }

  @override
  Future<List<TargetingCriteria>> getTargetingCriteria() async {
    return TargetingCriteria.dummy();
  }

  @override
  Future<void> updateCollector(CollectorEntity collector) async {}

  @override
  Future<double> estimatePrice(CollectorEntity collector) async {
    return (collector.population ?? 0) * 1;
  }
}
