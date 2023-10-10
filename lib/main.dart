import 'package:flutter/material.dart';
import 'package:testing/screens/home_screen.dart';
import 'package:testing/screens/login_screen.dart';
import 'package:testing/screens/signup_screen.dart';
import 'package:testing/screens/welcome_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontFamily: 'Roboto',
        ),
      )),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        WelcomeScreen.id: (context) => const WelcomeScreen()
      },
    );
  }
}
