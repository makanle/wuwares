import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wuwares/api/UserApi.dart';
import 'package:wuwares/screens/admin/admin_dashboard.dart';
import 'package:wuwares/screens/home/user_home_screen.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final _usernameController = TextEditingController();
  UserRole _selectedRole = UserRole.user;
  void _handleLogin() {
    googleLogin((_selectedRole == UserRole.user) ? "user" : "admin");

    context.read<AuthService>().updateCurrUser(getProfile() as User);
    if(_selectedRole == UserRole.admin){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboard()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserHomeScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Wuwa',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              // const SizedBox(height: 48),
              // TextField(
              //   controller: _usernameController,
              //   decoration: const InputDecoration(
              //     labelText: 'Username',
              //     border: OutlineInputBorder(),
              //   ),
              // ),
              const SizedBox(height: 24),
              const Text('Select Role:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<UserRole>(
                    value: UserRole.user,
                    groupValue: _selectedRole,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                  const Text('User'),
                  const SizedBox(width: 24),
                  Radio<UserRole>(
                    value: UserRole.admin,
                    groupValue: _selectedRole,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                  const Text('Admin'),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
