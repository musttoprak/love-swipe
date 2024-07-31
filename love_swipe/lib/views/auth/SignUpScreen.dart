import 'package:flutter/material.dart';
import 'package:love_swipe/views/HomeScreen.dart';
import 'package:love_swipe/views/auth/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/already_have_an_account_check.dart';
import '../../constants/app_colors.dart';
import '../../constants/constants.dart';
import '../../services/UserService.dart';

class SignUpScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final _formKey = GlobalKey<FormState>();
  final String _profilePhoto = "";
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _biographyController = TextEditingController();

  SignUpScreen({super.key, required this.toggleTheme});

  Future<void> _signup(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String biography = _biographyController.text.trim();
      await UserService().addUser(name, password, email,
          profilePhoto: _profilePhoto, biography: biography);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setBool('isFirstLogin', true);
      prefs.setString('email', email);
      const snackBar = SnackBar(
        content: Text('Kayıt olma işlemi başarılı.'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            toggleTheme: toggleTheme,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Kayıt Ol',
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        "assets/pay/logo2.png",
                        height: MediaQuery.sizeOf(context).width * .5,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * .1,
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: kPrimaryColor,
                      onSaved: (email) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email boş olamaz';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Email adresi giriniz",
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Icon(Icons.person),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        cursorColor: kPrimaryColor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Adınız boş olamaz';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Adınızı girin",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.lock),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: TextFormField(
                        controller: _passwordController,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        cursorColor: kPrimaryColor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Şifre boş olamaz';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Şifreniz",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.lock),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: TextFormField(
                        controller: _biographyController,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        cursorColor: kPrimaryColor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Biyografi boş olamaz';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Biyografinizi girin",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.lock),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    ElevatedButton(
                      onPressed: () => _signup(context),
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(AppColors.pinkColor)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.login,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "KAYIT OL",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    AlreadyHaveAnAccountCheck(
                      login: false,
                      press: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginScreen(
                                toggleTheme: toggleTheme,
                              );
                            },
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
