import 'package:flutter/material.dart';
import '../pages/single_crop_page.dart';

class CropCard extends StatelessWidget {
  final String cropId;
  final String cropName;
  final String stage;
  final DateTime stageStart;
  final Function(String) onUpdateStage;

  const CropCard({
    super.key,
    required this.cropId,
    required this.cropName,
    required this.stage,
    required this.stageStart,
    required this.onUpdateStage,
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

  void _showStageUpdateMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            if (stage == 'Germinating')
              ListTile(
                leading: const Icon(Icons.arrow_upward),
                title: const Text('Start Grow Stage'),
                onTap: () {
                  Navigator.pop(context);
                  onUpdateStage('Growing');
                },
              ),
            if (stage == 'Growing')
              ListTile(
                leading: const Icon(Icons.check),
                title: const Text('Harvest'),
                onTap: () {
                  Navigator.pop(context);
                  onUpdateStage('Harvested');
                },
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Duration stageDuration = DateTime.now().difference(stageStart);

    return Card(
      child: ListTile(
        title: Text(cropName),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(stage, style: TextStyle(color: _getStageColor(stage))),
            Text('${stageDuration.inDays} day(s)')
          ],
        ),
        trailing: stage != 'Harvested'
            ? IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showStageUpdateMenu(context),
              )
            : const SizedBox.shrink(),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleCropPage(cropId: cropId),
            ),
          );
        },
      ),
    );
  }
}
