import 'package:faciquest/features/features.dart';
import 'package:get_it/get_it.dart';

void registerSurvey(GetIt getIt) {
  getIt
    ..registerLazySingleton<SurveyDataSource>(
      () => SurveyDataSourceImpl(dioClient: getIt()),
    )
    ..registerLazySingleton<SurveyRepository>(
      () => SurveyRepositoryImpl(
        remoteDataSource: getIt<SurveyDataSource>(),
      ),
    );
}
