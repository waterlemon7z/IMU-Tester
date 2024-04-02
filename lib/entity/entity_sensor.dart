import 'package:sensors_plus/sensors_plus.dart';

class SensorEntity {
  GyroscopeEvent? gyroscopeEvent;
  AccelerometerEvent? accelerometerEvent;
  MagnetometerEvent? magnetometerEvent;

  DateTime? accelerometerUpdateTime;
  DateTime? gyroscopeUpdateTime;
  DateTime? magnetometerUpdateTime;

  int? gyroscopeLastInterval;
  int? accelerometerLastInterval;
  int? magnetometerLastInterval;

  @override
  String toString() {
    return  'gyroscope x: ${gyroscopeEvent?.x.toStringAsFixed(6) ?? '?'}, '
        'gyroscope y: ${gyroscopeEvent?.y.toStringAsFixed(6) ?? '?'}, '
        'gyroscope z: ${gyroscopeEvent?.z.toStringAsFixed(6) ?? '?'}, '
        'accelerometer x: ${accelerometerEvent?.x.toStringAsFixed(6) ?? '?'}, '
        'accelerometer y: ${accelerometerEvent?.y.toStringAsFixed(6) ?? '?'}, '
        'accelerometer z: ${accelerometerEvent?.z.toStringAsFixed(6) ?? '?'}, '
        'magnetometer x: ${magnetometerEvent?.x.toStringAsFixed(6) ?? '?'}, '
        'magnetometer y: ${magnetometerEvent?.y.toStringAsFixed(6) ?? '?'}, '
        'magnetometer z: ${magnetometerEvent?.z.toStringAsFixed(6) ?? '?'}}';
  }
}
