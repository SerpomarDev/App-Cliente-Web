import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart' as pie_chart;
import 'package:serpomar_client/src/pages/looker/looker_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LookerPage extends StatelessWidget {
  final LookerController con = Get.put(LookerController());
  final Rx<DateTimeRange> selectedDateRange = Rx<DateTimeRange>(
    DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 7)),
      end: DateTime.now(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    con.isActive.value = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DASHBOARD',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blueAccent),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () async {
              DateTimeRange? newRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2025),
                initialDateRange: selectedDateRange.value,
              );
              if (newRange != null) {
                selectedDateRange.value = newRange;
                con.updateContainerCounts(newRange);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              con.updateData();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              constraints: BoxConstraints(maxWidth: 1200),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTotalContainersWidget(),
                  SizedBox(height: 22),
                  _buildChartTitle('Cantidad de solicitudes por categoría'),
                  _buildProductPieChart(context),
                  SizedBox(height: 20),
                  Obx(() {
                    if (con.isLoading.isTrue) {
                      return const CircularProgressIndicator();
                    }
                    if (con.requestsByDay.isNotEmpty) {
                      return Column(
                        children: [
                          _buildChartTitle('Histórico de solicitudes'),
                          _buildBarChart(),
                        ],
                      );
                    } else {
                      return const Text('Cargando información.');
                    }
                  }),
                  SizedBox(height: 8),
                  _buildChartTitle('Cantidad de contenedores por categoría'),
                  _buildContainersChart(context),
                  SizedBox(height: 20),
                  _buildChartTitle('Cantidad de vehículos en destino'),
                  _buildDestinationPieChart(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartTitle(String title) {
    return Container(
        margin: EdgeInsets.only(bottom: 8),
    child: Text(
    title,
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.blueAccent,
    letterSpacing: 1.1,
    ),
      textAlign: TextAlign.center,
    ),
    );
  }

  Widget _buildTotalContainersWidget() {
    return Obx(() {
      print("Building Total Containers Widget with value: ${con.totalNumContainers.value}");
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade300, Colors.blue.shade600],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storage, color: Colors.white, size: 24),
            SizedBox(width: 10),
            TweenAnimationBuilder(
              tween: IntTween(begin: 0, end: con.totalNumContainers.value),
              duration: Duration(seconds: 3),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Programa de cargue diario: ",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      TextSpan(
                        text: "$value",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildProductPieChart(BuildContext context) {
    return Obx(() {
      Map<String, String> categoryNames = {
        '1': 'Importaciones',
        '2': 'Exportaciones',
        '3': 'Retiros de Vacíos',
        '4': 'Traslados',
      };

      var dataMap = categoryNames.map((key, name) {
        final count = con.categoryCounts.value[key] ?? 0;
        return MapEntry(name + " ($count)", count.toDouble());
      });

      if (dataMap.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      List<Color> colorList = [
        Colors.blue.shade200,
        Colors.blue.shade500,
        Colors.blue.shade700,
        Colors.blue.shade900,
      ];

      return Container(
        height: 300,
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade300, Colors.blue.shade600],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: pie_chart.PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 2.5,
          colorList: colorList,
          initialAngleInDegree: 0,
          chartType: pie_chart.ChartType.ring,
          ringStrokeWidth: 35,
          baseChartColor: Colors.transparent.withOpacity(0.15),
          legendOptions: pie_chart.LegendOptions(
            showLegends: true,
            legendPosition: pie_chart.LegendPosition.right,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          chartValuesOptions: pie_chart.ChartValuesOptions(
            showChartValueBackground: false,
            showChartValues: true,
            showChartValuesInPercentage: true,
            chartValueStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBarChart() {
    if (con.requestsByDay.isEmpty) {
      return CircularProgressIndicator();
    }

    List<BarChartGroupData> barGroups = [];
    int index = 0;

    for (var entry in con.requestsByDay.entries) {
      final date = entry.key;
      final count = entry.value;
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: Colors.blue.shade800,
              width: 16,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 15, // Ajustar el máximo de fondo a 15
                color: Colors.blue.shade100,
              ),
            ),
          ],
        ),
      );
      index++;
    }

    double chartWidth = barGroups.length * 90.5;

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
        width: chartWidth,
        padding: const EdgeInsets.all(16.0),
    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 16.0),
    decoration: BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.blue.shade300, Colors.blue.shade600],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 2,
      blurRadius: 5,
      offset: Offset(0, 3),
    ),
    ],
    ),
          height: 300,
          child: BarChart(
            BarChartData(
              maxY: 15, // Establecer el máximo en 15
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 1, // Intervalo para mostrar cada número
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int intValue = value.toInt();
                      if (intValue >= 0 && intValue < con.requestsByDay.length) {
                        final date = con.requestsByDay.keys.elementAt(intValue);
                        final formattedDate = DateFormat('dd/MM').format(DateTime.parse(date));
                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return Text('');
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: barGroups,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                drawHorizontalLine: true,
                horizontalInterval: 1, // Intervalo horizontal ajustado para mostrar cada número
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.white24,
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.white24,
                    strokeWidth: 1,
                  );
                },
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildContainersChart(BuildContext context) {
    return Obx(() {
      Map<String, String> categoryNames = {
        '1': 'Importaciones',
        '2': 'Exportaciones',
        '3': 'Retiros de Vacíos',
        '4': 'Traslados',
      };

      var data = categoryNames.entries.map((entry) {
        final count = con.containerCounts.value[entry.key] ?? 0;
        return ChartData(entry.value, count);
      }).toList();

      if (data.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      return Container(
        height: 300,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade300, Colors.blue.shade600],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Contenedores',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  axisLine: AxisLine(width: 0),
                  labelStyle: TextStyle(color: Colors.white),
                  majorTickLines: MajorTickLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  axisLine: AxisLine(width: 0),
                  labelStyle: TextStyle(color: Colors.white),
                  majorGridLines: MajorGridLines(color: Colors.white.withOpacity(0.2)),
                  majorTickLines: MajorTickLines(width: 0),
                ),
                series: <CartesianSeries>[
                  BarSeries<ChartData, String>(
                    dataSource: data,
                    xValueMapper: (ChartData data, _) => data.category,
                    yValueMapper: (ChartData data, _) => data.count.toDouble(),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDestinationPieChart(BuildContext context) {
    return Obx(() {
      if (con.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (con.destinationCounts.isEmpty) {
        return Container(
          height: 300,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade300, Colors.blue.shade600],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: pie_chart.PieChart(
            dataMap: {'0 Datos para Ver': 1.0},
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width / 2.5,
            colorList: [Colors.grey],
            initialAngleInDegree: 0,
            chartType: pie_chart.ChartType.ring,
            ringStrokeWidth: 35,
            baseChartColor: Colors.transparent.withOpacity(0.15),
            legendOptions: pie_chart.LegendOptions(
              showLegends: true,
              legendPosition: pie_chart.LegendPosition.right,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            chartValuesOptions: pie_chart.ChartValuesOptions(
              showChartValueBackground: false,
              showChartValues: false,
            ),
          ),
        );
      }

      var dataMap = con.destinationCounts.map((key, value) {
        String label;
        switch (key) {
          case 1:
            label = 'Por salir';
            break;
          case 2:
            label = 'En planta';
            break;
          case 3:
            label = 'En puerto';
            break;
          default:
            label = 'Destino $key';
            break;
        }
        return MapEntry('$label: $value', value.toDouble());
      });

      List<Color> colorList = [
        Colors.blue.shade200,
        Colors.blue.shade500,
        Colors.blue.shade700,
        Colors.blue.shade900,
      ];

      return Container(
        height: 300,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade300, Colors.blue.shade600],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: pie_chart.PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 2.5,
          colorList: colorList,
          initialAngleInDegree: 0,
          chartType: pie_chart.ChartType.ring,
          ringStrokeWidth: 35,
          baseChartColor: Colors.transparent.withOpacity(0.15),
          legendOptions: pie_chart.LegendOptions(
            showLegends: true,
            legendPosition: pie_chart.LegendPosition.right,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          chartValuesOptions: pie_chart.ChartValuesOptions(
            showChartValueBackground: false,
            showChartValues: true,
            showChartValuesInPercentage: true,
            chartValueStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }
}

class ChartData {
  final String category;
  final int count;

  ChartData(this.category, this.count);
}
