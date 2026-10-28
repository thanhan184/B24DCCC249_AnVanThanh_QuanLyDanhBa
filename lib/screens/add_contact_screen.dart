import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/contact_store.dart';
import '../models/contact.dart';
import '../utils/validators.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key, required this.store});

  final ContactStore store;

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  static const List<String> _groups = ['Gia đình', 'Bạn bè', 'Công việc', 'Khác'];
  static const List<String> _genders = ['Nam', 'Nữ', 'Khác'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _group = _groups.first;
  String _gender = 'Nam'; // mặc định Nam
  bool _favorite = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final contact = Contact(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      group: _group,
      gender: _gender,
      favorite: _favorite,
      note: _noteController.text.trim(),
    );

    // Kho tự kiểm tra trùng một lần nữa để bảo vệ dữ liệu.
    final ok = widget.store.addContact(contact);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số điện thoại này đã có trong danh bạ')),
      );
      return;
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm liên hệ')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Họ và tên',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => Validators.validatePhone(
                    value,
                    exists: widget.store.phoneExists,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _group,
                  decoration: const InputDecoration(
                    labelText: 'Nhóm liên hệ',
                    prefixIcon: Icon(Icons.group),
                    border: OutlineInputBorder(),
                  ),
                  items: _groups
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _group = value);
                  },
                ),
                const SizedBox(height: 16),
                Text('Giới tính', style: Theme.of(context).textTheme.titleMedium),
                RadioGroup<String>(
                  groupValue: _gender,
                  onChanged: (value) {
                    if (value != null) setState(() => _gender = value);
                  },
                  child: Column(
                    children: [
                      for (final g in _genders)
                        RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          title: Text(g),
                          value: g,
                        ),
                    ],
                  ),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Liên hệ yêu thích'),
                  value: _favorite,
                  onChanged: (value) =>
                      setState(() => _favorite = value ?? false),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  minLines: 3,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Ghi chú (không bắt buộc)',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Lưu liên hệ'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}