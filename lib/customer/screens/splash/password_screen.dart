import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/customer/screens/splash/splash_screen.dart';
import 'package:shop_app/helper/custom_snackbar.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController _passwordController = TextEditingController();
  String _savedPassword = 'rudi393'; // Set the password here
  bool _isAuthenticated = false;

  void _authenticate() {
    String enteredPassword = _passwordController.text;

    if (enteredPassword == _savedPassword) {
      setState(() {
        _isAuthenticated = true;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SplashScreen(),
        ),
      );
    } else {
      CustomSnackBar.failedSnackBar(
          context: context, message: "Incorrect password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please enter your password',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text('Authenticate'),
            ),
          ],
        ),
      ),
    );
  }
}
