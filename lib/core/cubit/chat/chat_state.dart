part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class Init extends ChatState {}

class OnTextChange extends ChatState {}