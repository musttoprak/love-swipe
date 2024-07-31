import 'dart:async';
import 'package:flutter/material.dart';
import 'package:love_swipe/constants/app_colors.dart';
import 'package:love_swipe/views/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/already_have_an_account_check.dart';
import '../../constants/constants.dart';
import '../../services/UserService.dart';
import 'SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const LoginScreen({super.key, required this.toggleTheme});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      bool result = await UserService().verifyUser(email, password);
      print("result: $result");
      if (result) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setBool('isFirstLogin', true);
        prefs.setString('email', email);
        const snackBar = SnackBar(
          content: Text('Giriş başarılı.'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    toggleTheme: widget.toggleTheme,
                  )),
        );
      } else {
        const snackBar = SnackBar(
          content: Text('Lütfen bilgilerinizi kontrol edin.'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text(
            'Giriş Yap',
            style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
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
                    const SizedBox(height: defaultPadding),
                    ElevatedButton(
                      onPressed: () => _login(context),
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(AppColors.pinkColor)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
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
                              "GİRİŞ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    AlreadyHaveAnAccountCheck(
                      login: true,
                      press: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUpScreen(
                                toggleTheme: widget.toggleTheme,
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
