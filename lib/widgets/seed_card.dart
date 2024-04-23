import 'package:flutter/material.dart';

class SeedCard extends StatelessWidget {
  final String seedId;
  final String seedName;
  final double remainingPounds;
  final int activeCropsCount;
  final int harvestedCropsCount;

  const SeedCard({
    super.key,
    required this.seedId,
    required this.seedName,
    required this.remainingPounds,
    required this.activeCropsCount,
    required this.harvestedCropsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(seedName),
        subtitle: Text('Remaining: $remainingPounds lbs'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Active Crops: $activeCropsCount'),
            Text('Harvested: $harvestedCropsCount'),
          ],
        ),
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => SeedDetailPage(seedId: seedId)));
        },
      ),
    );
  }
}
