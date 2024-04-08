import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imu_tester/page/page_home.dart';
import 'package:imu_tester/provider/provider_pedometer.dart';
import 'package:imu_tester/provider/provider_sensor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:jnigen/jnigen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
 await Permission.activityRecognition.request();

  runApp(const IMUTester());
}

class IMUTester extends StatelessWidget {
  const IMUTester({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IMU sensor tester',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<SensorProvider>(
            create: (context) => SensorProvider(context),
          ),
          ChangeNotifierProvider<PedometerProvider>(
            create: (context) => PedometerProvider(context),
          )
        ],
        child: const PageHome(),
      ),
    );
  }
}
