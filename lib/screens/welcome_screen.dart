import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/widgets/screen_title.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static String id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late SharedPreferences prefs;
  String username = 'Initialization...';
  static final url =
      '${dotenv.env['URL'] ?? 'http://localhost:8080'}/api/v1/users';

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    Dio dio = Dio();

    prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');

    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers['Authorization'] = 'Bearer $token';

    Response response = await dio.get(url);

    username = response.data['username'];

    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: Center(
          child: ScreenTitle(
            title: 'Welcome, $username!',
          ),
        ),
      ),
    );
  }
}
