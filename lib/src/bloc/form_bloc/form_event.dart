part of 'form_bloc.dart';

enum Status { signIn, signUp }

abstract class FormEvent extends Equatable {
  const FormEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends FormEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class ProfilePictureChanged extends FormEvent {
  final String profilePicture;
  const ProfilePictureChanged(this.profilePicture);

  @override
  List<Object> get props => [profilePicture];
}

class PasswordChanged extends FormEvent {
  final String password;
  const PasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class ConfirmPasswordChanged extends FormEvent {
  final String confirmPassword;
  const ConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object> get props => [confirmPassword];
}

class NameChanged extends FormEvent {
  final String name;
  const NameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class FormSubmitted extends FormEvent {
  final Status value;
  const FormSubmitted({required this.value});

  @override
  List<Object> get props => [value];
}

class FormSucceeded extends FormEvent {
  const FormSucceeded();

  @override
  List<Object> get props => [];
}