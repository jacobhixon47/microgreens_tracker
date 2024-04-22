import 'package:flutter/material.dart';
import '../widgets/login_form.dart';
import '../widgets/signup_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLogin = true;

  void toggleForm() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(showLogin ? 'Log In' : 'Sign Up',
              style:
                  const TextStyle(fontSize: 35, fontWeight: FontWeight.w600)),
          Expanded(
            child: Center(
              child: showLogin ? const LoginForm() : const SignUpForm(),
            ),
          ),
          const SizedBox(height: 100),
          TextButton(
            onPressed: toggleForm,
            child: Text(showLogin ? 'Sign Up' : 'Log In',
                style: const TextStyle(color: Colors.purple)),
          )
        ],
      ),
    );
  }
}
