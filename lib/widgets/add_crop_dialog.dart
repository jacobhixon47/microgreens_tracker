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
  final TextEditingController _nameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _seedGramsController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> addCrop() async {
    int gramsUsed = int.tryParse(_seedGramsController.text) ?? 0;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference crops = firestore.collection('crops');

    // Add a new crop record to Firestore
    try {
      await crops.add({
        'name': _nameController
            .text, // The name entered or selected from the dropdown
        'seedGrams': gramsUsed,
        'germStart': Timestamp.fromDate(_selectedDate),
        'harvested': false,
        'userId': FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
      });
      Navigator.of(context).pop(); // Close the dialog
    } catch (e) {
      // Handle the error here, e.g., show a Snackbar
    }
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
            TextFormField(
              controller: _seedGramsController,
              decoration: const InputDecoration(labelText: 'Seed Grams'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Crop Name'),
            ),
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
