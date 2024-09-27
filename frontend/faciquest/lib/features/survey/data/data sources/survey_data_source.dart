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
}

class SurveyDataSourceImpl implements SurveyDataSource {
  final Dio dioClient;

  SurveyDataSourceImpl({required this.dioClient});
  @override
  Future<void> createSurvey(SurveyEntity survey) {
    // TODO: implement createSurvey
    throw UnimplementedError();
  }

  @override
  Future<void> deleteSurvey(String surveyId) {
    // TODO: implement deleteSurvey
    throw UnimplementedError();
  }

  @override
  Future<SurveyEntity?> getSurveyById(String surveyId) async {
    if (DevSettings.useDummyData) {
      await Future.delayed(const Duration(seconds: 1));
      return SurveyEntity.dummy();
    }
    final response = await dioClient.get(
      '/survey/$surveyId',
    );
    if (response.statusCode == 200) {
      return SurveyEntity.fromJson(response.data);
    }
    return null;
  }

  @override
  Future<List<SurveyEntity>> getSurveys() {
    // TODO: implement getSurveys
    throw UnimplementedError();
  }

  @override
  Future<void> updateSurvey(SurveyEntity survey) {
    // TODO: implement updateSurvey
    throw UnimplementedError();
  }

  @override
  Future<void> submitAnswers(Submission submission) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
