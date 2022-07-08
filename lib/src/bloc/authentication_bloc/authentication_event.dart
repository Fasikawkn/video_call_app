part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}


class AuthenticateStarted extends AuthenticationEvent{

  @override
  List<Object> get props => [];
}

class AuthenticateSignOut extends AuthenticationEvent{


  @override
  List<Object> get props => [];

}