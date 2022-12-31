import 'package:chatty/core/cubit/auth/auth_cubit.dart';
import 'package:chatty/core/utils/cacheHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/cubit/chat/chat_cubit.dart';
import '../../core/model/message.dart';
import 'login_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        AuthCubit auth = BlocProvider.of(context);
        ChatCubit chat = BlocProvider.of(context);
        var msgController = TextEditingController();
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            flexibleSpace: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 18,
                    ),
                    const CircleAvatar(
                      maxRadius: 20,
                      child: Icon(Icons.adb),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Divider(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            "Restroom",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        CacheHelper.removeData("username");
                        auth.userName = null;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: chat.messagesStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Something went wrong");
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(),);
                        }
                        return snapshot.data == null || snapshot.data!.docs.isEmpty
                            ? Center(child: Image.asset('assets/images/no_messages.png'),)
                            : Container(
                                color: Colors.white,
                                child: ListView(
                                  reverse: true,
                                  controller: chat.chatController,
                                  children: snapshot.data!.docs.asMap().map((index, DocumentSnapshot document) {
                                    Message message = Message.fromJson(
                                        document.data() as Map<String, dynamic>);
                                    debugPrint(message.toJson().toString());
                                    return MapEntry('key$index', Container(
                                      padding: const EdgeInsets.only(
                                          left: 14, right: 14, top: 2, bottom: 2),
                                      child: Align(
                                        alignment: (message.userName != auth.userName!
                                            ? Alignment.topLeft
                                            : Alignment.topRight),
                                        child: Column(
                                          crossAxisAlignment:
                                          (message.userName != auth.userName!
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.end),
                                          children: [
                                            if(message.userName != auth.userName! && (index == 0 || (snapshot.data!.docs[index - 1].data() as Map<String, dynamic>)['user_name'] != message.userName))...[
                                              Text(
                                              message.userName,
                                              style: const TextStyle(
                                                color: Colors.cyan,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            ],
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(20),
                                                color: (message.userName != auth.userName!
                                                    ? Colors.grey.shade200
                                                    : Colors.blue[200]),
                                              ),
                                              padding: const EdgeInsets.all(16),
                                              child: Text(
                                                message.messageContent,
                                                style: const TextStyle(fontSize: 15),
                                              ),
                                            ),
                                            if(index == snapshot.data!.docs.length - 1 || (snapshot.data!.docs[index + 1].data() as Map<String, dynamic>)['user_name'] != message.userName)...[
                                              Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                DateFormat('jm').format(message.time),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                          ]
                                          ],
                                        ),
                                      ),
                                    ));
                                  }).values.toList().reversed.toList(),
                                ),
                              );
                      },
                    ),
                  ),
                  const SizedBox(height: 50,)
                ],
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          controller: msgController,
                          decoration: const InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          if (msgController.text.isNotEmpty) {
                            Message? message = Message(
                                userName: auth.userName!,
                                messageContent: msgController.text,
                                time: DateTime.now());
                            chat
                                .sendMessage(message)
                                .then((value) => msgController.clear());
                          }
                        },
                        backgroundColor: Colors.blue,
                        elevation: 0,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
