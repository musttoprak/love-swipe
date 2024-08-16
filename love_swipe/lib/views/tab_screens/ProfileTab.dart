import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love/constants/app_colors.dart';
import 'package:love/views/profile/EditDescriptionFormPage.dart';
import 'package:love/views/profile/EditEmailFormPage.dart';
import 'package:love/views/profile/EditImagePage.dart';
import 'package:love/views/profile/EditNameFormPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/display_widget.dart';
import '../../cubit/ProfileCubit.dart';
import '../../models/UserModel.dart';
import '../auth/LoginScreen.dart';

class ProfileTab extends StatefulWidget {
  final VoidCallback toggleTheme;

  const ProfileTab({super.key, required this.toggleTheme});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> with ProfileMixin {
  @override
  void initState() {
    toggleTheme = widget.toggleTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(context, formkey, nameController,
          emailController, biographyController, toggleTheme),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoadingState && state.isLoading) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Profil",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
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
              body: const Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}

mixin ProfileMixin {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController biographyController = TextEditingController();
  late final VoidCallback toggleTheme;

  Scaffold buildScaffold(BuildContext context, UserModel user) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) async {
              if (result == 'toggleTheme') {
                toggleTheme();
              } else if (result == 'logout') {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isLoggedIn', false);
                prefs.remove('email');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(toggleTheme: toggleTheme),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'toggleTheme',
                child: Row(
                  children:  [
                    Icon(Icons.brightness_6),
                    SizedBox(width: 8),
                    Text('Tema Değiştir'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8),
                    Text('Çıkış Yap'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * .05,),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    buildUserInfoDisplay(context, user.username, 'Adınız',
                        EditNameFormPage(user), nameController),
                    const SizedBox(height: 20),
                    buildUserInfoDisplay(context, user.email, 'Email adresiniz',
                        EditEmailFormPage(user), emailController),
                    const SizedBox(height: 20),
                    buildUserInfoDisplay(
                        context,
                        user.biography,
                        'Biyografiniz',
                        EditDescriptionFormPage(user),
                        biographyController),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  await context.read<ProfileCubit>().updateProfile();
                },
                child: Container(
                    width: MediaQuery.sizeOf(context).width * .9, // Genişlik artırıldı
                    padding: const EdgeInsets.all(16), // Padding artırıldı
                    decoration: BoxDecoration(
                      color: AppColors.pinkColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.update,
                          color: Colors.white,
                          size: 21,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          "Güncelle",
                          style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(BuildContext context, String getValue,
      String title, Widget editPage, TextEditingController controller) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width - 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextFormField(
                controller: controller,
                minLines: title == "Biyografiniz" ? 4 : 1,
                maxLines: title == "Biyografiniz" ? 4 : 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: title == "Biyografiniz" ? 12 : 8),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen bu alanı doldurunuz";
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      );

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

class AppColors {
  static const Color pinkColor = Color(0xFFE91E63); // Example color
  static const Color lightPinkColor = Color(0xFFF8BBD0); // Light pink color
// Add other colors as needed
}
