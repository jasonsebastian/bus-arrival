import 'dart:convert';

import 'package:flutter/services.dart';

import '../model/stop.dart';
import 'info.dart';

Future<List<Stop>> getStopsByCodes(codes) async {
  final data = await readFromJson();
  List<Stop> stops = <Stop>[];
  for (var code in codes) {
    stops.add(Stop.fromJson(code, data[code] as List));
  }
  return stops;
}

Future<String?> getStopCodeByDescription(description) async {
  final data = await readFromJson();
  if (!data.values
      .map((element) => element[descriptionIndex])
      .contains(description)) {
    return null;
  }
  return data.entries
      .toList()
      .firstWhere((element) => element.value[descriptionIndex] == description)
      .key;
}

Future<Map<String, dynamic>> readFromJson() async {
  final String response = await rootBundle.loadString('assets/stops.json');
  return await json.decode(response) as Map<String, dynamic>;
}
