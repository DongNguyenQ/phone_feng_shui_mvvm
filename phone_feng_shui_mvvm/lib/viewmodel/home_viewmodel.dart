import 'dart:async';

import 'package:phone_feng_shui_mvvm/model/feng_shui_number_quality.dart';
import 'package:phone_feng_shui_mvvm/model/mobile_network_entity.dart';
import 'package:phone_feng_shui_mvvm/repository/feng_shui_repository.dart';
import 'package:phone_feng_shui_mvvm/utils/helper.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel {
  final _phoneStatusSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();
  final _networkSubject = BehaviorSubject<String>();
  final _qualitySubject = BehaviorSubject<FengShuiNumberQuality?>();
  final _fengShuiRepository = FengShuiRepository();
  static List<MobileNetworkEntity> mobileNetworks = [
    new MobileNetworkEntity('102132456', 'viettel', 'assets/viettel_logo.jpg', ['086', '096', '097']),
    new MobileNetworkEntity('102132457', 'mobiphone', 'assets/mobiphone_logo.png', ['089', '090', '093']),
    new MobileNetworkEntity('102132458', 'vinaphone', 'assets/vinaphone_logo.jpg', ['088', '091', '094']),
  ];

  Stream<FengShuiNumberQuality?> get qualityStream => _qualitySubject.stream;
  Sink<FengShuiNumberQuality?> get qualitySink => _qualitySubject.sink;

  Stream<String?> get phoneStream =>
      _phoneStatusSubject.stream.transform(_phoneValidation);
  Sink<String?> get phoneSink {
    // print('_phoneStatusSubject.value : ${_phoneStatusSubject.valueOrNull}');
    // if (_phoneStatusSubject.hasValue) {
    //   final validateResult = Helper.validate(_phoneStatusSubject.value, mobileNetworks);
    //   if (validateResult != null) {
    //     return _phoneStatusSubject.sink;
    //   } else {
    //     return _qualitySubject.sink;
    //   }
    // }
    return _phoneStatusSubject.sink;
  }

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  Stream<MobileNetworkEntity?> get networkStream =>
          _networkSubject.stream.transform(_networkValidation);
  Sink<String> get networkSink => _networkSubject.sink;

  StreamTransformer<String, String?> _phoneValidation = StreamTransformer<String, String?>.fromHandlers(
    handleData: (data, sink) {
      sink.add(Helper.validate(data, mobileNetworks));
    }
  );

  StreamTransformer<String, MobileNetworkEntity?> _networkValidation
      = StreamTransformer<String, MobileNetworkEntity?>.fromHandlers(
      handleData: (data, sink) {
        sink.add(Helper.findMatchMobileNetworkInListNetwork(data, mobileNetworks));
      }
  );

  Future<void> qualifyPhone(String phone) async {
    FengShuiNumberQuality numberQuality = new FengShuiNumberQuality(
          true, message: '$phone is good feng shui number.', phone: phone);

    final tabooNumbers = await _fengShuiRepository.getTabooNumbers();
    final isMatchedTaboo = Helper.findMatchNumberInAList(
        phone.substring(phone.length - 2), tabooNumbers);
    if (isMatchedTaboo) {
      numberQuality.isGood = false;
      numberQuality.message = 'Bad fend shui number - Match taboo number \n $tabooNumbers';
    } else {
      final caculatedNumber =
          Helper.calculateTotalOfAString(phone.substring(0, 5)) /
              Helper.calculateTotalOfAString(phone.substring(5));
      if (caculatedNumber != 24/29 && caculatedNumber != 24/28) {
        numberQuality.isGood = false;
        numberQuality.message = 'Bad fend shui number - First 5 (${Helper.calculateTotalOfAString(phone.substring(0, 5))}) '
                '/ last 5 (${Helper.calculateTotalOfAString(phone.substring(5))}) '
                '\n -> not equal 24/29 or 24/28';
      } else {
        final nicePairs = await _fengShuiRepository.getNicePairNumbers();
        final compareNumber = phone.substring(phone.length - 2);
        final isFound = Helper.findMatchNumberInAList(compareNumber, nicePairs);
        if (!isFound) {
          numberQuality.isGood = false;
          numberQuality.message = 'Bad fend shui number - Not match any nice pair \n $nicePairs';
        }
      }
    }
    print('MESSAGE : ${numberQuality.message}');
    qualitySink.add(numberQuality);
  }

  void resetStatusQualify() {
    qualitySink.add(null);
  }

  HomeViewModel() {
    Rx.combineLatest2(_phoneStatusSubject, _networkSubject, (phone, network) {
      return Helper.validate(phone.toString(), mobileNetworks) != null
          || phone.toString().length <= 3 ? false : true;
    }).listen((enable) {
      btnSink.add(enable);
    });
  }

  dispose() {
    _phoneStatusSubject.drain();
    _phoneStatusSubject.close();
    _btnSubject.drain();
    _btnSubject.close();
    _networkSubject.drain();
    _networkSubject.close();
    _qualitySubject.drain();
    _qualitySubject.close();
  }

}