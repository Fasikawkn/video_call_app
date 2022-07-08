import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_call_app/src/models/user.dart';
import 'package:video_call_app/src/services/repository/authentication_repository.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormsValidate> {
  AuthenticationRepository authenticationRepository;
  FormBloc({required this.authenticationRepository})
      : super(const FormsValidate(
            email: "example@gmail.com",
            password: "",
            name: 'Example',
            isEmailValid: true,
            isPasswordValid: true,
            isFormValid: false,
            isLoading: false,
            isNameValid: true,
            isFormValidateFailed: false)) {
    on<EmailChanged>(_mapOnEmailChanged);
    on<PasswordChanged>(_mapOnPasswordChanged);
    on<NameChanged>(_onNameChanged);
    on<FormSubmitted>(_onFormSubmitted);
    on<FormSucceeded>(_onFormSucceeded);
    
  }

  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*]).{8,}$',
  );

  bool _isEmailValid(String email) {
    return _emailRegExp.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  bool _isNameValid(String? displayName) {
    return displayName!.isNotEmpty;
  }

  void _mapOnEmailChanged(
      EmailChanged event, Emitter<FormsValidate> emit) async {
    emit(state.copyWith(
        isFormSuccessful: false,
        isFormValid: false,
        isFormValidateFailed: false,
        errorMessage: '',
        email: event.email,
        isEmailValid: _isEmailValid(event.email)));
  }

  void _mapOnPasswordChanged(
      PasswordChanged event, Emitter<FormsValidate> emit) async {
    emit(state.copyWith(
        isFormSuccessful: false,
        isFormValid: false,
        isFormValidateFailed: false,
        errorMessage: '',
        email: event.password,
        isPasswordValid: _isPasswordValid(event.password)));
  }

  void _onNameChanged(NameChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      displayName: event.name,
      isNameValid: _isNameValid(event.name),
    ));
  }

  void _onFormSubmitted(
      FormSubmitted event, Emitter<FormsValidate> emit) async {
    UserModel user = UserModel(
        email: state.email, password: state.password, name: state.name);

    if (event.value == Status.signUp) {
      await _updateUIAndSignUp(event, emit, user);
    } else if (event.value == Status.signIn) {
      await _authenticateUser(event, emit, user);
    }
  }

  _updateUIAndSignUp(
      FormSubmitted event, Emitter<FormsValidate> emit, UserModel user) async {
    emit(state.copyWith(
        errorMessage: "",
        isFormValid: _isPasswordValid(state.password) &&
            _isEmailValid(state.email) &&
            _isNameValid(state.name),
        isLoading: true));
    if (state.isFormValid) {
      try {
        UserCredential? _authUser = await authenticationRepository.signUp(user);
        UserModel _updatedUser = user.copyWith(
          uid: _authUser!.user!.uid,
          isVerified: _authUser.user!.emailVerified,
        );
        if (_updatedUser.isVerified!) {
          emit(state.copyWith(isLoading: false, errorMessage: ''));
        } else {
          state.copyWith(
              isFormValid: false,
              errorMessage:
                  'Please Verify your email, by clicking the link sent to your email',
              isLoading: false);
        }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: e.message,
          isFormValid: false,
        ));
      }
    } else {
      emit(state.copyWith(
          isLoading: false, isFormValid: false, isFormValidateFailed: true));
    }
  }

  _authenticateUser(
      FormSubmitted event, Emitter<FormsValidate> emit, UserModel user) async {
    emit(state.copyWith(
        errorMessage: "",
        isFormValid:
            _isPasswordValid(state.password) && _isEmailValid(state.email),
        isLoading: true));
    if (state.isFormValid) {
      try {
        UserCredential? authUser = await authenticationRepository.signIn(user);
        UserModel updatedUser =
            user.copyWith(isVerified: authUser!.user!.emailVerified);
        if (updatedUser.isVerified!) {
          emit(state.copyWith(isLoading: false, errorMessage: ""));
        } else {
          emit(state.copyWith(
              isFormValid: false,
              errorMessage:
                  "Please Verify your email, by clicking the link sent to you by mail.",
              isLoading: false));
        }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
            isLoading: false, errorMessage: e.message, isFormValid: false));
      }
    } else {
      emit(state.copyWith(
          isLoading: false, isFormValid: false, isFormValidateFailed: true));
    }
  }
   _onFormSucceeded(FormSucceeded event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(isFormSuccessful: true));
  }
}
