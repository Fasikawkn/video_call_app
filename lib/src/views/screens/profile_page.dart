import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_call_app/src/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:video_call_app/src/bloc/user_bloc/user_bloc.dart';
import 'package:video_call_app/src/models/user.dart';
import 'package:video_call_app/src/views/widgets/custom_contact_image.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.userModel, Key? key}) : super(key: key);
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    debugPrint('User is $userModel');
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserFetchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is UserFetchSucess) {
          List<UserModel> _users = state.users;
          List<UserModel> _loggedInUser = _users.where(
            (element) {
              return element.uid == userModel.uid;
            },
          ).toList();
          return Drawer(
            child: Center(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      _loggedInUser.first.name!,
                    ),
                    accountEmail: Text(userModel.email!),
                    currentAccountPicture: CustomContactImage(
                      height: 40.0,
                      width: 40.0,
                      user: _loggedInUser.first,
                    ),
                  ),

                  ListTile(
                    onTap: (){
                      context.read<AuthenticationBloc>().add(
                        AuthenticateSignOut(),
                      );

                    },
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                  )
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('Something went Wrong'),
          );
        }
      },
    );
  }
}
