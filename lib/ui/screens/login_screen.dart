import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/app_toast.dart';
import 'chat_screen.dart';
import '../../core/cubit/auth/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var Formkey = GlobalKey<FormState>();
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        AuthCubit cubit = BlocProvider.of(context);
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.white,
            title: Center(),
            elevation: 0,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.white),
          ),
          body: Container(
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: Formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                            "assets/images/e3a198e2871c6605597e04400b84c7491111.png"),
                        const SizedBox(height: 60),
                        Text(
                          "Enter Your Username",
                          style: TextStyle(
                            color: Color(0xC00E5340),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: cubit.userNameController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Color(0xC00E5340)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'username',
                            labelStyle:
                                const TextStyle(color: Color(0xC00E5340)),
                            hintText: 'Type your username',
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              color: Color(0xC00E5340),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.toString().isEmpty) {
                              return 'please enter your username';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xC00E5340),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () async {
                              if (Formkey.currentState!.validate()) {
                                if(await cubit.login()){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatScreen(),),);
                                  showToast(msg: cubit.msg, state: ToastStates.SUCCESS);
                                } else{
                                  showToast(msg: cubit.msg, state: ToastStates.ERROR);
                                }
                              }
                            },
                            child: Text(
                              'LOGIN',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
