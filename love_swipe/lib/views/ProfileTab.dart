import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubit/ProfileCubit.dart';
import '../models/UserModel.dart';
import 'LoginScreen.dart';

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
                body: const Center(child: Text('Bir hata oluştu.')));
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(user.profilePhoto),
              ),
              const SizedBox(height: 16),
              Text(user.username,
                  style:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(user.email, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(user.biography, style: const TextStyle(fontSize: 14)),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('isLoggedIn', false);
                  prefs.remove('email');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: const Text('Çıkış Yap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
