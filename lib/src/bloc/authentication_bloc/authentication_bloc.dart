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
  }

  void _mapAuthenticationStarted(
      AuthenticateStarted event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      UserModel _user = await authenticationRepository.getCurrentUser().first;
      if (_user.uid != 'uid') {
        emit(AuthenticationSuccess(user: _user));
      } else {
        emit(const AuthenticationFailure(
            errorMessage: 'Failed to authenticate'));
      }
    } catch (e) {
      emit(AuthenticationFailure(errorMessage: e.toString()));
    }
  }

  void _mapAuthenticatioinLogout(
      AuthenticateSignOut event, Emitter<AuthenticationState> emit) async {
    try {
      await authenticationRepository.signOut();
    } catch (e) {
      emit(AuthenticationFailure(errorMessage: e.toString(),));
    }
  }
}
