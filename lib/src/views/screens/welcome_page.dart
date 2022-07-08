import 'package:flutter/material.dart';
import 'package:video_call_app/src/utils/constants.dart';
import 'package:video_call_app/src/views/screens/signin.dart';
import 'package:video_call_app/src/views/screens/signup.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: const DecorationImage(
                    image: AssetImage(
                      'assets/images/video_call_image.webp',
                    ),
                    fit: BoxFit.fill),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Feel free to connect to your loved ones anywhere across the world!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const SignIn()),
                            (route) => false);
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: kPrimaryColor, width: 2.0),
                          borderRadius: BorderRadius.circular(
                            5.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()),
                            (route) => false);
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
