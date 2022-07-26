import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_call_app/src/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:video_call_app/src/bloc/form_bloc/form_bloc.dart';
import 'package:video_call_app/src/utils/constants.dart';
import 'package:video_call_app/src/views/screens/home_page.dart';
import 'package:video_call_app/src/views/screens/signin.dart';
import 'package:video_call_app/src/views/widgets/auth_components.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  File? _profileImage;

  _pickProfileImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final _imageSource = await showDialog(
        context: context, builder: (context) => _pickedSelection());
    debugPrint('The result is $_imageSource');
    final XFile? _pickedImage = await _picker.pickImage(source: _imageSource);

    if (_pickedImage == null) {
      return null;
    } else {
      context.read<FormBloc>().add(ProfilePictureChanged(_pickedImage.path));
      setState(() {
        
        _profileImage = File(_pickedImage.path);
      });
       
    }
  }

  Widget _pickedSelection() {
    return SimpleDialog(
      title: const Text('Choose method'),
      children: [
        SimpleDialogOption(
          onPressed: (() {
            Navigator.pop(context, ImageSource.gallery);
          }),
          child: const ListTile(
            leading: Icon(
              Icons.image,
              color: kPrimaryColor,
            ),
            title: Text('Choose from Galary'),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, ImageSource.camera);
          },
          child: const ListTile(
            leading: Icon(
              Icons.camera,
              color: kPrimaryColor,
            ),
            title: Text('Take a photo'),
          ),
        )
      ],
    );
  }

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
                builder: (context) =>  HomePage(
                  loggedInUser: state.user!,
                ),
              ),
              (Route<dynamic> route) => false,
            );
          }
        }))
      ],
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                GestureDetector(
                  onTap: () {
                    _pickProfileImage(context);
                    debugPrint('updating image');
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      image: _profileImage != null
                          ? DecorationImage(
                              image: FileImage(_profileImage!), fit: BoxFit.cover)
                          : null,
                      shape: BoxShape.circle,
                      border: Border.all(color: kPrimaryColor),
                    ),
                    child: _profileImage == null
                        ? const Icon(
                            Icons.add_a_photo,
                          )
                        : null,
                  ),
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
                  height: size.height * 0.02,
                ),
                const ConfirmPassword(),
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
                _buildRichText(context),
                const SizedBox(
                  height: 20.0,
                ),
                // _buildOr(size),
                // const SizedBox(
                //   height: 20.0,
                // ),
                // _buildGoogleSignupButton(size),
                const SizedBox(
                  height: 50.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRichText(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      const TextSpan(
        text: "Already have an account?  ",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      TextSpan(
          text: "Log In",
          style: const TextStyle(
            color: kPrimaryColor,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SignIn()),
                  (route) => false);
            })
    ]));
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
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(5.0)),
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
