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
  String _sensorMode = "acc";
  bool _chartVisibleAcc = true;
  bool _chartVisibleGyr = false;
  bool _chartVisibleMag = false;
  DateTime _startTime = DateTime(0, 0, 0, 0, 0, 0, 0, 0);
  String _fileSaved = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<SensorProvider>(
      builder: (BuildContext context, SensorProvider value, Widget? child) {
        sensorData = value.getSensorData();
        return Column(children: [
          DataTable(
            columnSpacing: MediaQuery.of(context).size.width /
                14, //Todo()->표 너비 다시 설정해야한다.
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
                    sensorData.gyroscopeEvent?.x.toStringAsFixed(6) ?? '?')),
                DataCell(Text(
                    sensorData.gyroscopeEvent?.y.toStringAsFixed(6) ?? '?')),
                DataCell(Text(
                    sensorData.gyroscopeEvent?.z.toStringAsFixed(6) ?? '?')),
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
                DataCell(Text(
                    sensorData.accelerometerEvent?.x.toStringAsFixed(6) ??
                        '?')),
                DataCell(Text(
                    sensorData.accelerometerEvent?.y.toStringAsFixed(6) ??
                        '?')),
                DataCell(Text(
                    sensorData.accelerometerEvent?.z.toStringAsFixed(6) ??
                        '?')),
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
                DataCell(Text(
                    sensorData.magnetometerEvent?.x.toStringAsFixed(6) ?? '?')),
                DataCell(Text(
                    sensorData.magnetometerEvent?.y.toStringAsFixed(6) ?? '?')),
                DataCell(Text(
                    sensorData.magnetometerEvent?.z.toStringAsFixed(6) ?? '?')),
              ]),
            ],
          ),
          Text(_sensorMode),
          Visibility(
            visible: _chartVisibleAcc,
            child: SizedBox(
              height: 100,
              child:
                  RealTimeChart(provider: value, sensorMode: "acc", axis: "X"),
            ),
          ),
          Visibility(
            visible: _chartVisibleAcc,
            child: SizedBox(
                height: 100,
                child: RealTimeChart(
                    provider: value, sensorMode: "acc", axis: "Y")),
          ),
          Visibility(
            visible: _chartVisibleAcc,
            child: SizedBox(
                height: 100,
                child: RealTimeChart(
                    provider: value, sensorMode: "acc", axis: "Z")),
          ),
          Visibility(
            visible: _chartVisibleGyr,
            child: SizedBox(
              height: 100,
              child:
                  RealTimeChart(provider: value, sensorMode: "gyr", axis: "X"),
            ),
          ),
          Visibility(
            visible: _chartVisibleGyr,
            child: SizedBox(
                height: 100,
                child: RealTimeChart(
                    provider: value, sensorMode: "gyr", axis: "Y")),
          ),
          Visibility(
            visible: _chartVisibleGyr,
            child: SizedBox(
                height: 100,
                child: RealTimeChart(
                    provider: value, sensorMode: "gyr", axis: "Z")),
          ),
          Visibility(
            visible: _chartVisibleMag,
            child: SizedBox(
              height: 100,
              child:
                  RealTimeChart(provider: value, sensorMode: "mag", axis: "X"),
            ),
          ),
          Visibility(
            visible: _chartVisibleMag,
            child: SizedBox(
                height: 100,
                child: RealTimeChart(
                    provider: value, sensorMode: "mag", axis: "Y")),
          ),
          Visibility(
            visible: _chartVisibleMag,
            child: SizedBox(
                height: 100,
                child: RealTimeChart(
                    provider: value, sensorMode: "mag", axis: "Z")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  // style: ElevatedButton.styleFrom(backgroundColor: Colors.white, elevation: 0.0,),
                  onPressed: () {
                    if (!value.isRunning()) {
                      value.startRecord();
                      setState(() {
                        _startTime = DateTime.now();
                      });
                    }
                  },
                  child: const Text("Start"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (value.isRunning()) {
                      final directory = await getExternalStorageDirectory();
                      String path = "${directory!.path}/${DateTime.now()}";
                      await csvOutput(value.getSensorValueList(), path);
                      value.stopRecord();
                      setState(() {
                        _fileSaved = "File Saved : $path";
                      });
                    } else {
                      log("Nothing to Stop");
                    }
                  },
                  child: const Text("Stop"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (value.isRunning()) {
                      value.increaseCheck();
                    }
                  },
                  child: const Text("Check"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!value.isRunning()) {
                      changeFrequency(context, value);
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
                "StartTime: ${_startTime.hour}:${_startTime.minute.toString()}:${_startTime.second}",
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                "CheckPoint: ${value.getCurCheck()}",
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
      },
    );
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
                    if (RegExp(r'0-9').hasMatch(valueText)) {
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
