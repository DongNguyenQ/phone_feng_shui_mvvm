import 'dart:async';

import 'package:phone_feng_shui_mvvm/model/mobile_network_entity.dart';
import 'package:phone_feng_shui_mvvm/repository/feng_shui_repository.dart';
import 'package:phone_feng_shui_mvvm/utils/helper.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel {
  final _phoneSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();
  final _networkSubject = BehaviorSubject<String>();
  final _qualitySubject = BehaviorSubject<String>();
  final _fengShuiRepository = FengShuiRepository();
  static List<MobileNetworkEntity> mobileNetworks = [
    new MobileNetworkEntity('102132456', 'viettel', 'assets/viettel_logo.jpg', ['086', '096', '097']),
    new MobileNetworkEntity('102132457', 'mobiphone', 'assets/mobiphone_logo.png', ['089', '090', '093']),
    new MobileNetworkEntity('102132458', 'vinaphone', 'assets/vinaphone_logo.jpg', ['088', '091', '094']),
  ];

  Stream<String?> get phoneStream =>
          _phoneSubject.stream.transform(_phoneValidation);
  Sink<String> get phoneSink => _phoneSubject.sink;
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

  HomeViewModel() {
    Rx.combineLatest2(_phoneSubject, _networkSubject, (phone, network) {
      return Helper.validate(phone.toString(), mobileNetworks) != null
          || phone.toString().length <= 3 ? false : true;
    }).listen((enable) {
      btnSink.add(enable);
    });
  }

  void validateQualityFengShuiNumber(String phone) async {
    List<String> fengShuiNumbers = await _fengShuiRepository.getFengShuiNumbers();
    if (fengShuiNumbers != null) {
      for (var number in fengShuiNumbers) {
        print('phone.substring(phone.length - 2) : ${phone.substring(phone.length - 2)}');
        print('Number : $number');
        print('IS MATCH : ${number == phone.substring(phone.length - 2)}');
        if (number == phone.substring(phone.length - 2)) {
          phoneSink.add('Bad fend shui number.');
          return;
        }
      }
    }
  }



  dispose() {
    _phoneSubject.drain();
    _phoneSubject.close();
    _btnSubject.drain();
    _btnSubject.close();
    _networkSubject.drain();
    _networkSubject.close();
  }

}