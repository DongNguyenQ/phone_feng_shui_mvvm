import 'package:phone_feng_shui_mvvm/model/feng_shui_number_quality.dart';
import 'package:phone_feng_shui_mvvm/model/mobile_network_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  static String? validate(String phone, List<MobileNetworkEntity> mobileNetworks) {
    if (phone.length >= 3) {
      if (!isNumeric(phone))
        return 'Please input just number';

      MobileNetworkEntity? foundNetwork =
          findMatchMobileNetworkInListNetwork(phone, mobileNetworks);
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

  static bool findMatchNumberInAList(String number, List<String> numbers) {
    bool isMatch = false;
    for (var num in numbers) {
      if (number == num) {
        isMatch = true;
      }
    }
    return isMatch;
  }

  static List<String> trimAllAList(List<String> list) {
    List<String> converted = [];
    for (var element in list) {
      converted.add(element.trim());
    }
    return converted;
  }

  static FengShuiNumberQuality validateTabooNumber(
      String phone, List<String> tabooNumbers) {
    FengShuiNumberQuality result = new FengShuiNumberQuality(
        true, message: '$phone is good feng shui number.', phone: phone);
    if (tabooNumbers != null) {
      for (var number in tabooNumbers) {
        if (number == phone.substring(phone.length - 2)) {
          result.message = 'Bad fend shui number. Match taboo number $tabooNumbers';
          result.isGood = false;
          return result;
        }
      }
    }
    return result;
  }

  static int calculateTotalOfAString(String numbers) {
    int total = 0;
    numbers.runes.forEach((int rune) {
      var character = new String.fromCharCode(rune);
      total += int.parse(character);
    });
    return total;
  }

  static makePhoneCall(String phone) {
    final schema = 'tel:$phone';
    launch(schema);
  }
}