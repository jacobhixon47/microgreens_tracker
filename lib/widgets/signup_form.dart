import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _name = '';

  final TextEditingController _pass = TextEditingController();
  // final TextEditingController _confirmPass = TextEditingController();

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      debugPrint('Attempting to sign up with email: $_email');
      try {
        // Use Firebase Authentication to register with email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        User? user = userCredential.user;

        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({'uid': user.uid, 'email': _email, 'name': _name});
        }
        // You may want to verify the email or log the user in directly
        debugPrint('User registered successfully');
      } catch (e) {
        // Handle errors or display an error message
        debugPrint('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) =>
                value!.isEmpty || !value.contains('@') || !value.contains('.')
                    ? 'Enter a valid email'
                    : null,
            onSaved: (value) => _email = value!.trim(),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) => value!.isEmpty ? 'Enter your name' : null,
            onSaved: (value) => _name = value!,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _pass,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) => value!.isEmpty || value.length < 6
                ? 'Password must be at least 6 characters long'
                : null,
            onSaved: (value) => _password = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
            validator: (value) =>
                value != _pass.text ? 'Passwords must match' : null,
            onSaved: (value) => _password = value!,
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _signUp();
              }
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
