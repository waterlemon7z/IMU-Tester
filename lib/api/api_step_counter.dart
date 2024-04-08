import 'package:imu_tester/step_counter.dart';
import 'package:jni/jni.dart';

class ApiStepCounter
{
  JObject activity = JObject.fromReference(Jni.getCurrentActivity());
  JObject context = JObject.fromReference(Jni.getCachedApplicationContext());
    final stepCounter = StepCounter(1.0);
    ApiStepCounter()
    {
      stepCounter.start();
    }
    void addAccel(int time, double x, double y, double z)
    {

      JArray<jfloat> arr = [x, y, z] as JArray<jfloat>;
      print('$x $y $z');
    stepCounter.processSample(time, arr);
    }
    int getStepCounter()
    {
     return stepCounter.getSteps();
  }
}