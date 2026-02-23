import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:otero_mandy_new/screens/dashboard.dart';
import 'package:otero_mandy_new/sqlDatabase/databaseHelper.dart';

class Listofusers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: ListofusersHome(),
    );
  }
}

class ListofusersHome extends StatefulWidget {
  @override
  State<ListofusersHome> createState() => _ListofusersHomeState();
}

class _ListofusersHomeState extends State<ListofusersHome> {
  var students = [];

  void getAllStudents() async {
    final data = await DatabaseHelper().getAllStudents();
    setState(() {
      students = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllStudents();
  }

  void editUser(BuildContext context, int userId, String fullName,
      String username, String password) {
    var fullNameController = TextEditingController(text: fullName);
    var usernameController = TextEditingController(text: username);
    var passwordController = TextEditingController(text: password);
    bool showPass = true;

    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.fromLTRB(
                  24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Edit User',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Update the user information below',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.45), fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  _buildModalLabel('Full Name'),
                  const SizedBox(height: 8),
                  _buildModalField(
                      controller: fullNameController,
                      hint: 'Full name',
                      icon: Icons.badge_outlined),
                  const SizedBox(height: 16),
                  _buildModalLabel('Username'),
                  const SizedBox(height: 8),
                  _buildModalField(
                      controller: usernameController,
                      hint: 'Username',
                      icon: Icons.alternate_email_rounded),
                  const SizedBox(height: 16),
                  _buildModalLabel('Password'),
                  const SizedBox(height: 8),
                  _buildModalField(
                    controller: passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    obscureText: showPass,
                    toggleVisibility: () =>
                        setModalState(() => showPass = !showPass),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await DatabaseHelper().updateStudent(
                          userId,
                          fullNameController.text,
                          usernameController.text,
                          passwordController.text,
                        );
                        if (result > 0) {
                          Navigator.pop(ctx);
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            title: 'Updated',
                            desc: 'User successfully updated',
                            btnOkOnPress: () => getAllStudents(),
                          ).show();
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            title: 'Error',
                            desc: 'Failed to update user',
                            btnOkOnPress: () {},
                          ).show();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0EA5E9),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Save Changes',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildModalField({
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
            ))
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text(
          'Users',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0EA5E9).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${students.length} users',
              style: const TextStyle(
                  color: Color(0xFF0EA5E9),
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: students.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline_rounded,
                color: Colors.white.withOpacity(0.2), size: 64),
            const SizedBox(height: 16),
            Text('No users found',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4), fontSize: 15)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: students.length,
        itemBuilder: (context, index) {
          var userId = students[index]["id"];
          var fullName = students[index]["fullName"];
          var username = students[index]["username"];
          var password = students[index]["password"];

          final colors = [
            const Color(0xFF0EA5E9),
            const Color(0xFF06B6D4),
            const Color(0xFF8B5CF6),
            const Color(0xFF10B981),
          ];
          final avatarColor = colors[index % colors.length];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: Colors.white.withOpacity(0.06), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: avatarColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      fullName.toString().isNotEmpty
                          ? fullName.toString()[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: avatarColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$fullName',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '@$username',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _actionButton(
                      icon: Icons.edit_rounded,
                      color: const Color(0xFF0EA5E9),
                      onTap: () => editUser(
                          context, userId, fullName, username, password),
                    ),
                    const SizedBox(width: 8),
                    _actionButton(
                      icon: Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                      onTap: () {
                        AwesomeDialog(
                          context: context,
                          title: 'Delete User',
                          desc:
                          'Are you sure you want to delete "$fullName"?',
                          dialogType: DialogType.warning,
                          btnOkText: 'Delete',
                          btnOkOnPress: () async {
                            await DatabaseHelper().deleteStudent(userId);
                            getAllStudents();
                          },
                          btnCancelOnPress: () {},
                        ).show();
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}