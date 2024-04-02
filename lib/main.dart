import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imu_tester/page/page_home.dart';
import 'package:imu_tester/provider/provider_sensor.dart';

// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:io';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // PermissionStatus status = await Permission.manageExternalStorage.request();
  //
  // final dir = await getExternalStorageDirectories();
  //
  // // 디렉터리 경로 가져온 후 하위 디렉토리 생성
  // Directory path_dir = await Directory('${dir?[0]}/').create(recursive: true);
  // // 위에서 생성한 디렉토리에 파일 생성하고 리턴
  // print('경로 : ${path_dir.path}');
  //
  // if (status.isDenied) {
  //   print('권한요청 실패');
  // } else {
  //   print('권한요청 성공');
  // }

  runApp(const IMUTester());
}

class IMUTester extends StatelessWidget {
  const IMUTester({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMU sensor tester',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider<SensorProvider>(
        create: (context) => SensorProvider(context),
        child: const PageHome(),
      ),
    );
  }
}
