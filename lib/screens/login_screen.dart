import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:testing/exceptions/empty_fields_exception.dart';
import 'package:testing/screens/home_screen.dart';
import 'package:testing/screens/signup_screen.dart';
import 'package:testing/screens/welcome_screen.dart';
import 'package:testing/utils/contsants.dart';
import 'package:testing/widgets/custom_button_screen.dart';
import 'package:testing/widgets/custom_text_field.dart';
import 'package:testing/widgets/screen_title.dart';
import 'package:testing/widgets/sign_up_alert.dart';
import 'package:testing/widgets/top_screen_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String id = "login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SharedPreferences prefs;
  bool _saving = false;
  static final url =
      '${dotenv.env['URL'] ?? 'http://localhost:8080'}/api/v1/auth/authenticate';

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return false;
      },
      child: Scaffold(
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
                              controller: usernameController,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                  hintText: 'Username')),
                        ),
                        CustomTextField(
                          textField: TextField(
                            obscureText: true,
                            controller: passwordController,
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
                            login();
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

  void login() async {
    Dio dio = Dio();

    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.connectTimeout = const Duration(seconds: 10);

    try {
      if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
        throw EmptyFieldException('All required fields should be provided');
      }

      Response response = await dio.post(url,
          data: FormData.fromMap({
            'username': usernameController.text,
            'password': passwordController.text
          }));

      prefs.setString('access_token', response.data['access_token']);

      setState(() {
        _saving = false;
        Navigator.pushNamed(context, WelcomeScreen.id);
      });
    } catch (e) {
      if (context.mounted) {
        setState(() {
          _saving = false;
        });

        if (e is EmptyFieldException) {
          showCustomDialog(context, 'Blank fields', e.message, 'Try again');
        } else if (e is DioException) {
          if (e.type == DioExceptionType.badResponse) {
            showCustomDialog(context, 'Bad request',
                e.response?.data['message'], 'Try again');
          } else {
            showCustomDialog(context, 'Internal Server Error',
                e.message ?? 'Server is not responding', 'Try again');
          }
        }
      }
    }
  }
}
