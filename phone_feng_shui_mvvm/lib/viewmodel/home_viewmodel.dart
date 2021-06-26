import 'dart:async';

import 'package:phone_feng_shui_mvvm/model/feng_shui_number_quality.dart';
import 'package:phone_feng_shui_mvvm/model/mobile_network_entity.dart';
import 'package:phone_feng_shui_mvvm/repository/feng_shui_repository.dart';
import 'package:phone_feng_shui_mvvm/repository/service/local/local_service.dart';
import 'package:phone_feng_shui_mvvm/service_locator.dart';
import 'package:phone_feng_shui_mvvm/utils/helper.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel {
  final _onReadySubject = BehaviorSubject<dynamic>();

  final _phoneStatusSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();
  final _networkSubject = BehaviorSubject<MobileNetworkEntity?>();
  final _fengShuiRepository = locator<FengShuiRepository>();

  List<MobileNetworkEntity>? _mobileNetworksFromRepository;

  Stream<dynamic> get readyStream => _onReadySubject.stream;
  Sink<dynamic> get readySink => _onReadySubject.sink;

  Stream<String?> get phoneStream =>
      _phoneStatusSubject.stream;
  Sink<String?> get phoneSink => _phoneStatusSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  Stream<MobileNetworkEntity?> get networkStream =>
          _networkSubject.stream;
  Sink<MobileNetworkEntity?> get networkSink => _networkSubject.sink;

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
    readySink.add(numberQuality);
  }

  HomeViewModel() {
    initData();
    _phoneStatusSubject.stream.listen((value) {
      dynamic firstValidate = Helper.validate(value, _mobileNetworksFromRepository!);
      readySink.add(firstValidate);
      if (firstValidate == null) {
        btnSink.add(true);
      } else {
        btnSink.add(false);
      }
      if (value.length >= 3) {
        dynamic foundNetwork = Helper.findMatchMobileNetworkInListNetwork(value, _mobileNetworksFromRepository!);
        networkSink.add(foundNetwork);
      } else {
        networkSink.add(null);
      }

    });
  }

  initData() async {
    this._mobileNetworksFromRepository = await _fengShuiRepository.getMobileNetworks();
  }

  dispose() {
    _onReadySubject.drain();
    _onReadySubject.close();

    _phoneStatusSubject.drain();
    _phoneStatusSubject.close();
    _btnSubject.drain();
    _btnSubject.close();
    _networkSubject.drain();
    _networkSubject.close();
  }

}