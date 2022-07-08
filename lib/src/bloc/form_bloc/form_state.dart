part of 'form_bloc.dart';

abstract class FormState extends Equatable {
  const FormState();

  @override
  List<Object> get props => [];
}

class FormInitial extends FormState {
  @override
  List<Object> get props => [];
}

class FormsValidate extends FormState {
  final String email;
  final String name;
  final String password;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isFormValid;
  final bool isNameValid;
  final bool isFormValidateFailed;
  final bool isLoading;
  final String errorMessage;
  final bool isFormSuccessful;

  const FormsValidate({
    required this.email,
    required this.password,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isFormValid,
    required this.isLoading,
    this.errorMessage = "",
    required this.isNameValid,
    required this.isFormValidateFailed,
    required this.name,
    this.isFormSuccessful = false,
  });

  FormsValidate copyWith(
      {String? email,
      String? password,
      String? displayName,
      bool? isEmailValid,
      bool? isPasswordValid,
      bool? isFormValid,
      bool? isLoading,
      int? age,
      String? errorMessage,
      bool? isNameValid,
      bool? isAgeValid,
      bool? isFormValidateFailed,
      bool? isFormSuccessful}) {
    return FormsValidate(
        email: email ?? this.email,
        password: password ?? this.password,
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isFormValid: isFormValid ?? this.isFormValid,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        isNameValid: isNameValid ?? this.isNameValid,
        name: displayName ?? name,
        isFormValidateFailed: isFormValidateFailed ?? this.isFormValidateFailed,
        isFormSuccessful: isFormSuccessful ?? this.isFormSuccessful);
  }

  @override
  List<Object> get props => [
        email,
        password,
        isEmailValid,
        isPasswordValid,
        isFormValid,
        isLoading,
        errorMessage,
        isNameValid,
        name,
        isFormValidateFailed,
        isFormSuccessful
      ];
}
