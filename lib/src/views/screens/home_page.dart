import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:video_call_app/src/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:video_call_app/src/bloc/user_bloc/user_bloc.dart';
import 'package:video_call_app/src/models/user.dart';
import 'package:video_call_app/src/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_call_app/src/views/screens/group_video_call.dart';
import 'package:video_call_app/src/views/screens/profile_page.dart';
import 'package:video_call_app/src/views/screens/video_call_page.dart';
import 'package:video_call_app/src/views/widgets/custom_contact_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.loggedInUser, Key? key}) : super(key: key);
  final UserModel loggedInUser;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _channelController = TextEditingController();
  bool _validateError = false;

  ClientRole _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: ProfilePage(
          userModel: widget.loggedInUser,
        ),
        appBar: AppBar(
          title: const Text('Video Call'),
          centerTitle: true,
          actions: [
            IconButton(onPressed: (){
              context.read<UserBloc>().add(const FetchAllUsers());
            }, icon: const Icon(Icons.refresh))
          ],
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.group,
                color: Colors.white,
              ),
            )
          ]),
        ),
        body: TabBarView(
          children: [
            BlocBuilder<UserBloc, UserState>(builder: (context, state) {
              if (state is UserFetchLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is UserFetchSucess) {
                List<UserModel> _users = state.users
                    .where((user) => user.uid != widget.loggedInUser.uid)
                    .toList();
                return _users.isNotEmpty
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            children: _users.map(
                              (user) {
                                return ListTile(
                                  leading: CustomContactImage(
                                    height: 40.0,
                                    width: 40.0,
                                    user: user,
                                  ),
                                  title: Text(
                                    user.name!,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.videocam,
                                      color: kPrimaryColor,
                                      size: 30.0,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: ((context) =>
                                              const VideoCallPage()),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      )
                    : const Center(child: Text('No User to chat yet'));
              } else {
                return const Center(
                  child: Text('Something went Wrong'),
                );
              }
            }),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
              height: 400,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'GO',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),
                        ),
                      ),
                    ),
                    title: const Text('Group One'),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GroupVideoCall(
                              channelName: 'FlutterGroupChat',
                              role: ClientRole.Broadcaster,
                            ),
                          ),
                        );
                      },
                      child: const Text('Join'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
