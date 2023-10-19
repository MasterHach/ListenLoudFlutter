import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:testing/exceptions/empty_fields_exception.dart';
import 'package:testing/exceptions/password_validation_exception.dart';
import 'package:testing/exceptions/username_validation_exception.dart';
import 'package:testing/screens/home_screen.dart';
import 'package:testing/screens/login_screen.dart';
import 'package:testing/utils/contsants.dart';
import 'package:testing/widgets/custom_button_screen.dart';
import 'package:testing/widgets/custom_text_field.dart';
import 'package:testing/widgets/screen_title.dart';
import 'package:testing/widgets/sign_up_alert.dart';
import 'package:testing/widgets/top_screen_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String id = 'signup_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _saving = false;
  static final url =
      '${dotenv.env['URL'] ?? 'http://localhost:8080'}/api/v1/auth/register';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return true;
      },
      child: Scaffold(
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
                            controller: usernameController,
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
                            controller: passwordController,
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
                            register();
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

  void register() async {
    Dio dio = Dio();

    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.connectTimeout = const Duration(seconds: 10);

    try {
      if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
        throw EmptyFieldException('All required fields should be provided');
      }

      if (!usernameController.text.contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
        throw UsernameValidationException(
            'Username contains only letters and numbers');
      }

      if (passwordController.text.length < 8) {
        throw PasswordValidationException('Password is too short');
      }

      if (!passwordController.text
          .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        throw PasswordValidationException(
            'Password should have at least one special character');
      }

      if (!passwordController.text.contains(RegExp(r'[0-9]'))) {
        throw PasswordValidationException(
            'Password should have at least one digit');
      }

      await dio.post(url,
          data: FormData.fromMap({
            'username': usernameController.text,
            'password': passwordController.text
          }));

      setState(() {
        _saving = false;
        Navigator.pushNamed(context, LoginScreen.id);
      });
    } catch (e) {
      if (context.mounted) {
        setState(() {
          _saving = false;
        });

        if (e is EmptyFieldException) {
          showCustomDialog(context, 'Blank fields', e.message, 'Try again');
        } else if (e is UsernameValidationException) {
          showCustomDialog(
              context, 'Username is not valid', e.message, 'Try again');
        } else if (e is PasswordValidationException) {
          showCustomDialog(
              context, 'Password is not valid', e.message, 'Try again');
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
