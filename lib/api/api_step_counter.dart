import 'dart:math';
import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';

class StepCounter {
  int _steps = 0;

  int get steps => _steps;

  void updateSteps(List<double> newValues) {
    int length = newValues.length;
    double sum = 0;
    newValues.forEach((element) {
      sum += element;
    });
    // 평균 계산
    double mean = sum / length;

    for (int i = 0; i < newValues.length; i++) {
      newValues[i] -= mean;
    }
    sum = 0;
    newValues.forEach((element) {
      sum += element;
    });
    // 평균 계산
    mean = sum / length;
    // 분산 계산
    double variance =
        newValues.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / length;

    // 표준편차 계산
    double stdDev = sqrt(variance);

    stdDev = max(stdDev, 1);
    List<dynamic> peaks = findPeaks(Array(newValues), threshold: stdDev);
    Array rst = peaks[0];
    _steps += rst.length;
  }
}
