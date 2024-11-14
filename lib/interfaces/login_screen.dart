import 'package:flutter/material.dart';
import 'package:cafetariat/models/themes.dart';
import 'package:cafetariat/Services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Attempt to sign in with provided credentials
    var user = await _authService.signInWithEmailAndPassword(email, password);
    
    if (user != null) {
      // Check if the email is verified
      if (user.emailVerified) {
        // Navigate to the main screen if verified
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // Prompt user to verify email if not verified
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please verify your email to continue.")),
        );
        await _authService.sendEmailVerification();
      }
    } else {
      // Show error if sign-in fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed. Please check your credentials.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Text('Login', style: headingTextStyle),
            SizedBox(height: 8),
            Text('Please sign in to continue.', style: subheadingTextStyle),
            SizedBox(height: 40),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: inputTextStyle,
                prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: inputTextStyle,
                prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                suffixText: 'FORGOT',
                suffixStyle: TextStyle(color: primaryColor),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _login(context), // Call _login function
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Center(
                child: Text('LOGIN', style: buttonTextStyle),
              ),
            ),
            Spacer(),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?", style: subheadingTextStyle),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text('Sign up', style: TextStyle(color: primaryColor)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}