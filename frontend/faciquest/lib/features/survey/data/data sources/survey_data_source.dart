import 'package:dio/dio.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';

abstract class SurveyDataSource {
  Future<List<SurveyEntity>> getSurveys();
  Future<SurveyEntity?> getSurveyById(String surveyId);
  Future<void> createSurvey(SurveyEntity survey);
  Future<void> updateSurvey(SurveyEntity survey);
  Future<void> deleteSurvey(String surveyId);
  Future<void> submitAnswers(Submission submission);
  Future<List<SurveyEntity>> fetchMySurveys();
}

class SurveyDataSourceImpl implements SurveyDataSource {
  final Dio dioClient;

  SurveyDataSourceImpl({required this.dioClient});
  @override
  Future<void> createSurvey(SurveyEntity survey) async {}

  @override
  Future<void> deleteSurvey(String surveyId) {
    // TODO: implement deleteSurvey
    throw UnimplementedError();
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
  Future<List<SurveyEntity>> getSurveys() {
    logInfo('SurveyDataSourceImpl:getSurveys');
    // TODO: implement getSurveys
    throw UnimplementedError();
  }

  @override
  Future<void> updateSurvey(SurveyEntity survey) {
    logInfo('SurveyDataSourceImpl:updateSurvey');
    // TODO: implement updateSurvey
    throw UnimplementedError();
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
}
