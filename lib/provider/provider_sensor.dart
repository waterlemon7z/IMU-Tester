import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:imu_tester/entity/entity_chart_data.dart';
import 'package:imu_tester/entity/entity_saved_values.dart';
import 'package:imu_tester/entity/entity_sensor.dart';
import 'package:imu_tester/provider/provider_pedometer.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorProvider with ChangeNotifier {
  final Duration _ignoreDuration = const Duration(milliseconds: 100);
  final Duration _sensorInterval = SensorInterval.normalInterval;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  final SensorEntity _sensorEntity = SensorEntity();
  final List<SensorValue> _sensorValueList =
      List<SensorValue>.empty(growable: true);
  Map<String, List<ChartDataEntity>> flChartData = {};
  Timer? _timer;
  Timer? _graphTimer;
  int _checkCount = 0;
  int _frequency = 1000;
  int _baseStep = 0;
  SensorEntity getSensorData() {
    return _sensorEntity;
  }

  List<SensorValue> getSensorValueList() {
    return _sensorValueList;
  }

  void increaseCheck() {
    _checkCount++;
  }

  int getCurCheck() {
    return _checkCount;
  }
  void setFrequency(int val)
  {
    _frequency = val;
  }
  int getFrequency()
  {
    return _frequency;
  }
  void startRecord(PedometerProvider provider) {
    _checkCount = 0;
    _baseStep = provider.steps;
    log("Start Recording");
    _timer = Timer.periodic(Duration(milliseconds: _frequency), (timer) {
      _sensorValueList.add(SensorValue(_sensorEntity, _checkCount, timer.tick, provider.steps - _baseStep));
      // setState(() {});
    });
  }

   bool isRunning()
  {
    if (_timer == null || !_timer!.isActive) {
      return false;
    }
    return true;
  }
  void stopRecord() {
    log("Stop Recording");
    _timer!.cancel();
    // int indexNo = 0;
    // for (var iter in _sensorValueList) {
    //   log("[${indexNo++}]$iter");
    // }
    _sensorValueList.removeRange(0, _sensorValueList.length);
  }

  @override
  void dispose() {
    super.dispose();
    _graphTimer!.cancel();
  }

  SensorProvider(BuildContext context) {
    flChartData.addAll({
      "gyrX": List<ChartDataEntity>.empty(growable: true),
      "gyrY": List<ChartDataEntity>.empty(growable: true),
      "gyrZ": List<ChartDataEntity>.empty(growable: true),
      "accX": List<ChartDataEntity>.empty(growable: true),
      "accY": List<ChartDataEntity>.empty(growable: true),
      "accZ": List<ChartDataEntity>.empty(growable: true),
      "magX": List<ChartDataEntity>.empty(growable: true),
      "magY": List<ChartDataEntity>.empty(growable: true),
      "magZ": List<ChartDataEntity>.empty(growable: true),
    });
    for(var iter in flChartData.values)
      {
        iter.add(ChartDataEntity(x: 1, y : 0));
      }
    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: _sensorInterval).listen(
        (GyroscopeEvent event) {
          final now = DateTime.now();
          _sensorEntity.gyroscopeEvent = event;
          if (_sensorEntity.gyroscopeUpdateTime != null) {
            final interval = now.difference(_sensorEntity.gyroscopeUpdateTime!);
            if (interval > _ignoreDuration) {
              _sensorEntity.gyroscopeLastInterval = interval.inMilliseconds;
            }
          }
          _sensorEntity.gyroscopeUpdateTime = now;
          notifyListeners();
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Gyroscope Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      accelerometerEventStream(samplingPeriod: _sensorInterval).listen(
        (AccelerometerEvent event) {
          final now = DateTime.now();
          _sensorEntity.accelerometerEvent = event;
          if (_sensorEntity.accelerometerUpdateTime != null) {
            final interval =
                now.difference(_sensorEntity.accelerometerUpdateTime!);
            if (interval > _ignoreDuration) {
              _sensorEntity.accelerometerLastInterval = interval.inMilliseconds;
            }
          }
          _sensorEntity.accelerometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Accelerometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      magnetometerEventStream(samplingPeriod: _sensorInterval).listen(
        (MagnetometerEvent event) {
          final now = DateTime.now();
          _sensorEntity.magnetometerEvent = event;
          if (_sensorEntity.magnetometerUpdateTime != null) {
            final interval =
                now.difference(_sensorEntity.magnetometerUpdateTime!);
            if (interval > _ignoreDuration) {
              _sensorEntity.magnetometerLastInterval = interval.inMilliseconds;
            }
          }
          _sensorEntity.magnetometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Magnetometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _graphTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_sensorEntity.gyroscopeEvent == null ||
          _sensorEntity.accelerometerEvent == null ||
          _sensorEntity.magnetometerEvent == null) {
        return;
      }
      flChartData["gyrX"]!.add(
          ChartDataEntity(x: timer.tick, y: _sensorEntity.gyroscopeEvent!.x));
      flChartData["gyrY"]!.add(
          ChartDataEntity(x: timer.tick, y: _sensorEntity.gyroscopeEvent!.y));
      flChartData["gyrZ"]!.add(
          ChartDataEntity(x: timer.tick, y: _sensorEntity.gyroscopeEvent!.z));
      flChartData["accX"]!.add(ChartDataEntity(
          x: timer.tick, y: _sensorEntity.accelerometerEvent!.x));
      flChartData["accY"]!.add(ChartDataEntity(
          x: timer.tick, y: _sensorEntity.accelerometerEvent!.y));
      flChartData["accZ"]!.add(ChartDataEntity(
          x: timer.tick, y: _sensorEntity.accelerometerEvent!.z));
      flChartData["magX"]!.add(ChartDataEntity(
          x: timer.tick, y: _sensorEntity.magnetometerEvent!.x));
      flChartData["magY"]!.add(ChartDataEntity(
          x: timer.tick, y: _sensorEntity.magnetometerEvent!.y));
      flChartData["magZ"]!.add(ChartDataEntity(
          x: timer.tick, y: _sensorEntity.magnetometerEvent!.z));
    });
  }

  void deleteSub() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }
}
