import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_call_app/src/models/user.dart';
import 'package:video_call_app/src/services/repository/user_respository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  UserBloc({required this.userRepository,}) : super(UserInitial()) {
    on<FetchAllUsers>(_mapFetchAllusers);
  }

  void _mapFetchAllusers(FetchAllUsers event, Emitter<UserState> emit) async{
    emit(UserFetchLoading());

    try {
      List<UserModel> _users  = await userRepository.getAllUsers();
      emit(UserFetchSucess(_users));
      
    } catch (e) {
      emit(UserFetchFailure(e.toString()));
    }

  }
}
