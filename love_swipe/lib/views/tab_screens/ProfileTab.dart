import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_swipe/constants/app_colors.dart';
import 'package:love_swipe/views/profile/EditDescriptionFormPage.dart';
import 'package:love_swipe/views/profile/EditEmailFormPage.dart';
import 'package:love_swipe/views/profile/EditImagePage.dart';
import 'package:love_swipe/views/profile/EditNameFormPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/display_widget.dart';
import '../../cubit/ProfileCubit.dart';
import '../../models/UserModel.dart';
import '../LoginScreen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> with ProfileMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(context),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoadingState && state.isLoading) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Profil",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                body: const Center(child: CircularProgressIndicator()));
          } else if (state is ProfileLoadedState) {
            UserModel? user = state.user;
            if (user != null) {
              return buildScaffold(context, user);
            } else {
              return Scaffold(
                  appBar: AppBar(
                    title: const Text("Profil",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  body: const Center(
                      child: Text('Kullanıcı bilgileri yüklenemedi.')));
            }
          } else {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Profil",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                body: const Center(child: CircularProgressIndicator()),);
          }
        },
      ),
    );
  }
}

mixin ProfileMixin {
  Scaffold buildScaffold(BuildContext context, UserModel user) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              await navigateSecondPage(context, EditImagePage(user));
              await context.read<ProfileCubit>().getProfile();
            },
            child: DisplayImage(
              imagePath: user.profilePhoto ?? "assets/default_photo.png",
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 60),
          buildUserInfoDisplay(
              context, user.username, 'Adınız', EditNameFormPage(user)),
          const SizedBox(height: 20),
          buildUserInfoDisplay(
              context, user.email, 'Email adesiniz', EditEmailFormPage(user)),
          const SizedBox(height: 20),
          buildUserInfoDisplay(context, user.biography, 'Biyografiniz',
              EditDescriptionFormPage(user)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  maximumSize: WidgetStatePropertyAll<Size>(
                    Size.fromWidth(
                      MediaQuery.sizeOf(context).width / 2,
                    ),
                  ),
                  backgroundColor:
                      WidgetStatePropertyAll<Color>(AppColors.redColor)),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isLoggedIn', false);
                prefs.remove('email');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Çıkış",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(BuildContext context, String getValue,
          String title, Widget editPage) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Container(
                  width: MediaQuery.sizeOf(context).width - 50,
                  height: 40,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: .5,
                      ),
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () async {
                              await navigateSecondPage(context, editPage);
                              await context.read<ProfileCubit>().getProfile();
                            },
                            child: Text(
                              getValue,
                              style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.4,
                                  color: AppColors.greenColor),
                              textAlign: TextAlign.start,
                            )),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.grey,
                          size: 40.0,
                        )
                      ]))
            ],
          ));

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    //setState(() {});
  }

  // Handles navigation and prompts refresh.
  Future<void> navigateSecondPage(BuildContext context, Widget editForm) async {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    await Navigator.push(context, route).then(onGoBack);
  }
}
