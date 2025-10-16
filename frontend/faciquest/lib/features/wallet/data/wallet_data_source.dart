import 'package:dio/dio.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';

abstract class WalletDataSource {
  Future<WalletEntity> getWallet();
  Future<WalletEntity> updateWallet(UpdateWalletRequest request);
  Future<void> cashOutRequest(CashOutRequest request);
}

class WalletDataSourceImpl implements WalletDataSource {
  const WalletDataSourceImpl({
    required this.dioClient,
    required this.dioService,
  });

  final Dio dioClient;
  final DioService dioService;

  @override
  Future<WalletEntity> getWallet() async {
    return dioService.handleRequest<WalletEntity>(() async {
      final response = await dioClient.get<Map<String, dynamic>>(
        AppUrls.getWallet,
      );

      if (response.data == null) {
        throw ApiException(message: 'No data received from server');
      }

      final walletResponse = WalletResponseDto.fromMap(response.data!);
      return walletResponse.toEntity();
    });
  }

  @override
  Future<WalletEntity> updateWallet(UpdateWalletRequest request) async {
    return dioService.handleRequest<WalletEntity>(() async {
      final dto = UpdateWalletDto.fromRequest(request);

      final response = await dioClient.post<Map<String, dynamic>>(
        AppUrls.updateWallet,
        data: dto.toMap(),
      );

      if (response.data == null) {
        throw ApiException(message: 'No data received from server');
      }

      final walletResponse = WalletResponseDto.fromMap(response.data!);
      return walletResponse.toEntity();
    });
  }

  @override
  Future<void> cashOutRequest(CashOutRequest request) async {
    return dioService.handleRequest<void>(() async {
      final requestDate = DateTime.now();
      final dto = CashOutRequestDto.fromRequest(request, requestDate);

      final response = await dioClient.post<Map<String, dynamic>>(
        AppUrls.cashOutRequest,
        data: dto.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw ApiException(
          message: 'Failed to submit cash out request',
        );
      }
    });
  }
}
