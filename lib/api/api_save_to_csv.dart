import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
// import 'package:path_provider/path_provider.dart';

import '../entity/entity_saved_values.dart';

Future<void> csvOutput(List<SensorValue> valueList, String path) async {
  List<List<String>> rows = List<List<String>>.empty(growable: true);
  rows.add([
    "DATETIME",
    "TICK",
    "CHECK_POINT",
    "gyroscopeX",
    "gyroscopeY",
    "gyroscopeZ",
    "accelerometerX",
    "accelerometerY",
    "accelerometerZ",
    "magnetometerX",
    "magnetometerY",
    "magnetometerZ"
  ]);
  for (var iter in valueList) {
    rows.add(iter.csvLineOutput());
  }
  try {
    String csv = const ListToCsvConverter().convert(rows);
    final file = File(path);
    await file.writeAsString(csv);
    log('CSV file has been saved.');
  } catch (e) {
    log('Error: $e');
  }
}
