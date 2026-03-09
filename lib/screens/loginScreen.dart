import 'dart:developer' as developer;
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '/screens/homePage.dart';
import '/screens/signupScreen.dart';
import '/sqlDatabase/databaseHelper.dart';
import '../GoogleServices/auth_service.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: LoginScreenHome(),
    );
  }
}

class LoginScreenHome extends StatefulWidget {
  @override
  State<LoginScreenHome> createState() => _LoginScreenHomeState();
}

class _LoginScreenHomeState extends State<LoginScreenHome> {
  bool hidePassword = true;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  void showHidePassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void validateInputs() async {
    if (usernameController.text.isEmpty) {
      _showDialog(DialogType.error, 'Error', 'Username is required');
    } else if (passwordController.text.isEmpty) {
      _showDialog(DialogType.error, 'Error', 'Password is required');
    } else {
      final users = await DatabaseHelper()
          .loginUser(usernameController.text, passwordController.text);
      if (users.isEmpty) {
        _showDialog(DialogType.error, 'Login Failed',
            'Invalid username or password');
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: 'Welcome Back!',
          desc: 'Login successful',
          btnOkOnPress: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => Homepage()),
            );
          },
        ).show();
      }
    }
  }

  void _showDialog(DialogType type, String title, String desc) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0EA5E9).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: const Icon(Icons.lock_outline_rounded,
                      color: Colors.white, size: 36),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sign in to your account',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.06), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Username'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: usernameController,
                        hint: 'Enter your username',
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 20),
                      _buildLabel('Password'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: passwordController,
                        hint: 'Enter your password',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        obscureText: hidePassword,
                        toggleVisibility: showHidePassword,
                      ),
                      const SizedBox(height: 28),
                      _buildPrimaryButton('Sign In', validateInputs),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.white.withOpacity(0.1),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'or',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.white.withOpacity(0.1),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () async {
                            // Show loading indicator
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0EA5E9)),
                                ),
                              ),
                            );

                            try {
                              // Add timeout for slow internet connections
                              final user = await AuthService().signInWithGoogle().timeout(
                                const Duration(seconds: 30),
                                onTimeout: () {
                                  throw TimeoutException('Connection timeout. Please check your internet connection and try again.');
                                },
                              );
                              
                              // Dismiss loading indicator
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }

                              if (user != null) {
                                developer.log(
                                  'Google Sign-In successful: ${user.email}',
                                  name: 'LoginScreen',
                                );
                                
                                if (context.mounted) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    title: 'Welcome!',
                                    desc: 'Successfully signed in with Google',
                                    btnOkOnPress: () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (_) => Homepage()),
                                        (route) => false,
                                      );
                                    },
                                  ).show();
                                }
                              } else {
                                if (context.mounted) {
                                  _showDialog(
                                    DialogType.error,
                                    'Sign-In Failed',
                                    'Unable to sign in with Google. Please check your internet connection and try again.',
                                  );
                                }
                              }
                            } on TimeoutException catch (e) {
                              // Dismiss loading indicator
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                              
                              if (context.mounted) {
                                _showDialog(
                                  DialogType.error,
                                  'Connection Timeout',
                                  'Slow internet connection detected. Please check your network and try again.',
                                );
                              }
                              
                              developer.log(
                                'Google Sign-In timeout: $e',
                                name: 'LoginScreen',
                              );
                            } catch (e) {
                              // Dismiss loading indicator
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                              
                              String errorMessage = 'An error occurred during sign-in. Please try again.';
                              
                              // Check for specific error types
                              if (e.toString().contains('network')) {
                                errorMessage = 'Network error. Please check your internet connection.';
                              } else if (e.toString().contains('timeout')) {
                                errorMessage = 'Connection timeout. Please try again.';
                              } else if (e.toString().contains('sign_in')) {
                                errorMessage = 'Google Sign-In failed. Please try again.';
                              }
                              
                              if (context.mounted) {
                                _showDialog(
                                  DialogType.error,
                                  'Sign-In Error',
                                  errorMessage,
                                );
                              }
                              
                              developer.log(
                                'Google Sign-In error: $e',
                                name: 'LoginScreen',
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Colors.white.withOpacity(0.15), width: 1),
                            backgroundColor: const Color(0xFF0F172A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                alignment: Alignment.center,
                                child: const Text(
                                  'G',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4285F4),
                                    fontFamily: 'Arial',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Continue with Google',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5), fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => Signupscreen()),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF0EA5E9),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
        TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF0EA5E9), size: 20),
        suffixIcon: isPassword
            ? IconButton(
          onPressed: toggleVisibility,
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.white.withOpacity(0.4),
            size: 20,
          ),
        )
            : null,
        filled: true,
        fillColor: const Color(0xFF0F172A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0EA5E9), width: 1.5),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildPrimaryButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0EA5E9),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.3),
        ),
      ),
    );
  }
}