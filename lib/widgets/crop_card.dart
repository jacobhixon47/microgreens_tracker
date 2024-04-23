import 'package:flutter/material.dart';

class CropCard extends StatelessWidget {
  final String cropId;
  final String cropName;
  final String stage;
  final DateTime stageStart;

  const CropCard({
    super.key,
    required this.cropId,
    required this.cropName,
    required this.stage,
    required this.stageStart,
  });

  Color _getStageColor(String stage) {
    switch (stage) {
      case 'Germinating':
        return Colors.yellow;
      case 'Growing':
        return Colors.green;
      case 'Harvested':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    Duration stageDuration = DateTime.now().difference(stageStart);
    return Card(
      child: ListTile(
        title: Text(cropName),
        subtitle: Text(stage, style: TextStyle(color: _getStageColor(stage))),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Text('Day ${stageDuration.inDays}')],
        ),
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => CropDetailPage(cropId: cropId)));
        },
      ),
    );
  }
}
