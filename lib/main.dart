import 'package:cafetariat/firebase_options.dart';
import 'package:cafetariat/widgets/dashboard_widget.dart';
import 'package:cafetariat/interfaces/login_screen.dart';
import 'package:cafetariat/interfaces/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cafetariat/interfaces/splash_screen.dart';

Future <void> main() async {
  // Ensure Firebase is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafe Eden',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      initialRoute: '/dashboard', // Set initial route to login screen
      routes: {
        '/home': (context) => const SplashScreen(),
        '/dashboard': (context) => const DashboardWidget(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen()},
      // Start the app with SplashScreen
    );
  }
}
