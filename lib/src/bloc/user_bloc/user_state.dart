part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {

  @override
  List<Object> get props => [];
}

class UserFetchLoading extends UserState{
  @override
  List<Object> get props => [];
}

class UserFetchSucess extends UserState{
   final List<UserModel> users;
   const UserFetchSucess(this.users);

  @override
  List<Object> get props => [users];
}

class UserFetchFailure extends UserState{
  final String errorMessage;
  const UserFetchFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
