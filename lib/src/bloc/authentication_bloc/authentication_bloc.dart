import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_call_app/src/models/user.dart';
import 'package:video_call_app/src/services/repository/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;

  AuthenticationBloc({
    required this.authenticationRepository,
  }) : super(AuthenticationInitial()) {
    on<AuthenticateStarted>(_mapAuthenticationStarted);
    on<AuthenticateSignOut>(_mapAuthenticatioinLogout);
    on<AuthUserChange>(_mapAuthUserChanged);
  }

  void _mapAuthUserChanged(
      AuthUserChange event, Emitter<AuthenticationState> emit) async {
    if (event.userModel.uid != 'uid') {
      emit(AuthenticationSuccess(user: event.userModel));
    } else {
      emit(const AuthenticationFailure(errorMessage: 'Failed to authenticate'));
    }
  }

  

  void _mapAuthenticationStarted(
      AuthenticateStarted event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      authenticationRepository.getCurrentUser().listen((user) {
        add(AuthUserChange(user));
      });

    } catch (e) {
      print('The error is +++++++++++++++++++++>${e.toString()}');
      emit(AuthenticationFailure(errorMessage: e.toString()));
    }
  }

  void _mapAuthenticatioinLogout(
    AuthenticateSignOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      await authenticationRepository.signOut();
      // emit(AuthenticationLoggedOut());
    } catch (e) {
      print('logout error is +++>>>>>>>>>>>>>>>>>>>>>>>>>>>>${e.toString()}');
      emit(AuthenticationFailure(
        errorMessage: e.toString(),
      ));
    }
  }
}
