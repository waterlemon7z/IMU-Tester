import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
// import 'package:path_provider/path_provider.dart';

import '../entity/entity_saved_values.dart';

class CSVManager{
  String _filePath;

  CSVManager(this._filePath)
  {
    List<List<String>> rows = List<List<String>>.empty(growable: true);
    rows.addAll([[
      "DATE",
      "TIME",
      "SEC",
      "RUNTIME",
      "PTNUM",
      "acceleration X",
      "acceleration Y",
      "acceleration Z",
      "Geomagnetic X",
      "Geomagnetic Y",
      "Geomagnetic Z",
      "gyro X",
      "gyro Y",
      "gyro Z",
      "filtered data",
      "Step Count"
    ],[]]);
    String csv = const ListToCsvConverter().convert(rows);
    final file = File(_filePath).openWrite(mode:FileMode.append);

    file.write(csv);
    // await file.writeAsString(csv);
    file.close();
  }

  Future<void> csvUpdate(List<SensorValue> valueList) async {

    List<List<String>> rows = List<List<String>>.empty(growable: true);
    for (var iter in valueList) {
      rows.add(iter.csvLineOutput());
    }
    try {
      String csv = const ListToCsvConverter().convert(rows);
      final file = File(_filePath).openWrite(mode:FileMode.append);
      
      file.write(csv);
      // await file.writeAsString(csv);
      file.close();
      log('CSV file has been saved.');
    } catch (e) {
      log('Error: $e');
    }
  }

}
