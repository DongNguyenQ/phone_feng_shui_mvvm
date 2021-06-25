import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:phone_feng_shui_mvvm/model/mobile_network_entity.dart';
import 'package:phone_feng_shui_mvvm/utils/helper.dart';

class LocalService {
  Future<List<String>> loadAssetAsList(String url) async {
    final _loadedData = await rootBundle.loadString(url);
    List<String> lines = _loadedData.split('\n');
    List<String> numbers = [];
    for(var line in lines) {
      final dataEachLine = line.split(',');
      numbers.addAll(Helper.trimAllAList(dataEachLine));
    }
    numbers.toSet().toList();
    return numbers;
  }

  Future<List<MobileNetworkEntity>> loadMobileNetworksFromLocal(String url) async {
    final data = await rootBundle.loadString(url);
    final networks = List<MobileNetworkEntity>.
          from(json.decode(data).map((model)=>
              MobileNetworkEntity.fromJson(model)));
    return networks;
  }
}