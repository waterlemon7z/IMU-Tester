import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:imu_tester/api/api_save_to_csv.dart';
import 'package:imu_tester/entity/entity_sensor.dart';
import 'package:imu_tester/page/imu_sensors/widget_realtime_chart.dart';
import 'package:imu_tester/provider/provider_sensor.dart';
import 'package:imu_tester/widget/show_toast.dart';
import 'package:path_provider/path_provider.dart';
import "package:provider/provider.dart";

class IMUPage extends StatefulWidget {
  const IMUPage({super.key});

  @override
  State<IMUPage> createState() => IMUPageState();
}

class IMUPageState extends State<IMUPage> {
  SensorEntity sensorData = SensorEntity();
  String _sensorMode = "Accelerometer";
  bool _chartVisibleAcc = true;
  bool _chartVisibleGyr = false;
  bool _chartVisibleMag = false;
  DateTime _startTime = DateTime(0, 0, 0, 0, 0, 0, 0, 0);
  String _fileSaved = "";
  Stream<int>? _stepStream;
  int _steps = 0;

  @override
  Widget build(BuildContext context) {
    final sensorProvider = Provider.of<SensorProvider>(context);
    sensorData = sensorProvider.getSensorData();
    return Column(children: [
      DataTable(
        columnSpacing:
            MediaQuery.of(context).size.width / 14, //Todo()->표 너비 다시 설정해야한다.
        columns: const [
          DataColumn(label: Text("Type")),
          DataColumn(label: Text("X")),
          DataColumn(label: Text("Y")),
          DataColumn(label: Text("Z")),
        ],
        rows: [
          DataRow(cells: [
            DataCell(const Text("Gyro."), onTap: () {
              setState(() {
                _sensorMode = "Gyroscope";
                _chartVisibleAcc = false;
                _chartVisibleGyr = true;
                _chartVisibleMag = false;
              });
            }),
            DataCell(Text(
                sensorData.gyroscopeEvent?.x.toStringAsFixed(6) ?? "0.000000")),
            DataCell(Text(
                sensorData.gyroscopeEvent?.y.toStringAsFixed(6) ?? "0.000000")),
            DataCell(Text(
                sensorData.gyroscopeEvent?.z.toStringAsFixed(6) ?? "0.000000")),
          ]),
          DataRow(cells: [
            DataCell(const Text("Accel."), onTap: () {
              setState(() {
                _sensorMode = "Accelerometer";
                _chartVisibleAcc = true;
                _chartVisibleGyr = false;
                _chartVisibleMag = false;
              });
            }),
            DataCell(Text(sensorData.accelerometerEvent?.x.toStringAsFixed(6) ??
                "0.000000")),
            DataCell(Text(sensorData.accelerometerEvent?.y.toStringAsFixed(6) ??
                "0.000000")),
            DataCell(Text(sensorData.accelerometerEvent?.z.toStringAsFixed(6) ??
                "0.000000")),
          ]),
          DataRow(cells: [
            DataCell(const Text("Magnet."), onTap: () {
              setState(() {
                _sensorMode = "Magnetometer";
                _chartVisibleAcc = false;
                _chartVisibleGyr = false;
                _chartVisibleMag = true;
              });
            }),
            DataCell(Text(sensorData.magnetometerEvent?.x.toStringAsFixed(6) ??
                "0.000000")),
            DataCell(Text(sensorData.magnetometerEvent?.y.toStringAsFixed(6) ??
                "0.000000")),
            DataCell(Text(sensorData.magnetometerEvent?.z.toStringAsFixed(6) ??
                "0.000000")),
          ]),
        ],
      ),
      Text(_sensorMode),
      Visibility(
        visible: _chartVisibleAcc,
        child: SizedBox(
          height: 100,
          child: RealTimeChart(
              provider: sensorProvider, sensorMode: "acc", axis: "X"),
        ),
      ),
      Visibility(
        visible: _chartVisibleAcc,
        child: SizedBox(
            height: 100,
            child: RealTimeChart(
                provider: sensorProvider, sensorMode: "acc", axis: "Y")),
      ),
      Visibility(
        visible: _chartVisibleAcc,
        child: SizedBox(
            height: 100,
            child: RealTimeChart(
                provider: sensorProvider, sensorMode: "acc", axis: "Z")),
      ),
      Visibility(
        visible: _chartVisibleGyr,
        child: SizedBox(
          height: 100,
          child: RealTimeChart(
              provider: sensorProvider, sensorMode: "gyr", axis: "X"),
        ),
      ),
      Visibility(
        visible: _chartVisibleGyr,
        child: SizedBox(
            height: 100,
            child: RealTimeChart(
                provider: sensorProvider, sensorMode: "gyr", axis: "Y")),
      ),
      Visibility(
        visible: _chartVisibleGyr,
        child: SizedBox(
            height: 100,
            child: RealTimeChart(
                provider: sensorProvider, sensorMode: "gyr", axis: "Z")),
      ),
      Visibility(
        visible: _chartVisibleMag,
        child: SizedBox(
          height: 100,
          child: RealTimeChart(
              provider: sensorProvider, sensorMode: "mag", axis: "X"),
        ),
      ),
      Visibility(
        visible: _chartVisibleMag,
        child: SizedBox(
            height: 100,
            child: RealTimeChart(
                provider: sensorProvider, sensorMode: "mag", axis: "Y")),
      ),
      Visibility(
        visible: _chartVisibleMag,
        child: SizedBox(
            height: 100,
            child: RealTimeChart(
                provider: sensorProvider, sensorMode: "mag", axis: "Z")),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              // style: ElevatedButton.styleFrom(backgroundColor: Colors.white, elevation: 0.0,),
              onPressed: () {
                if (!sensorProvider.isRunning()) {
                  sensorProvider.startRecord();
                  _stepStream =
                      sensorProvider.setStepStream().stream.asBroadcastStream();
                  _stepStream?.listen((event) {
                    setState(() {
                      _steps = event;
                    });
                  });
                  setState(() {
                    // _baseStep = pedometerProvider.steps;
                    _startTime = DateTime.now();
                  });
                }
              },
              child: const Text("Start"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (sensorProvider.isRunning()) {
                  final directory = await getExternalStorageDirectory();
                  String path = "${directory!.path}/${_fileOutput()}";
                  await csvOutput(sensorProvider.getSensorValueList(), path);
                  sensorProvider.stopRecord();
                  setState(() {
                    _fileSaved = "File Saved : $path";
                  });
                  showToast("Saved", true);
                } else {
                  log("Nothing to Stop");
                  showToast("Not Started", true);
                }
              },
              child: const Text("Stop"),
            ),
            ElevatedButton(
              onPressed: () {
                if (sensorProvider.isRunning()) {
                  sensorProvider.increaseCheck();
                  showToast("Checked", true);
                } else {
                  showToast("Not Started", true);
                }
              },
              child: const Text("Check"),
            ),
            ElevatedButton(
              onPressed: () {
                if (!sensorProvider.isRunning()) {
                  changeFrequency(context, sensorProvider);
                } else {
                  showToast("plz stop to change", true);
                }
              },
              child: const Text("Frequency"),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "StepCount: $_steps",
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "StartTime: ${_add0(_startTime.hour)}:${_add0(_startTime.minute)}:${_add0(_startTime.second)}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "CheckPoint: ${sensorProvider.getCurCheck()}",
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
      const SizedBox(
        height: 1,
      ),
      Text(
        _fileSaved,
        style: const TextStyle(fontSize: 15),
      ),
    ]);
  }

  String _add0(int num) {
    String rst;
    if (num % 10 != num) {
      rst = num.toString();
    } else {
      rst = "0$num";
    }
    return rst;
  }

  String _fileOutput() {
    DateTime cur = DateTime.now();
    String rst =
        "${cur.year}-${_add0(cur.month)}-${_add0(cur.day)}T${_add0(cur.hour)}:${_add0(cur.minute)}:${_add0(cur.second)}.csv";
    return rst;
  }

  Future<void> changeFrequency(
      BuildContext context, SensorProvider provider) async {
    final TextEditingController textFieldController = TextEditingController();
    String valueText = "0";
    var frequency = provider.getFrequency();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Change Frequency'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Current Frequency : $frequency ms"),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      valueText = value;
                    });
                  },
                  controller: textFieldController,
                ),
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                // color: Colors.transparent,
                textColor: Colors.black,
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                // color: Colors.green,
                textColor: Colors.black,
                child: const Text('Confirm'),
                onPressed: () {
                  setState(() {
                    if (RegExp(r'[0-9]').hasMatch(valueText)) {
                      provider.setFrequency(int.parse(valueText));
                      Navigator.pop(context);
                    } else {
                      showToast("Invalid Number", true);
                    }
                  });
                },
              ),
            ],
          );
        });
  }
}
