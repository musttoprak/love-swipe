import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/UserModel.dart';
import '../services/UserService.dart';
import '../views/auth/LoginScreen.dart';

class ProfileCubit extends Cubit<ProfileState> {
  bool isLoading = false;
  BuildContext context;
  UserService userService = UserService();
  UserModel? user;
  final formkey;
  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController biographyController;

  ProfileCubit(this.context, this.formkey, this.nameController,
      this.emailController, this.biographyController)
      : super(ProfileInitialState()) {
    getProfile();
  }

  Future<void> getProfile() async {
    changeLoadingView();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    print(email);
    if (email != null) {
      user = await userService.getUserByEmail(email);
      nameController.text = user!.username;
      emailController.text = user!.email;
      biographyController.text = user!.biography;
      changeLoadingView();
      emit(ProfileLoadedState(user));
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', false);
      prefs.remove('email');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Future<void> updateProfile() async {

    if (true) {
      UserService userService = UserService();
      await userService.updateUser(user!.id, nameController.text,
          emailController.text, biographyController.text);
      user!.username = nameController.text;
      user!.email = emailController.text;
      user!.biography = biographyController.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email',emailController.text.trim());
      print("güncellendi");
      emit(ProfileLoadedState(user));
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
