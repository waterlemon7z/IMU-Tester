import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';

class StepCounter {
  int _steps = 0;
  int _totalSize = 0;
  double _totalVari = 0;

  int get steps => _steps;

  List<dynamic> updateSteps(List<double> newValues) {
    newValues = _movingAverage(newValues, 3);

    int length = newValues.length;
    double sum = 0;
    for (var element in newValues) {
      sum += element;
    }
    // 들어 오는 값을 평균으로 나눠서 정규화
    double mean = sum / length;
    for (int i = 0; i < newValues.length; i++) {
      newValues[i] -= mean;
    }

    sum = 0;
    for (var element in newValues) {
      sum += element;
    }

    mean = sum / length;
    double newVariance =
        newValues.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / length;
    if (_totalVari != 0) {
      var combinedVari =
          _combinedVariance(_totalVari, _totalSize, newVariance, length);
      _totalVari = combinedVari;
    }else{_totalVari = newVariance;}
    _totalSize += length;
    var stdDev = sqrt(_totalVari);
    stdDev = max(stdDev, 0.9);

    // Butterworth butterworth = Butterworth();
    // butterworth.lowPass(4, 250, 50);
    // List<double> filteredData = [];
    // for(var v in newValues) {
    //   filteredData.add(butterworth.filter(v));
    // }
    // newValues = filteredData;
    List<dynamic> peaks = findPeaks(Array(newValues), threshold: stdDev);
    Array rst = peaks[0];
    _steps += rst.length;
    List<int> peakIdx = [];
    List<double> filteredVal = [];
    for (var element in rst) {
      peakIdx.add(element.toInt());
    }
    filteredVal = newValues;
    return [peakIdx,filteredVal];
  }

  List<double> _movingAverage(List<double> data, int kernelSize) {
    // 이동 평균 결과를 저장할 리스트
    List<double> result = List.filled(data.length, 0.0);

    // 커널 합계를 계산
    double kernelSum = 0.0;
    for (int i = 0; i < kernelSize; i++) {
      kernelSum += 1.0 / kernelSize;
    }

    // 이동 평균 계산
    for (int i = 0; i < data.length; i++) {
      double sum = 0.0;
      int count = 0;
      for (int j = i - (kernelSize - 1) ~/ 2;
          j <= i + (kernelSize - 1) ~/ 2;
          j++) {
        if (j >= 0 && j < data.length) {
          sum += data[j];
          count++;
        }
      }
      result[i] = sum / count;
    }
    return result;
  }

  double _combinedVariance(double variance1, int n1, double variance2, int n2) {
    // 결합된 분산 계산
    double combinedVariance =
        ((n1 - 1) * variance1 + (n2 - 1) * variance2) / (n1 + n2 - 1);

    // 결합된 표준편차 계산
    return sqrt(combinedVariance);
  }
}


void main()
{

}