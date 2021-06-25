import 'package:phone_feng_shui_mvvm/repository/service/local/local_service.dart';
import 'package:phone_feng_shui_mvvm/model/mobile_network_entity.dart';

class FengShuiRepository {
  LocalService _localService = new LocalService();
  final _fengShuiFilePath = 'assets/res/feng_shui_number.txt';
  final _mobileNetworkFilePath = 'assets/res/mobile_network.json';

  Future<List<String>> getFengShuiNumbers() async {
    final list = _localService.loadAssetAsList(_fengShuiFilePath);
    return list;
  }

  Future<List<MobileNetworkEntity>> getMobileNetworks() async {
    return _localService.loadMobileNetworksFromLocal(_mobileNetworkFilePath);
  }

}