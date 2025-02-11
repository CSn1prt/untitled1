import 'package:flutter/material.dart';
import 'package:untitled1/screens/webview_screen.dart';
import 'menu_screen.dart';
import 'navigation_bar_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final _emailController = TextEditingController(); // Controller for email field
  final _passwordController = TextEditingController(); // Controller for password field

  bool _isLoading = false; // To show a loading indicator during login

  // Simulate a login process
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // Simulate a network call (e.g., API request)
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false; // Hide loading indicator
      });

      // Navigate to another screen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인 화면'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '이메일',
                  hintText: '여기에 이메일 주소를 입력해 주세요',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일';
                  }
                  if (!value.contains('@')) {
                    return '정상적인 이메일 주소를 입력해 주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true, // Hide password
                decoration: const InputDecoration(
                  labelText: '패스워드',
                  hintText: '정확한 비밀번호를 입력해주세요',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이곳에 비밀번호를 입력해 보시요';
                  }
                  if (value.length < 6) {
                    return '비밀번호는 4자리 이상입니다';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator() // Show loading indicator
                  : ElevatedButton(
                onPressed: _login,
                child: const Text('로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}