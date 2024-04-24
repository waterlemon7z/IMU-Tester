import 'package:imu_tester/entity/entity_sensor.dart';
import 'package:intl/intl.dart';

class SensorValue {
  SensorValue(SensorEntity entity, int check, int tick, int steps) {
    _check = check;
    _tick = tick;
    _gyroscopeX = entity.gyroscopeEvent?.x ?? 0.0;
    _gyroscopeY = entity.gyroscopeEvent?.y ?? 0.0;
    _gyroscopeZ = entity.gyroscopeEvent?.z ?? 0.0;
    _accelerometerX = entity.accelerometerEvent?.x ?? 0.0;
    _accelerometerY = entity.accelerometerEvent?.y ?? 0.0;
    _accelerometerZ = entity.accelerometerEvent?.z ?? 0.0;
    _magnetometerX = entity.magnetometerEvent?.x ?? 0.0;
    _magnetometerY = entity.magnetometerEvent?.y ?? 0.0;
    _magnetometerZ = entity.magnetometerEvent?.z ?? 0.0;
    _filteredData = 0;
    _steps =steps;
  }

  set filteredData(double value) {
    _filteredData = value;
  }

  final DateTime _time = DateTime.now();
  int? _check;
  int? _tick;
  int? _steps;
  double? _gyroscopeX;
  double? _gyroscopeY;
  double? _gyroscopeZ;
  double? _accelerometerX;
  double? _accelerometerY;
  double? _accelerometerZ;
  double? _magnetometerX;
  double? _magnetometerY;
  double? _magnetometerZ;
  double? _filteredData;

  set steps(int value) {
    _steps = value;
  }

  DateTime get time => _time;

  double? get gyroscopeX => _gyroscopeX;

  double? get gyroscopeY => _gyroscopeY;

  double? get gyroscopeZ => _gyroscopeZ;

  double? get accelerometerX => _accelerometerX;

  double? get accelerometerY => _accelerometerY;

  double? get accelerometerZ => _accelerometerZ;

  double? get magnetometerX => _magnetometerX;

  double? get magnetometerY => _magnetometerY;

  double? get magnetometerZ => _magnetometerZ;

  int? get check => _check;

  @override
  String toString() {
    return 'SensorValue{_time: $_time, _check: $_check, _gyroscopeX: $_gyroscopeX, _gyroscopeY: $_gyroscopeY, _gyroscopeZ: $_gyroscopeZ, _accelerometerX: $_accelerometerX, _accelerometerY: $_accelerometerY, _accelerometerZ: $_accelerometerZ, _magnetometerX: $_magnetometerX, _magnetometerY: $_magnetometerY, _magnetometerZ: $_magnetometerZ}';
  }

  List<String> csvLineOutput() {
    return <String>[
      (DateFormat("yyyyMMdd").format(_time)),
      (DateFormat("HHmm").format(_time)),
      "${_time.microsecondsSinceEpoch}00",
      "$_tick",
      "$_check",
      "$_gyroscopeX",
      "$_gyroscopeY",
      "$_gyroscopeZ",
      "$_accelerometerX",
      "$_accelerometerY",
      "$_accelerometerZ",
      "$_magnetometerX",
      "$_magnetometerY",
      "$_magnetometerZ",
      "$_filteredData",
      "$_steps",
    ];
  }
// @override
// String toString() {
//   return  'Time: $_time, '
//       'gyro. x: $gyroscopeX, '
//       'gyro. y: $gyroscopeY, '
//       'gyro. z: $gyroscopeZ, '
//       'accel. x: $accelerometerX, '
//       'accel. y: $accelerometerY, '
//       'accel. z: $accelerometerZ, '
//       'magnet. x: $magnetometerX, '
//       'magnet. y: $magnetometerY, '
//       'magnet. z: $magnetometerZ}';
// }
}
