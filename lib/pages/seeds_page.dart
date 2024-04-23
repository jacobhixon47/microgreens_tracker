import 'package:flutter/material.dart';
import '../widgets/seed_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeedsPage extends StatefulWidget {
  @override
  _SeedsPageState createState() => _SeedsPageState();
}

class _SeedsPageState extends State<SeedsPage> {
  late List<SeedCard> seedCards =
      []; // This will be filled with SeedCard widgets

  @override
  void initState() {
    super.initState();
    fetchSeeds();
  }

  void fetchSeeds() {
    FirebaseFirestore.instance
        .collection('seeds')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((seedSnapshot) async {
      List<SeedCard> tempSeedCards = [];
      for (var seedDoc in seedSnapshot.docs) {
        var seedData = seedDoc.data();
        String seedId = seedDoc.id;
        String seedName = seedData['name'];
        double remainingPounds =
            (seedData['remainingPounds'] as num).toDouble();
        int activeCropsCount = seedData['activeCrops'];
        int harvestedCropsCount = seedData['harvestedCrops'];

        tempSeedCards.add(SeedCard(
          seedId: seedId,
          seedName: seedName,
          remainingPounds: remainingPounds,
          activeCropsCount: activeCropsCount,
          harvestedCropsCount: harvestedCropsCount,
        ));
      }
      setState(() {
        seedCards = tempSeedCards;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: seedCards,
    );
  }
}
