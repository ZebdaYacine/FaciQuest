import 'package:faciquest/features/features.dart';

abstract class SurveyRepository {
  Future<List<SurveyEntity>> getSurveys();
  Future<SurveyEntity?> getSurveyById(String surveyId);
  Future<void> createSurvey(SurveyEntity survey);
  Future<void> updateSurvey(SurveyEntity survey);
  Future<void> deleteSurvey(String surveyId);

  Future<void> submitAnswers(Submission submission);

  Future<List<SurveyEntity>> fetchMySurveys();
}
