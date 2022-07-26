import 'package:flutter/material.dart';
import 'package:video_call_app/src/models/user.dart';
import 'package:video_call_app/src/utils/constants.dart';

class CustomContactImage extends StatelessWidget {
  const CustomContactImage(
      {required this.height, required this.width, required this.user, Key? key})
      : super(key: key);
  final double width;
  final double height;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    debugPrint('the user picture is ${user.picture}');
    debugPrint('the user picture is ${user.name}');
    debugPrint('the user picture is ${user.uid}');

    return user.picture != null
        ? user.picture!.isNotEmpty
            ? Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                        user.picture!,
                      ),
                      fit: BoxFit.cover),
                ),
              )
            : Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    user.name![0],
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                ),
              )
        : Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.name![0],
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
            ),
          );
  }
}
