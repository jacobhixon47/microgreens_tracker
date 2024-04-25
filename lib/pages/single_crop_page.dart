import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';

class SingleCropPage extends StatefulWidget {
  final String cropId;

  const SingleCropPage({super.key, required this.cropId});

  @override
  _SingleCropPageState createState() => _SingleCropPageState();
}

class _SingleCropPageState extends State<SingleCropPage> {
  Map<String, dynamic>? cropData;

  @override
  void initState() {
    super.initState();
    fetchCropData();
  }

  void fetchCropData() {
    FirebaseFirestore.instance
        .collection('crops')
        .doc(widget.cropId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          cropData = documentSnapshot.data() as Map<String, dynamic>;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cropData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Details',
            style: TextStyle(fontSize: 25, fontStyle: FontStyle.normal),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    // Calculate the days in the current stage based on the stage
    String daysInStage = '';
    DateTime stageStartDate;

    switch (cropData!['stage']) {
      case 'Germinating':
        stageStartDate = (cropData!['germStart'] as Timestamp).toDate();
        break;
      case 'Growing':
        stageStartDate = (cropData!['growStart'] as Timestamp).toDate();
        break;
      case 'Harvested':
        stageStartDate = (cropData!['harvestDate'] as Timestamp).toDate();
        break;
      default:
        stageStartDate =
            DateTime.now(); // Fallback in case none of the stages match
        break;
    }

    daysInStage = "${DateTime.now().difference(stageStartDate).inDays} days";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(fontSize: 25, fontStyle: FontStyle.normal),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: cropData == null
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
                          Text(cropData!['name'],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          buildStatistic("Stage", cropData!['stage']),
                          buildStatistic("Days in Stage", daysInStage),
                          buildStatistic("Seeds", "${cropData!['seedGrams']}g")
                          // Other statistics can be added here
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ... Rest of the build method
                ],
              ),
            ),
    );
  }

  Widget buildStatistic(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  // Widget buildLineChart() {
  //   return Card(
  //     elevation: 4,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: SizedBox(
  //         height: 250, // Match the height from the bar chart for consistency
  //         child: LineChart(
  //           LineChartData(
  //             lineBarsData: [
  //               LineChartBarData(
  //                 spots: [
  //                   FlSpot(
  //                       0,
  //                       cropData!['someValue1']
  //                           .toDouble()), // Replace with actual data point
  //                   FlSpot(
  //                       1,
  //                       cropData!['someValue2']
  //                           .toDouble()), // Replace with actual data point
  //                   FlSpot(
  //                       2,
  //                       cropData!['someValue3']
  //                           .toDouble()), // Replace with actual data point
  //                 ],
  //                 isCurved: true,
  //                 color: Colors.teal,
  //                 barWidth: 4,
  //                 isStrokeCapRound: true,
  //                 dotData: FlDotData(show: false),
  //                 belowBarData: BarAreaData(show: false),
  //               ),
  //             ],
  //             titlesData: FlTitlesData(
  //               bottomTitles: AxisTitles(
  //                 sideTitles: SideTitles(
  //                   showTitles: true,
  //                   reservedSize: 40,
  //                   getTitlesWidget: (double value, TitleMeta meta) {
  //                     final titles = [
  //                       'Stage 1',
  //                       'Stage 2',
  //                       'Stage 3'
  //                     ]; // Replace with actual stage names
  //                     return SideTitleWidget(
  //                       axisSide: meta.axisSide,
  //                       space: 8,
  //                       child: Text(
  //                         titles[value.toInt()],
  //                         style: const TextStyle(
  //                             color: Colors.white, fontSize: 14),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               leftTitles: AxisTitles(
  //                 sideTitles: SideTitles(
  //                   showTitles: true,
  //                   reservedSize: 40,
  //                   getTitlesWidget: (double value, TitleMeta meta) {
  //                     return Text(
  //                       '${value.toInt()} days',
  //                       style:
  //                           const TextStyle(color: Colors.white, fontSize: 14),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ),
  //             gridData: FlGridData(
  //               show: true,
  //               drawVerticalLine: true,
  //               horizontalInterval:
  //                   1, // Set this to a number that suits your data scale
  //               getDrawingHorizontalLine: (value) {
  //                 return FlLine(
  //                   color: Colors.white30,
  //                   strokeWidth: 1,
  //                 );
  //               },
  //             ),
  //             borderData: FlBorderData(show: false),
  //             minX: 0,
  //             maxX: 2, // Set this to your data length - 1
  //             minY: 0,
  //             // Set maxY to the highest value you expect or dynamically based on the data
  //             maxY: cropData!.values
  //                 .fold<double>(0, (max, e) => e > max ? e.toDouble() : max),
  //           ),
  //           // swapAnimationDuration: const Duration(milliseconds: 250),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
