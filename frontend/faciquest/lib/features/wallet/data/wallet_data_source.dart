import 'package:dio/dio.dart';

abstract class WalletDataSource {
  Future<double?> getWallet();
  Future<void> cashOut(double amount);
}

class WalletDataSourceImpl implements WalletDataSource {
  const WalletDataSourceImpl({required this.dioClient});

  final Dio dioClient;

  @override
  Future<double?> getWallet() async {
    return null;
  }

  @override
  Future<void> cashOut(double amount) async {}
}
