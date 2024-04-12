import 'package:imu_tester/step_counter.dart';
import 'package:jni/jni.dart';

class ApiStepCounter
{
  JObject activity = JObject.fromReference(Jni.getCurrentActivity());
  JObject context = JObject.fromReference(Jni.getCachedApplicationContext());
    final stepCounter = StepCounter(0.01);
    ApiStepCounter()
    {
      stepCounter.start();
    }
    void addAccel(int time, double x, double y, double z)
    {

      JArray<jfloat> arr = JArray<jfloat>(const jfloatType(),3);
      arr[0] = x;
      arr[1] = y;
      arr[2] = z;
      print('${arr[0]} ${arr[1]} ${arr[2]}');
    stepCounter.processSample(DateTime.now().millisecondsSinceEpoch*1000, arr);
    }
    int getStepCounter()
    {
     return stepCounter.getSteps();
  }
}