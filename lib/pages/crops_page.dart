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
        ));
      }
      setState(() {
        cropCards = tempCropCards;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: cropCards,
    );
  }
}
