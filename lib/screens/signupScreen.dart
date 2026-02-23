import 'package:flutter/material.dart';
import 'package:otero_mandy_new/screens/loginScreen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:otero_mandy_new/sqlDatabase/databaseHelper.dart';

class Signupscreen extends StatefulWidget {
  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: SignupScreenHome(),
    );
  }
}

class SignupScreenHome extends StatefulWidget {
  @override
  State<SignupScreenHome> createState() => _SignupScreenHomeState();
}

class _SignupScreenHomeState extends State<SignupScreenHome> {
  var showpass1 = true;
  var showpass2 = true;

  var fullNameController = TextEditingController();
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPassController = TextEditingController();

  void _showDialog(DialogType type, String title, String desc,
      {VoidCallback? onOk}) {
    AwesomeDialog(
      width: 320,
      context: context,
      title: title,
      desc: desc,
      dialogType: type,
      btnOkOnPress: onOk ?? () {},
    ).show();
  }

  void inputValidation() async {
    if (fullNameController.text.isEmpty) {
      _showDialog(DialogType.error, 'Error', 'Full name is required');
    } else if (userNameController.text.isEmpty) {
      _showDialog(DialogType.error, 'Error', 'Username is required');
    } else if (passwordController.text.isEmpty) {
      _showDialog(DialogType.error, 'Error', 'Password is required');
    } else if (confirmPassController.text != passwordController.text) {
      _showDialog(DialogType.error, 'Error', 'Passwords do not match');
    } else {
      final result = await DatabaseHelper().insertStudent(
          fullNameController.text,
          userNameController.text,
          passwordController.text);
      if (result > 0) {
        _showDialog(DialogType.success, 'Success', 'Account created successfully!',
            onOk: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => LoginScreen())));
      } else {
        _showDialog(DialogType.error, 'Error', 'Failed to create account');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
            const EdgeInsets.symmetric(horizontal: 28.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF06B6D4), Color(0xFF0EA5E9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF06B6D4).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: const Icon(Icons.person_add_alt_1_rounded,
                      color: Colors.white, size: 36),
                ),
                const SizedBox(height: 28),

                const Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Fill in the details below to register',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),

                // Form Card
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
                      _buildLabel('Full Name'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: fullNameController,
                        hint: 'Enter your full name',
                        icon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 20),
                      _buildLabel('Username'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: userNameController,
                        hint: 'Choose a username',
                        icon: Icons.alternate_email_rounded,
                      ),
                      const SizedBox(height: 20),
                      _buildLabel('Password'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: passwordController,
                        hint: 'Create a password',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        obscureText: showpass1,
                        toggleVisibility: () =>
                            setState(() => showpass1 = !showpass1),
                      ),
                      const SizedBox(height: 20),
                      _buildLabel('Confirm Password'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: confirmPassController,
                        hint: 'Re-enter your password',
                        icon: Icons.lock_reset_rounded,
                        isPassword: true,
                        obscureText: showpass2,
                        toggleVisibility: () =>
                            setState(() => showpass2 = !showpass2),
                      ),
                      const SizedBox(height: 28),
                      _buildPrimaryButton('Create Account', inputValidation),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5), fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      ),
                      child: const Text(
                        'Sign In',
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
          borderSide:
          BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: Color(0xFF0EA5E9), width: 1.5),
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
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3),
        ),
      ),
    );
  }
}