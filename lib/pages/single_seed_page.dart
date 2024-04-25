import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class SingleSeedPage extends StatefulWidget {
  final String seedId;

  const SingleSeedPage({super.key, required this.seedId});

  @override
  _SingleSeedPageState createState() => _SingleSeedPageState();
}

class _SingleSeedPageState extends State<SingleSeedPage> {
  Map<String, dynamic>? seedData;

  @override
  void initState() {
    super.initState();
    fetchSeedData();
  }

  void fetchSeedData() {
    FirebaseFirestore.instance
        .collection('seeds')
        .doc(widget.seedId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          seedData = documentSnapshot.data() as Map<String, dynamic>;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(fontSize: 25, fontStyle: FontStyle.normal),
        ),
        backgroundColor: Colors.black38,
      ),
      body: seedData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${seedData!['name']}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          buildStatistic("Remaining Pounds",
                              "${seedData!['remainingPounds']} lbs"),
                          buildStatistic(
                              "Active Crops", "${seedData!['activeCrops']}"),
                          buildStatistic("Harvested Crops",
                              "${seedData!['harvestedCrops']}"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildBarChart(),
                  const SizedBox(height: 20),
                  buildPieChart()
                ],
              ),
            ),
    );
  }

  Widget buildStatistic(String label, String value) {
    return Row(
      children: [
        Expanded(
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500))),
        Text(value),
      ],
    );
  }

  Widget buildBarChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Average Days per Stage'),
            const SizedBox(height: 10),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: false,
                  ),
                  titlesData: FlTitlesData(
                    // X Axis titles (Bottom)
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40, // Adjust this as needed for label fit
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final titles = ['Germinate', 'Grow', 'Harvest'];
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 16, // Adjust space if necessary
                            child: Text(titles[value.toInt()],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          );
                        },
                      ),
                    ),
                    // Y Axis titles (Left)
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40, // Adjust this as needed for label fit
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text('${value.toInt()}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14));
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData:
                      const FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          width: 30,
                          borderRadius: BorderRadius.zero,
                          toY: seedData!['avgGermination'].toDouble(),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          width: 30,
                          borderRadius: BorderRadius.zero,
                          toY: seedData!['avgGrowth'].toDouble(),
                          color: Colors.green,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          width: 30,
                          borderRadius: BorderRadius.zero,
                          toY: seedData!['avgSeedToHarvest'].toDouble(),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
                swapAnimationDuration: const Duration(milliseconds: 250),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPieChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Crops Distribution'),
            const SizedBox(height: 10),
            SizedBox(
              height: 190, // Adjust the size as needed
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 45,
                  startDegreeOffset: -90,
                  sections: [
                    PieChartSectionData(
                      color: Colors.green,
                      value: seedData!['activeCrops'] != 0
                          ? seedData!['activeCrops'].toDouble()
                          : 2,
                      title: 'Active',
                      showTitle: true,
                      radius: 50,
                    ),
                    PieChartSectionData(
                      color: Colors.blue,
                      value: seedData!['harvestedCrops'] != 0
                          ? seedData!['harvestedCrops'].toDouble()
                          : 1,
                      title: 'Harvested',
                      showTitle: true,
                      radius: 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
