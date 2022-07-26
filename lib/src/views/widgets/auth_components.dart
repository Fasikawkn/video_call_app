import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_call_app/src/bloc/form_bloc/form_bloc.dart';
import 'package:video_call_app/src/utils/constants.dart';
import 'package:video_call_app/src/views/screens/welcome_page.dart';

class EmailField extends StatelessWidget {
  const EmailField({required this.formFor, Key? key}) : super(key: key);
  final Status formFor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            onChanged: ((value) {
              context.read<FormBloc>().add(EmailChanged(value));
            }),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelText: 'Email',
                helperText: formFor == Status.signUp
                    ? 'Valid Email. Eg. dani@gmail.com'
                    : null,
                errorText: !state.isEmailValid
                    ? 'Please ensure the email entered is valid'
                    : null,
                hintText: 'Email',
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: border),
          ),
        );
      },
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({required this.formFor, Key? key}) : super(key: key);
  final Status formFor;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {

  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            onChanged: ((value) {
              context.read<FormBloc>().add(PasswordChanged(value));
            }),
            keyboardType: TextInputType.visiblePassword,
            obscureText: _isObscured,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(_isObscured? Icons.visibility: Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                ),
                labelText: 'Password',
                helperText: widget.formFor == Status.signUp
                    ? 'Password should be at least 8 characters with at least one letter, number and special character'
                    : null,
                errorText: widget.formFor == Status.signUp
                    ? !state.isPasswordValid
                        ? 'Password must be at least 8 characters and contain at least one letter and number'
                        : null
                    : null,
                hintText: 'Password',
                errorMaxLines: 2,
                helperMaxLines: 2,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: border),
          ),
        );
      },
    );
  }
}

class ConfirmPassword extends StatefulWidget {
  const ConfirmPassword({Key? key}) : super(key: key);

  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            onChanged: ((value) {
              context.read<FormBloc>().add(ConfirmPasswordChanged(value));
            }),
            keyboardType: TextInputType.visiblePassword,
            obscureText: _isObscured,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon:  Icon(_isObscured? Icons.visibility: Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                ),
                labelText: 'Confirm Password',
                errorText:
                    !state.isConfirmPasswordValid ? 'Password do not match!' : null,
                hintText: 'Confirm Password',
                errorMaxLines: 2,
                helperMaxLines: 2,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 10.0,
                ),
                border: border),
          ),
        );
      },
    );
  }
}

class NameField extends StatelessWidget {
  const NameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            onChanged: ((value) {
              context.read<FormBloc>().add(NameChanged(value));
            }),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelText: 'Name',
                helperText: 'Name must be valid',
                errorText: !state.isNameValid ? 'Name canot be empty' : null,
                hintText: 'Name',
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: border),
          ),
        );
      },
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({required this.label, required this.onPressed, Key? key})
      : super(key: key);
  final String label;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: size.width * 0.8,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    if (!state.isFormValid) {
                      onPressed();
                    }
                  },
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kPrimaryColor),
                    side:
                        MaterialStateProperty.all<BorderSide>(BorderSide.none),
                  ),
                ),
              );
      },
    );
  }
}

class ErrorDialog extends StatelessWidget {
  final String? errorMessage;
  const ErrorDialog({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: Text(errorMessage!),
      actions: [
        TextButton(
          child: const Text("Ok"),
          onPressed: () => errorMessage!.contains("Please Verify your email")
              ? Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                  (Route<dynamic> route) => false)
              : Navigator.of(context).pop(),
        )
      ],
    );
  }
}
