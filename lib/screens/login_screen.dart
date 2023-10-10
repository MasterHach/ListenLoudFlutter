import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:testing/screens/home_screen.dart';
import 'package:testing/screens/signup_screen.dart';
import 'package:testing/screens/welcome_screen.dart';
import 'package:testing/utils/contsants.dart';
import 'package:testing/widgets/custom_button_screen.dart';
import 'package:testing/widgets/custom_text_field.dart';
import 'package:testing/widgets/screen_title.dart';
import 'package:testing/widgets/sign_up_alert.dart';
import 'package:testing/widgets/top_screen_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String id = "login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _username;
  late String _password;
  bool _saving = false;
  static final url =
      Uri.parse('${dotenv.env['URL'] ?? 'http://localhost:8080'}/api/v1/auth/authenticate');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const TopScreenImage(screenImageName: 'pop.png'),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const ScreenTitle(title: 'Login'),
                        CustomTextField(
                          textField: TextField(
                              onChanged: (value) {
                                _username = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                  hintText: 'Username')),
                        ),
                        CustomTextField(
                          textField: TextField(
                            obscureText: true,
                            onChanged: (value) {
                              _password = value;
                            },
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            decoration: kTextInputDecoration.copyWith(
                                hintText: 'Password'),
                          ),
                        ),
                        CustomBottomScreen(
                          textButton: 'Login',
                          heroTag: 'login_btn',
                          question: 'No account?',
                          buttonPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              _saving = true;
                            });
                            try {
                              final String rawJson =
                                  '{"username": "$_username","password": "$_password"}';

                              final response = await http.post(
                                url,
                                headers: {"Content-Type": "application/json"},
                                body: rawJson,
                              );

                              if (response.statusCode != 200) {
                                throw Exception();
                              }

                              if (context.mounted) {
                                setState(() {
                                  _saving = false;
                                  Navigator.popAndPushNamed(
                                      context, LoginScreen.id);
                                });
                                Navigator.pushNamed(context, WelcomeScreen.id);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                setState(() {
                                  _saving = false;
                                  showCustomDialog(
                                    context,
                                    'Wrong credentials',
                                    'Confirm your username and password and try again',
                                    'Try again',
                                  );
                                });
                              }
                            }
                          },
                          questionPressed: () {
                            Navigator.pushNamed(context, SignUpScreen.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
