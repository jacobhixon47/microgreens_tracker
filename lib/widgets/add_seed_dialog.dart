import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSeedDialog extends StatefulWidget {
  const AddSeedDialog({Key? key}) : super(key: key);

  @override
  _AddSeedDialogState createState() => _AddSeedDialogState();
}

class _AddSeedDialogState extends State<AddSeedDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> addSeed() async {
    String seedName = _nameController.text;
    double pounds = double.tryParse(_weightController.text) ?? 0;
    int remainingGrams = (pounds * 16 * 28).toInt(); // Convert pounds to grams

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference seeds = firestore.collection('seeds');

    try {
      await seeds.add({
        'name': seedName,
        'remainingGrams': remainingGrams,
        'remainingPounds': pounds.toInt(),
        'activeCrops': 0,
        'harvestedCrops': 0,
        'avgGermination': 0,
        'avgGrowth': 0,
        'avgSeedToHarvest': 0,
        'userId': FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
      });

      Navigator.of(context).pop(); // Dismiss the dialog
    } catch (e) {
      // Handle the error here
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add Seed',
        style: TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: 'Seed Name',
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  focusColor: Colors.white,
                  fillColor: Colors.white),
            ),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Weight in Pounds',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: addSeed,
          child: const Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
