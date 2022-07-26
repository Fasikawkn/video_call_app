import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:video_call_app/app_bloc_observer.dart';
import 'package:video_call_app/src/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:video_call_app/src/bloc/form_bloc/form_bloc.dart';
import 'package:video_call_app/src/bloc/user_bloc/user_bloc.dart';
import 'package:video_call_app/src/services/data_provider/authentication_service.dart';
import 'package:video_call_app/src/services/data_provider/user_data_provider.dart';
import 'package:video_call_app/src/services/repository/authentication_repository.dart';
import 'package:video_call_app/src/services/repository/user_respository.dart';
import 'package:video_call_app/src/views/screens/home_page.dart';
import 'package:video_call_app/src/views/screens/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final _authenticationRepository = AuthenticationRepository(
    dataProvider: AuthenticationDataProvider(),
  );

  final _userRepository = UserRepository(
    userDataProvider: UserDataProvider(),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (value) => BlocOverrides.runZoned(
        () => runApp(
              MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: ((context) => AuthenticationBloc(
                          authenticationRepository: _authenticationRepository,
                        )..add(
                            AuthenticateStarted(),
                          )),
                  ),
                  BlocProvider(
                    create: (context) => FormBloc(
                      userRepository: _userRepository,
                      authenticationRepository: _authenticationRepository,
                    ),
                  ),
                  BlocProvider(
                      create: (context) =>
                          UserBloc(userRepository: _userRepository)
                            ..add(const FetchAllUsers()))
                ],
                child: const VideoCallApp(),
              ),
            ),
        blocObserver: AppBlocObserver()),
  );
}

class VideoCallApp extends StatelessWidget {
  const VideoCallApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const BlocNavigate(),
    );
  }
}

class BlocNavigate extends StatelessWidget {
  const BlocNavigate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationSuccess) {
          return HomePage(
            loggedInUser: state.user!,
          );
        } else {
          return const WelcomePage();
        }
      },
    );
  }
}

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return const HomePage();
//         } else {
//           return const SignIn();
//         }
//       },
//     );
//   }
// }
