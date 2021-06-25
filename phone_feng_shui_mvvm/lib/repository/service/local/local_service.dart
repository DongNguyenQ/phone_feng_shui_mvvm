import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
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
}