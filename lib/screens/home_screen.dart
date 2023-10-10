import 'package:flutter/material.dart';
import 'package:testing/screens/login_screen.dart';
import 'package:testing/screens/signup_screen.dart';
import 'package:testing/widgets/custom_button.dart';
import 'package:testing/widgets/screen_title.dart';
import 'package:testing/widgets/top_screen_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopScreenImage(screenImageName: 'pop.png'),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(
                        right: 15.0, left: 15.0, bottom: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const ScreenTitle(title: 'LISTENLOUD'),
                        const Text(
                          'Welcome to ListenLoud, where you can listen to music',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Hero(
                            tag: 'login_btn',
                            child: CustomButton(
                                buttonText: 'Login',
                                onPressed: () {
                                  Navigator.pushNamed(context, LoginScreen.id);
                                })),
                        const SizedBox(
                          height: 10,
                        ),
                        Hero(
                            tag: 'signup_btn',
                            child: CustomButton(
                                buttonText: 'Sign Up',
                                isOutlined: true,
                                onPressed: () {
                                  Navigator.pushNamed(context, SignUpScreen.id);
                                })),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
