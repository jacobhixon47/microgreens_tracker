import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCropDialog extends StatefulWidget {
  const AddCropDialog({super.key});

  @override
  _AddCropDialogState createState() => _AddCropDialogState();
}

class _AddCropDialogState extends State<AddCropDialog> {
  final TextEditingController _seedGramsController = TextEditingController();
  String? _selectedSeedName; // To store the selected seed name
  DateTime _selectedDate = DateTime.now();
  List<String> _seedNames = []; // List to store seed names from Firestore
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSeedNames();
  }

  @override
  void dispose() {
    _seedGramsController.dispose();
    super.dispose();
  }

  Future<void> _fetchSeedNames() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot seedsSnapshot = await firestore
        .collection('seeds')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    setState(() {
      _seedNames = seedsSnapshot.docs
          .map((doc) => doc['name'] as String)
          .toList(); // Assuming 'name' is a field in your seed documents
      _isLoading = false;
    });
    debugPrint('Seed Names found: $_seedNames');
  }

  Future<void> addCrop() async {
    int gramsUsed = int.tryParse(_seedGramsController.text) ?? 0;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Find the seed document ID and reference based on the selected seed name
    var seedQuerySnapshot = await firestore
        .collection('seeds')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('name', isEqualTo: _selectedSeedName)
        .limit(1)
        .get();
    var seedDocSnapshot = seedQuerySnapshot.docs.first;
    var seedData = seedDocSnapshot.data();
    var seedRef = seedDocSnapshot.reference;
    debugPrint('SEED REF: $seedRef');
    debugPrint('SEED NAME: ${seedData['name']}');

    // Run a transaction to update both the seed and crop at once
    return firestore.runTransaction((transaction) async {
      // Subtract the grams used from the seed's remainingGrams and recalculate remainingPounds
      int newRemainingGrams = (seedData['remainingGrams'] as int) - gramsUsed;
      // Calculate pounds using 28g per ounce and 16 ounces per pound
      double newRemainingPounds =
          double.parse((newRemainingGrams / (28.0 * 16.0)).toStringAsFixed(2));
      // if the new values are negative numbers, set them to 0
      if (newRemainingGrams < 0) {
        newRemainingGrams = 0;
      } else if (newRemainingPounds < 0) {
        newRemainingPounds = 0;
      }
      // Update the seed document within the transaction
      transaction.update(seedRef, {
        'remainingGrams': newRemainingGrams,
        'remainingPounds': newRemainingPounds,
      });
      // Add the new crop document within the transaction
      transaction.set(firestore.collection('crops').doc(), {
        'name': _selectedSeedName,
        'seedId': seedDocSnapshot.id, // Use seed document ID to tie to the crop
        'seedGrams': gramsUsed,
        'germStart': Timestamp.fromDate(_selectedDate),
        'harvested': false,
        'userId': FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
      });
    }).then((result) {
      Navigator.of(context).pop(); // Close the dialog on success
    }).catchError((error) {
      debugPrint('ERROR ADDING CROP: $error');
    });
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Crop'),
      content: SingleChildScrollView(
        // To ensure the dialog is scrollable if content is too long
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (_isLoading)
              const CircularProgressIndicator()
            else
              DropdownButtonFormField<String>(
                value: _selectedSeedName,
                hint: const Text('Select Seed'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSeedName = newValue;
                  });
                },
                items: _seedNames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            const SizedBox(height: 10),
            TextFormField(
                controller: _seedGramsController,
                decoration: const InputDecoration(labelText: 'Seed Grams'),
                keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            ListTile(
              title: Text(
                'Germination Start Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _presentDatePicker,
            ),
            // Include a DropdownButtonFormField if you need the user to select from available seed names
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: addCrop,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
