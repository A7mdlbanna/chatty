import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../model/message.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  String messagesCol = 'messages';
  FirebaseFirestore database = FirebaseFirestore.instance;

  Stream<QuerySnapshot>? messagesStream;
  void init() async{
    messagesStream = database.collection(messagesCol).orderBy('time', descending: false).snapshots();
    emit(Init());
  }

  Future<void> sendMessage(Message message) async {
    debugPrint(message.toJson().toString());
    await database.collection(messagesCol).add(message.toJson());
    chatController.jumpTo(chatController.position.minScrollExtent);
  }

  ScrollController chatController = ScrollController();
}
