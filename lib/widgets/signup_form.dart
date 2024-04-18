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

  void _signUp() async {
    try {
      // Use Firebase Authentication to register with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) => value!.isEmpty || !value.contains('@')
                ? 'Enter a valid email'
                : null,
            onSaved: (value) => _email = value!,
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) => value!.isEmpty || value.length < 6
                ? 'Password must be at least 6 characters long'
                : null,
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
