import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../utils/cacheHelper.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  String usersCol = 'users';

  FirebaseFirestore database = FirebaseFirestore.instance;
  TextEditingController userNameController = TextEditingController();
  QuerySnapshot<Map<String, dynamic>>? users;

  void init() async {
    print('auth init');
    users = await database.collection(usersCol).get();
    userName = CacheHelper.getString(key: 'username');
    print(userName);
    emit(Init());
  }

  String? userName;
  String msg = "";

  Future<bool> login() async {
    var userName = userNameController.text;
    if (users == null) {
      msg = "loading";
      return false;
    } // todo: notify the user to wait for the data to load
    for (var doc in users!.docs) {
      if(doc.data()['user_name'] == userName) {
        // todo: validate as used before and suggest another one
        msg = "this username was used before, try another one";
        return false;
      }
    }

    /// if user name doesn't exist
    await database.collection(usersCol).add({'user_name': userName});
    msg = "logged in successfully";
    this.userName = userNameController.text;
    CacheHelper.SaveData(key: "username", value: userNameController.text);
    // todo: navigate to chat screen with arguments(username)
    return true;
  }
}
