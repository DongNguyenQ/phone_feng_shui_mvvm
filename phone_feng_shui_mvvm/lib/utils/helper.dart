import 'package:phone_feng_shui_mvvm/model/mobile_network_entity.dart';

class Helper {
  static String? validate(String phone, List<MobileNetworkEntity> mobileNetworks) {
    if (phone.length >= 3) {
      if (!isNumeric(phone))
        return 'Please input just number';

      MobileNetworkEntity? foundNetwork;
      for (var phoneNetwork in mobileNetworks)
        foundNetwork = findMatchMobileNetwork(phone, phoneNetwork);

      if (foundNetwork == null)
        return 'Not found mobile network, please correct phone number';
      if (phone.length < 10)
        return 'Phone length must be 10';
    }
    return null;
  }

  static bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static MobileNetworkEntity? findMatchMobileNetwork(String phone, MobileNetworkEntity phoneNetwork) {
    for (var network in phoneNetwork.detector) {
      if (phone.substring(0, 3) == network) {
        return phoneNetwork;
      }
    }
    return null;
  }

  static MobileNetworkEntity? findMatchMobileNetworkInListNetwork(String phone, List<MobileNetworkEntity> phoneNetworks) {
    for (var network in phoneNetworks) {
      final foundNetwork = findMatchMobileNetwork(phone, network);
      if (foundNetwork != null) {
        return foundNetwork;
      }
    }
    return null;
  }

  static List<String> trimAllAList(List<String> list) {
    List<String> converted = [];
    for (var element in list) {
      converted.add(element.trim());
    }
    return converted;
  }
}