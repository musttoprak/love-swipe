import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ChatMessage.dart';

class ChatCubit extends Cubit<ChatState> {
  bool isLoading = false;
  List<ChatMessage> chatMessages = [];

  ChatCubit() : super(ChatsInitialState()) {
    loadChats();
    startPeriodicUpdate();
  }

  Future<void> loadChats() async {
    print("periyota girdi");
    changeLoadingView();
    SharedPreferences.resetStatic();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chatMessagesJson = prefs.getStringList('chatMessages') ?? [];
    print("chat mesaj: ${chatMessagesJson.length}");
    chatMessages = chatMessagesJson.map((messageJson) {
      print("object");
      return ChatMessage.fromJson(jsonDecode(messageJson));
    }).toList();

    chatMessages = chatMessages.reversed.toList();
    changeLoadingView();
    emit(ChatsLoaded(chatMessages));
  }

  void changeLoadingView() {
    isLoading = !isLoading;
    emit(ChatsLoadingState(isLoading));
  }


  void startPeriodicUpdate() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      loadChats();
    });
  }
}

abstract class ChatState {}

class ChatsInitialState extends ChatState {}

class ChatsLoadingState extends ChatState {
  final bool isLoading;

  ChatsLoadingState(this.isLoading);
}

class ChatsLoaded extends ChatState {
  final List<ChatMessage> chatMessages;

  ChatsLoaded(this.chatMessages);
}
