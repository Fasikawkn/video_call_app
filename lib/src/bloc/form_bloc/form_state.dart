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
  final String confirmPassword;
  final bool isConfirmPasswordValid;
  final String profilePicture;

  const FormsValidate({
    required this.isConfirmPasswordValid,
    required this.confirmPassword,
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
    required this.profilePicture,
  });

  FormsValidate copyWith({
    bool? isConfirmPasswordValid,
    String? email,
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
    bool? isFormSuccessful,
    String? confirmPassword,
    String? profilePicture,
  }) {
    return FormsValidate(
      profilePicture: profilePicture ?? this.profilePicture,
      isConfirmPasswordValid:
          isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      confirmPassword: confirmPassword ?? this.confirmPassword,
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
      isFormSuccessful: isFormSuccessful ?? this.isFormSuccessful,
    );
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
        isFormSuccessful,
        confirmPassword,
        isConfirmPasswordValid,
        profilePicture
      ];
}
