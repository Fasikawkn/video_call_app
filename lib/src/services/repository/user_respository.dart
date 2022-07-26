

import 'package:video_call_app/src/models/user.dart';
import 'package:video_call_app/src/services/data_provider/user_data_provider.dart';

class UserRepository{
  final UserDataProvider userDataProvider;
  UserRepository({required this.userDataProvider});

  // create User
  Future<bool> createUser(UserModel user, String uid) async{
    return await userDataProvider.createUser(user, uid);
  }

  // get all users
  Future<List<UserModel>> getAllUsers() async{
    return await userDataProvider.getAllUsers();
  }
}