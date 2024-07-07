import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/UserModel.dart';
import '../services/UserService.dart';
import '../views/LoginScreen.dart';

class ProfileCubit  extends Cubit<ProfileState> {
  bool isLoading = false;
  BuildContext context;
  UserService userService = UserService();
  UserModel? user;

  ProfileCubit(this.context) : super(ProfileInitialState()) {
    getProfile();
  }

  Future<void> getProfile() async {
    changeLoadingView();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    print(email);
    if (email != null) {
      user = await userService.getUserByEmail(email);
      changeLoadingView();
      emit(ProfileLoadedState(user));
    }else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', false);
      prefs.remove('email');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  void changeLoadingView() {
    isLoading = !isLoading;
    emit(ProfileLoadingState(isLoading));
  }
}

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {
  final bool isLoading;

  ProfileLoadingState(this.isLoading);
}

class ProfileLoadedState extends ProfileState {
  final UserModel? user;

  ProfileLoadedState(this.user);
}