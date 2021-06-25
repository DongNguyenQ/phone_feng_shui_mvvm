import 'package:phone_feng_shui_mvvm/repository/service/local/local_service.dart';
import 'package:phone_feng_shui_mvvm/model/mobile_network_entity.dart';

class FengShuiRepository {
  LocalService _localService = new LocalService();
  final _fengShuiFilePath = 'assets/res/taboo_numbers.txt';
  final _mobileNetworkFilePath = 'assets/res/mobile_network.json';
  final _nicePairsNumberFilePath = 'assets/res/nice_pair_numbers.txt';

  Future<List<String>> getFengShuiNumbers() async {
    final list = _localService.loadAssetAsList(_fengShuiFilePath);
    return list;
  }

  Future<List<MobileNetworkEntity>> getMobileNetworks() async {
    return _localService.loadMobileNetworksFromLocal(_mobileNetworkFilePath);
  }

  Future<List<String>> getNicePairNumbers() async {
    final list = _localService.loadAssetAsList(_nicePairsNumberFilePath);
    return list;
  }

}