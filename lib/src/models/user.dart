import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? name;
  String? picture;
  String? email;
  String? password;
  bool? isVerified;

  UserModel(
      {this.uid,
      this.name,
      this.picture,
      this.email,
      this.password,
      this.isVerified});

   UserModel copyWith({
        String? uid,
        String? name,
        String? picture,
        String? email,
        String? password,
        bool? isVerified,
    }) => 
        UserModel(
            uid: uid ?? this.uid,
            name: name ?? this.name,
            picture: picture ?? this.picture,
            email: email ?? this.email,
            password: password ?? this.password,
            isVerified: isVerified ?? this.isVerified,
        );


  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    picture = json['picture'];
    email = json['email'];
    password = json['password'];
    isVerified = json['isVerified'];
  }

   UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        email = doc.data()!["email"],
        name = doc.data()!["displayName"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['picture'] = picture;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}