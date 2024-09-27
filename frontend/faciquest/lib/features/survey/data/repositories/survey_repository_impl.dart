import 'package:faciquest/features/features.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final SurveyDataSource remoteDataSource;

  SurveyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createSurvey(SurveyEntity survey) {
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
  Future<void> updateSurvey(SurveyEntity survey) {
    return remoteDataSource.updateSurvey(survey);
  }
}
