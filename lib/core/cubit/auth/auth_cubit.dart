import 'package:bloc/bloc.dart';
import 'package:chatty/core/cubit/chat/chat_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  String usersCol = 'users';
  FirebaseFirestore database = FirebaseFirestore.instance;
  TextEditingController userNameController = TextEditingController();

  QuerySnapshot<Map<String, dynamic>>? users;
  void init() async{
    users = await database.collection(usersCol).get();
    emit(Init());
  }

  String? userName;
  Future<void> login(String userName) async {
    if(users == null)return; // todo: notify the user to wait for the data to load

    for (var doc in users!.docs) {
      if(doc.data()['user_name'] == userName) {
        // todo: validate as used before and suggest another one
        return;
      }
    }

    /// if user name doesn't exist
    await database.collection(usersCol).add({'user_name': userName});
    // todo: navigate to chat screen with arguments(username)
  }
}
