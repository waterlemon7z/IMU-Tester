import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:imu_tester/entity/entity_chart_data.dart';
import 'package:imu_tester/provider/provider_sensor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RealTimeChart extends StatefulWidget {
  const RealTimeChart(
      {super.key,
      required this.provider,
      required this.axis,
      required this.sensorMode});

  final SensorProvider provider;
  final String axis;
  final String sensorMode;

  @override
  State<RealTimeChart> createState() => _RealTimeChartState();
}

class _RealTimeChartState extends State<RealTimeChart> {
  _RealTimeChartState() {
    for (int i = 0; i < 20; i++) {
      _chartData.add(ChartDataEntity(x: _count++, y: 0));
    }
    timer =
        Timer.periodic(const Duration(milliseconds: 100), _updateDataSource);
  }

  Timer? timer;
  final int _maxCount = 50;
  int _count = 0;
  final List<ChartDataEntity> _chartData =
      List<ChartDataEntity>.empty(growable: true);
  ChartSeriesController<ChartDataEntity, int>? _chartSeriesController;

  @override
  void dispose() {
    timer?.cancel();
    _chartData.clear();
    _chartSeriesController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLiveLineChart();
  }

  /// Returns the realtime Cartesian line chart.
  SfCartesianChart _buildLiveLineChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis:
            const NumericAxis(majorGridLines: MajorGridLines(width: 0)),
        primaryYAxis: const NumericAxis(
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(size: 0)),
        series: <LineSeries<ChartDataEntity, int>>[
          LineSeries<ChartDataEntity, int>(
            onRendererCreated:
                (ChartSeriesController<ChartDataEntity, int> controller) {
              _chartSeriesController = controller;
            },
            dataSource: _chartData,
            color: const Color.fromRGBO(192, 108, 132, 1),
            xValueMapper: (ChartDataEntity entity, _) => entity.x,
            yValueMapper: (ChartDataEntity entity, _) => entity.y,
            animationDuration: 0,
          )
        ]);
  }

  void _updateDataSource(Timer timer) {
    // if(widget.provider.flChartData["${widget.sensorMode}${widget.axis}"] == null || widget.provider.flChartData["${widget.sensorMode}${widget.axis}"]
    //     ?.last.y == null) {
    //   return;
    // }
    _chartData.add(ChartDataEntity(
        x: _count,
        y: widget.provider.flChartData["${widget.sensorMode}${widget.axis}"]
                ?.last.y ??
            0));
    if (_chartData.length >= _maxCount) {
      _chartData.removeAt(0);
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[_chartData.length - 1],
        removedDataIndexes: <int>[0],
      );
    } else {
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[_chartData.length - 1],
      );
    }
    _count += 1;
  }
}
