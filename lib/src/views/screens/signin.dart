import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_call_app/src/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:video_call_app/src/bloc/form_bloc/form_bloc.dart';
import 'package:video_call_app/src/utils/constants.dart';
import 'package:video_call_app/src/views/screens/home_page.dart';
import 'package:video_call_app/src/views/screens/signup.dart';
import 'package:video_call_app/src/views/widgets/auth_components.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MultiBlocListener(
      listeners: [
        BlocListener<FormBloc, FormsValidate>(
          listener: ((context, state) {
            if (state.errorMessage.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(errorMessage: state.errorMessage),
              );
            } else if (state.isFormValid && state.isLoading) {
              debugPrint('+++++++++++++++++++++++++++++++++++> Authenticating');
              context.read<AuthenticationBloc>().add(AuthenticateStarted());
              context.read<FormBloc>().add(const FormSucceeded());
            } else if (state.isFormValidateFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter valid values')));
            }
          }),
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: ((context, state) {
          if (state is AuthenticationSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>  HomePage(
                    loggedInUser: state.user!,
                  ),
                ),
                (Route<dynamic> route) => false);
          }
        }))
      ],
      child: Scaffold(
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
              const Text(
                'Log In',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.04),
              ),
              const EmailField(
                formFor: Status.signIn,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              const PasswordField(
                formFor: Status.signIn,
              ),
              SizedBox(
                height: size.height * 0.08,
              ),
              SubmitButton(
                label: "Log In",
                onPressed: () {
                  context.read<FormBloc>().add(
                        const FormSubmitted(value: Status.signIn),
                      );
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              RichText(
                  text: TextSpan(children: [
                const TextSpan(
                  text: "Don't have account?  ",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                    text: "Sign Up",
                    style: const TextStyle(
                      color: kPrimaryColor,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()),
                            (route) => false);
                      })
              ])),
            ],
          ),
        ),
      ),
    );
  }
}
