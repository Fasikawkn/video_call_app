import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_call_app/src/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:video_call_app/src/bloc/form_bloc/form_bloc.dart';
import 'package:video_call_app/src/utils/constants.dart';
import 'package:video_call_app/src/views/screens/home_page.dart';
import 'package:video_call_app/src/views/widgets/auth_components.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

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
                  builder: (context) => const HomePage(),
                ),
                (Route<dynamic> route) => false,);
          }
        }))
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50.0,
              ),
              const Text(
                'Register',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kPrimaryColor)),
                child: const Icon(Icons.add_a_photo),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.04),
              ),
              const NameField(),
              SizedBox(
                height: size.height * 0.03,
              ),
              const EmailField(formFor: Status.signUp),
              SizedBox(
                height: size.height * 0.03,
              ),
              const PasswordField(formFor: Status.signUp),
              SizedBox(
                height: size.height * 0.08,
              ),
              SubmitButton(
                label: 'Sign Up',
                onPressed: () {
                  context
                      .read<FormBloc>()
                      .add(const FormSubmitted(value: Status.signUp));
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              _buildOr(size),
              const SizedBox(
                height: 20.0,
              ),
              _buildGoogleSignupButton(size),
              const SizedBox(
                height: 50.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOr(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            color: Colors.grey,
            width: (size.width * 0.4) - 20,
            height: 1,
          ),
          const Text(
            'or',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20.0,
            ),
          ),
          Container(
            color: Colors.grey,
            width: (size.width * 0.4) - 20,
            height: 1,
          )
        ],
      ),
    );
  }

  Widget _buildGoogleSignupButton(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: () {
          debugPrint('Google signin');
        },
        child: Container(
          height: 50.0,
          width: size.width * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 10.0,),
          decoration: BoxDecoration(
            border: Border.all(color: kPrimaryColor),
            borderRadius: BorderRadius.circular(5.0)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/google_icon.png',
                width: 30,
              ),
              const Text(
                'Sign in with Google',
                style: TextStyle(color: kPrimaryColor, fontSize: 20.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
