import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ChatMessage.dart';

class ChatCubit extends Cubit<ChatState> {
  bool isLoading = false;
  List<ChatMessage> chatMessages = [];
  Timer? _timer;

  ChatCubit() : super(ChatsInitialState()) {
    loadChats();
    startPeriodicUpdate();
  }

  Future<void> loadChats() async {
    print("periyota girdi");
    changeLoadingView();
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
    if (!isClosed) {
      emit(ChatsLoadingState(isLoading));
    }
  }

  void startPeriodicUpdate() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!isClosed) {
        loadChats();
      } else {
        _timer?.cancel(); // Timer'ı iptal et.
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel(); // Timer'ı iptal etmeyi unutmayın.
    return super.close();
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
