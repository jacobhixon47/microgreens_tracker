import 'package:flutter/material.dart';
import '../widgets/crop_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CropsPage extends StatefulWidget {
  const CropsPage({super.key});

  @override
  _CropsPageState createState() => _CropsPageState();
}

class _CropsPageState extends State<CropsPage> {
  late List<CropCard> cropCards =
      []; // This will be filled with CropCard widgets

  @override
  void initState() {
    super.initState();
    fetchCrops();
  }

  void fetchCrops() {
    FirebaseFirestore.instance
        .collection('crops')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((cropSnapshot) {
      List<CropCard> tempCropCards = [];
      for (var cropDoc in cropSnapshot.docs) {
        var cropData = cropDoc.data();
        String cropId = cropDoc.id;
        String cropName =
            cropData['name']; // Assuming crop records store the seed name
        String stage = cropData['stage'];
        DateTime stageStart;

        switch (stage) {
          case 'Germinating':
            stageStart = (cropData['germStart'] as Timestamp).toDate();
            break;
          case 'Growing':
            stageStart = (cropData['growStart'] as Timestamp).toDate();
            break;
          case 'Harvested':
            stageStart = (cropData['harvestDate'] as Timestamp).toDate();
            break;
          default:
            stageStart = DateTime.now();
            break;
        }

        tempCropCards.add(CropCard(
          cropId: cropId,
          cropName: cropName,
          stage: stage,
          stageStart: stageStart,
          onUpdateStage: (newStage) => updateCropStage(cropId, newStage),
        ));
      }
      setState(() {
        cropCards = tempCropCards;
      });
    });
  }

  void updateCropStage(String cropId, String newStage) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DateTime now = DateTime.now();
    Map<String, dynamic> cropUpdates = {
      'stage': newStage,
      newStage == 'Growing' ? 'growStart' : 'harvestDate':
          Timestamp.fromDate(now),
      if (newStage == 'Harvested') 'harvested': true,
    };

    // Start a Firestore transaction for atomic updates
    firestore.runTransaction((transaction) async {
      DocumentReference cropRef = firestore.collection('crops').doc(cropId);
      DocumentSnapshot cropSnap = await transaction.get(cropRef);
      var cropData = cropSnap.data() as Map<String, dynamic>;
      String? seedId = cropData['seedId'];

      if (seedId != null) {
        DocumentReference seedRef = firestore.collection('seeds').doc(seedId);
        DocumentSnapshot seedSnap = await transaction.get(seedRef);
        var seedData = seedSnap.data() as Map<String, dynamic>;

        DateTime stageStartDate = (cropData['germStart'] as Timestamp)
            .toDate(); // Default to germStart

        if (newStage == 'Growing') {
          stageStartDate = (cropData['germStart'] as Timestamp).toDate();
          int daysInGermination = now.difference(stageStartDate).inDays;

          // Update average germination time
          double newAvgGermination = ((seedData['avgGermination'] ?? 0) *
                      (seedData['harvestedCrops'] ?? 0) +
                  daysInGermination) /
              ((seedData['harvestedCrops'] ?? 0) + 1);
          transaction.update(seedRef, {
            'avgGermination': newAvgGermination,
          });

          // Set growStart for growth period calculation
          cropUpdates['growStart'] = Timestamp.fromDate(now);
        }

        if (newStage == 'Harvested' && cropData['stage'] == 'Growing') {
          stageStartDate = (cropData['growStart'] as Timestamp).toDate();
          int daysInGrowth = now.difference(stageStartDate).inDays;
          int totalDaysFromSeed = now
              .difference((cropData['germStart'] as Timestamp).toDate())
              .inDays;

          // Update average growth time
          double newAvgGrowth = ((seedData['avgGrowth'] ?? 0) *
                      (seedData['harvestedCrops'] ?? 0) +
                  daysInGrowth) /
              ((seedData['harvestedCrops'] ?? 0) + 1);

          // Update average seed to harvest time
          double newAvgSeedToHarvest = ((seedData['avgSeedToHarvest'] ?? 0) *
                      (seedData['harvestedCrops'] ?? 0) +
                  totalDaysFromSeed) /
              ((seedData['harvestedCrops'] ?? 0) + 1);

          transaction.update(seedRef, {
            'avgGrowth': newAvgGrowth,
            'avgSeedToHarvest': newAvgSeedToHarvest,
            'harvestedCrops': FieldValue.increment(1)
          });
        }
      }

      // Update the crop document
      transaction.update(cropRef, cropUpdates);
    }).then((result) {
      fetchCrops(); // Re-fetch crops to update the UI
    }).catchError((error) {
      debugPrint("Error updating crop stage: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: cropCards
          .map((card) => CropCard(
                cropId: card.cropId,
                cropName: card.cropName,
                stage: card.stage,
                stageStart: card.stageStart,
                onUpdateStage: (newStage) =>
                    updateCropStage(card.cropId, newStage),
              ))
          .toList(),
    );
  }
}
