import 'dart:io';

import 'package:dio/dio.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';

abstract class SurveyDataSource {
  Stream<List<SurveyEntity>> getSurveys();
  Future<SurveyEntity?> getSurveyById(String surveyId);
  Future<SurveyEntity?> createSurvey(SurveyEntity survey);
  Future<SurveyEntity?> updateSurvey(SurveyEntity survey);
  Future<void> deleteSurvey(String surveyId);
  Future<void> submitAnswers(SubmissionEntity submission);
  Future<List<SurveyEntity>> fetchMySurveys();
  //
  Future<List<TargetingCriteria>> getTargetingCriteria();
  Future<List<CollectorEntity>> getSurveyCollectors(String surveyId);
  Future<void> createCollector(CollectorEntity collector);

  Future<void> deleteCollector(String collectorId);
  Future<void> confirmPayment(
    String collectorId,
    File profOfPayment,
    // TODO add payment method
  );
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
  Stream<List<SurveyEntity>> getSurveys() async* {
    logInfo('SurveyDataSourceImpl:getSurveys');

    // Define the polling interval (e.g., every 5 minutes)
    const interval = Duration(seconds: 5 * 60);
    yield await _fetchSurveys();

    // Use Stream.periodic to call the API at regular intervals
    yield* Stream.periodic(interval).asyncMap((_) async {
      return await _fetchSurveys();
    });
  }

  Future<List<SurveyEntity>> _fetchSurveys() async {
    try {
      final response = await dioClient.get<Map<String, dynamic>>(
        AppUrls.getSurveys,
      );

      // Check if the response is successful and contains a valid 'data' list
      if (response.statusCode == 200 &&
          response.data?['date'] != null &&
          response.data?['date'] is List) {
        return (response.data!['date'] as List)
            .map((e) => SurveyEntity.fromMap(e))
            .toList();
      } else {
        // If data is missing or the status code is not 200, return an empty list
        return <SurveyEntity>[];
      }
    } catch (error) {
      // Handle or log errors
      logError('Error fetching surveys: $error');
      return <SurveyEntity>[];
    }
  }

  @override
  Future<SurveyEntity?> updateSurvey(SurveyEntity survey) async {
    logInfo('SurveyDataSourceImpl:updateSurvey');

    final response = await dioClient.put(
      AppUrls.updateSurvey,
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
  Future<void> submitAnswers(SubmissionEntity submission) async {
    logInfo('SurveyDataSourceImpl:submitAnswers');

    await dioClient.post(
      AppUrls.submitAnswers,
      data: submission.toMap(),
    );
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
  Future<void> confirmPayment(
    String collectorId,
    File profOfPayment,
  ) async {
    logInfo('SurveyDataSourceImpl:confirmPayment');
    await dioClient.post(
      AppUrls.confirmPayment,
      data: FormData.fromMap({
        'collectorId': collectorId,
        'profOfPayment': await MultipartFile.fromFile(profOfPayment.path),
      }),
    );
  }

  @override
  Future<void> createCollector(CollectorEntity collector) async {
    logInfo('SurveyDataSourceImpl:createCollector');
    final map = collector.toMap();
    logSuccess(map);
    await dioClient.post(
      AppUrls.createCollector,
      data: map,
    );
  }

  @override
  Future<void> deleteCollector(String collectorId) async {
    logInfo('SurveyDataSourceImpl:deleteCollector');
    await dioClient.delete(
      AppUrls.deleteCollector,
      data: {
        'collectorId': collectorId,
      },
    );
  }

  @override
  Future<List<CollectorEntity>> getSurveyCollectors(String surveyId) async {
    logInfo('SurveyDataSourceImpl:getMyCollectors $surveyId');
    final response = await dioClient.get<Map<String, dynamic>>(
      AppUrls.getSurveyCollectors,
      data: {
        'surveyID': surveyId,
      },
    );
    if (response.statusCode == 200 &&
        response.data?['date'] != null &&
        response.data?['date'] is List) {
      return (response.data!['date'] as List? ?? [])
          .map((e) => CollectorEntity.fromMap(e))
          .toList();
    }
    return [];
  }

  @override
  Future<List<TargetingCriteria>> getTargetingCriteria() async {
    logInfo('SurveyDataSourceImpl:getTargetingCriteria ');
    // return TargetingCriteria.dummy();
    final response = await dioClient.get<Map<String, dynamic>>(
      AppUrls.getTargetingCriteria,
    );
    if (response.statusCode == 200 &&
        response.data?['date'] != null &&
        response.data?['date'] is List) {
      return (response.data!['date'] as List? ?? [])
          .map((e) => TargetingCriteria.fromMap(e))
          .toList();
    }
    return [];
  }

  @override
  Future<double> estimatePrice(CollectorEntity collector) async {
    logInfo('SurveyDataSourceImpl:estimatePrice');
    final map = collector.toMap();
    logSuccess('map: $map');
    final response = await dioClient.get<Map<String, dynamic>>(
      AppUrls.estimatePrice,
      data: map,
    );

    if (response.statusCode == 200) {
      return (response.data!['date'] as num).toDouble();
    }
    return 0;
  }
}
