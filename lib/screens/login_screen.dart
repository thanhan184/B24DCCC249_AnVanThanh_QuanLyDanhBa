import 'package:flutter/material.dart';

import '../data/contact_store.dart';
import 'contact_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.store});

  final ContactStore store;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const String _validUser = 'admin';
  static const String _validPass = '123456';

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _login() {
    final user = _userController.text.trim();
    final pass = _passController.text;

    if (user.isEmpty) {
      setState(() => _error = 'Vui lòng nhập tên đăng nhập');
      return;
    }
    if (pass.isEmpty) {
      setState(() => _error = 'Vui lòng nhập mật khẩu');
      return;
    }
    if (user == _validUser && pass == _validPass) {
      // pushReplacement: loại LoginScreen khỏi ngăn xếp, Back không quay lại.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ContactListScreen(store: widget.store),
        ),
      );
    } else {
      setState(() => _error = 'Sai tên đăng nhập hoặc mật khẩu');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.contacts, size: 72, color: scheme.primary),
                  const SizedBox(height: 12),
                  Text(
                    'Đăng nhập',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _userController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Tên đăng nhập',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passController,
                    obscureText: true,
                    onSubmitted: (_) => _login(),
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_error != null)
                    Text(
                      _error!,
                      style: TextStyle(color: scheme.error),
                    ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _login,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Đăng nhập'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}