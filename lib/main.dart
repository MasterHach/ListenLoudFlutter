import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/screens/home_screen.dart';
import 'package:testing/screens/login_screen.dart';
import 'package:testing/screens/signup_screen.dart';
import 'package:testing/screens/welcome_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');
  runApp(MyApp(token: token,));
}

class MyApp extends StatelessWidget {

  final String? token;

  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontFamily: 'Montserrat',
        ),
      )),
      initialRoute: (token != null && !JwtDecoder.isExpired(token!)) ? WelcomeScreen.id : HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        WelcomeScreen.id: (context) => const WelcomeScreen(),
      },
    );
  }
}
