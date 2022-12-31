import 'package:chatty/core/cubit/auth/auth_cubit.dart';
import 'package:chatty/core/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'core/cubit/chat/chat_cubit.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ChatCubit()..init(),),
          BlocProvider(create: (context) => AuthCubit(),),
        ],
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            ChatCubit chat = BlocProvider.of(context);
            return Scaffold(
              appBar: AppBar(title: const Text('El Bitches',), centerTitle: true,),
              body: Center(
                child: StreamBuilder<QuerySnapshot>(
                  stream: chat.messagesStream,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) return const Text('Something went wrong');
                    if (snapshot.connectionState == ConnectionState.waiting) return const Text("Loading");

                    return snapshot.data == null ? const SizedBox.shrink() : ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Message message = Message.fromJson(document.data() as Map<String, dynamic>);
                        debugPrint(message.toJson().toString());
                        return ListTile(
                          title: Text(message.userName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.cyan)),
                          subtitle: Text(message.messageContent, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),),
                          trailing: Text(DateFormat('jm').format(message.time)),
                        );
                      }).toList(),
                    );
                  },
                )
              ),
            );
          },
        ),
      ),
    );
  }
}