import 'package:flutter/material.dart';
import 'package:love/views/HomeScreen.dart';
import 'package:love/views/auth/LoginScreen.dart';
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
      _navigateToHomeScreen(context);
    }
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(
          toggleTheme: toggleTheme,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Kayıt Ol',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.lightPinkColor, AppColors.pinkColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        "assets/pay/logo2.png",
                        height: MediaQuery.sizeOf(context).width * .5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildTextField(
                      controller: _emailController,
                      hintText: "Email adresi giriniz",
                      icon: Icons.person,
                      isPassword: false,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _nameController,
                      hintText: "Adınızı girin",
                      icon: Icons.account_circle,
                      isPassword: false,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: "Şifreniz",
                      icon: Icons.lock,
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _biographyController,
                      hintText: "Biyografinizi girin",
                      icon: Icons.info,
                      isPassword: false,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => _signup(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: AppColors.pinkColor,
                      ),
                      child: SizedBox(
                        width: 200, // Sabit genişlik
                        child: Center(
                          child: Text(
                            "KAYIT OL",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AlreadyHaveAnAccountCheck(
                      login: false,
                      press: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(
                              toggleTheme: toggleTheme,
                            ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
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
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isPassword,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      cursorColor: kPrimaryColor,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hintText boş olamaz';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Icon(icon, color: kPrimaryColor),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class AppColors {
  static const Color pinkColor = Color(0xFFE91E63); // Example color
  static const Color lightPinkColor = Color(0xFFF8BBD0); // Light pink color
// Add other colors as needed
}

