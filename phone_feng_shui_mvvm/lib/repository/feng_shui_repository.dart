import 'package:phone_feng_shui_mvvm/repository/service/local/local_service.dart';

class FengShuiRepository {
  LocalService _localService = new LocalService();
  final _fengShuiFilePath = 'assets/res/feng_shui_number.txt';

  Future<List<String>> getFengShuiNumbers() async {
    final list = _localService.loadAssetAsList(_fengShuiFilePath);
    return list;
  }
}