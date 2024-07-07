import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_swipe/services/UserService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/data.dart';
import '../models/Chat.dart';
import '../models/UserModel.dart';

class ChatCubit extends Cubit<ChatState> {
  bool isLoading = false;
  List<Chat> chats = [];
  List<String> users = [];
  List<String> images = [];
  List<String> messages = [];

  ChatCubit() : super(ChatsInitialState()) {
    loadChats();
  }

  void loadChats() async {
    changeLoadingView();
    UserService userService = UserService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    images = prefs.getStringList('images') ?? [];
    messages = prefs.getStringList('messages') ?? [];
    users = prefs.getStringList('users') ?? [];
    changeLoadingView();
    emit(ChatsLoaded(users,images,messages));
  }

  void changeLoadingView() {
    isLoading = !isLoading;
    emit(ChatsLoadingState(isLoading));
  }
}

abstract class ChatState {}

class ChatsInitialState extends ChatState {}

class ChatsLoadingState extends ChatState {
  final bool isLoading;

  ChatsLoadingState(this.isLoading);
}

class ChatsLoaded extends ChatState {
  final List<String> users;
  final List<String> images;
  final List<String> messages;

  ChatsLoaded(this.users, this.images, this.messages);
}
