import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:testing/screens/home_screen.dart';
import 'package:testing/screens/login_screen.dart';
import 'package:testing/utils/contsants.dart';
import 'package:testing/widgets/custom_button_screen.dart';
import 'package:testing/widgets/custom_text_field.dart';
import 'package:testing/widgets/screen_title.dart';
import 'package:testing/widgets/sign_up_alert.dart';
import 'package:testing/widgets/top_screen_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String id = 'signup_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late String _username;
  late String _password;
  static final url = Uri.parse('${dotenv.env['URL'] ?? 'http://localhost:8080'}/api/v1/auth/register');
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TopScreenImage(screenImageName: 'pop.png'),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const ScreenTitle(title: 'Sign Up'),
                        CustomTextField(
                          textField: TextField(
                            onChanged: (value) {
                              _username = value;
                            },
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            decoration: kTextInputDecoration.copyWith(
                              hintText: 'Username',
                            ),
                          ),
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
                              hintText: 'Password',
                            ),
                          ),
                        ),
                        CustomBottomScreen(
                          textButton: 'Sign Up',
                          heroTag: 'signup_btn',
                          question: 'Have account?',
                          buttonPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              _saving = true;
                            });
                            try {
                              final String rawJson =
                                  '{"username": "$_username","password": "$_password"},"image": "image"';

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
                                  showCustomDialog(
                                    context,
                                    'Success',
                                    'Go login now',
                                    'Login',
                                  );
                                });
                                Navigator.pushNamed(context, LoginScreen.id);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                setState(() {
                                  _saving = false;
                                  showCustomDialog(
                                    context,
                                    'Something went wrong',
                                    'Close app and try again later',
                                    'Try again',
                                  );
                                });
                              }
                            }
                          },
                          questionPressed: () async {
                            Navigator.pushNamed(context, LoginScreen.id);
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
