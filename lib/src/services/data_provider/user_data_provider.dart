import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:video_call_app/src/models/user.dart';

class UserDataProvider {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // upload profile image to firebase database
  Future<String> _addProfileImage(String imagePath) async {
    // String fileName = imagePath
    //     .substring(imagePath.lastIndexOf('/'), imagePath.lastIndexOf('.'))
    //     .replaceAll('/', '');

    File _file = File(imagePath);
    final _fileName = basename(_file.path);
    final _destination = 'profileImage/$_fileName';
    String _fileLink = '';
    try {
      final _ref = _firebaseStorage.ref().child(_destination);
      final _response = await _ref.putFile(_file);
      if (_response.state == TaskState.success) {
        final String _downloadUrl = await _response.ref.getDownloadURL();
        _fileLink = _downloadUrl;

        debugPrint(
            '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
        debugPrint(_downloadUrl);
      } else {
        throw Exception(_response.state.toString());
      }
    } on FirebaseException catch (e) {
      throw FirebaseException(code: e.code, message: e.message, plugin: '');
    }
    return _fileLink;
  }

  // add user
  Future<bool> createUser(UserModel user, String uid) async {
    late bool _isAdded;
    try {
      if (user.picture != '') {
        final _profilePicture = await _addProfileImage(user.picture!);
        final _newUser = user.copyWith(picture: _profilePicture);
        await _firebaseFirestore.collection('users').doc(uid).set(_newUser.toJson());
      } else {
        await _firebaseFirestore.collection('users').doc(uid).set(user.toJson());
      }
      _isAdded = true;
    } on FirebaseException catch (e) {
      throw FirebaseException(
        plugin: 'plugin',
        code: e.code,
        message: e.message,
      );
    }
    return _isAdded;
  }

  // get all users
  Future<List<UserModel>> getAllUsers() async {
    try {
      final _snapshot = await _firebaseFirestore.collection('users').get();
      return _snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw FirebaseException(
          plugin: 'plugin', code: e.code, message: e.message);
    }
  }
  
}
