import 'package:flutter/material.dart';

import 'data/contact_store.dart';
import 'screens/login_screen.dart';

void main() {
  final store = ContactStore();
  runApp(ContactApp(store: store));
}

class ContactApp extends StatelessWidget {
  const ContactApp({super.key, required this.store});

  final ContactStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý danh bạ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: LoginScreen(store: store),
    );
  }
}
