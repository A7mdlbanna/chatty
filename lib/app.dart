import 'package:chatty/core/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/cubit/chat/chat_cubit.dart';
import 'ui/screens/chat_screen.dart';
import 'ui/screens/login_screen.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit()..init(),),
          BlocProvider(create: (context) => ChatCubit()..init(),),
        ],
        child: MaterialApp(
          theme: ThemeData(primaryColor: const Color(0xC00E5340),),
          debugShowCheckedModeBanner: false,
          home: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                AuthCubit auth = BlocProvider.of(context);
                return auth.userName == null ? const LoginScreen() : const ChatScreen();
              }
          ),
        )
    );
  }
}