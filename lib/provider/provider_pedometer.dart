import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class PedometerProvider with ChangeNotifier{
 late Stream<StepCount> _stepCountStream;
 late Stream<PedestrianStatus> _pedestrianStatusStream;
  String status = 'wait..';
  int steps = 0;

  PedometerProvider(BuildContext context)
  {
     // initPlatformState();
  }
  /// Handle step count changed
  void onStepCount(StepCount event) {
     steps =  event.steps;
    DateTime timeStamp = event.timeStamp;
    notifyListeners();
  }

  /// Handle status changed
  void onPedestrianStatusChanged(PedestrianStatus event) {
    status = event.status;
    DateTime timeStamp = event.timeStamp;
    notifyListeners();

  }

  /// Handle the error
 void onPedestrianStatusError(error) {
   print('onPedestrianStatusError: $error');
     status = 'Pedestrian Status not available';
     notifyListeners();
   print(status);
 }

  /// Handle the error
 void onStepCountError(error) {
   print('onStepCountError: $error');
     steps = -1;
   notifyListeners();
 }

 Future<void> initPlatformState() async {
    // Init streams
    _pedestrianStatusStream = await Pedometer.pedestrianStatusStream;
    _stepCountStream = await Pedometer.stepCountStream;

    // Listen to streams and handle errors
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
  }
}
