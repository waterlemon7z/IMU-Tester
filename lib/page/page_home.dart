import 'package:flutter/material.dart';
import 'package:imu_tester/page/page_imu_sensors.dart';

class PageHome extends StatelessWidget {
  const PageHome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("IMU Sensor Tester"),
      ),
      body: const IMUPage(),
    );
  }
}