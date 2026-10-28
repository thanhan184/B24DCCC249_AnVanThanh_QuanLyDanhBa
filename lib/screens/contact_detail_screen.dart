import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/contact_store.dart';
import '../models/contact.dart';
import '../widgets/contact_avatar.dart';

class ContactDetailScreen extends StatefulWidget {
  const ContactDetailScreen({
    super.key,
    required this.store,
    required this.phone,
  });

  final ContactStore store;
  final String phone; // khóa định danh liên hệ

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  Contact? _lastKnown; // giữ lại để không nháy "không tìm thấy" khi đang xóa
  bool _deleting = false;

  Future<void> _call(Contact contact) async {
    // Chỉ MỞ trình quay số (tương đương ACTION_DIAL), không tự gọi.
    final uri = Uri(scheme: 'tel', path: contact.phone);
    bool ok = false;
    try {
      ok = await launchUrl(uri);
    } catch (_) {
      ok = false;
    }
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể mở trình quay số')),
      );
    }
  }

  Future<void> _confirmDelete(Contact contact) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa liên hệ'),
        content: Text('Bạn có chắc muốn xóa "${contact.name}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      _deleting = true;
      widget.store.removeContact(contact.phone);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final live = widget.store.findByPhone(widget.phone);
        if (live != null) _lastKnown = live;
        final contact = live ?? (_deleting ? _lastKnown : null);

        if (contact == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Chi tiết liên hệ')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Không tìm thấy liên hệ'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Quay lại'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Chi tiết liên hệ')),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: ContactAvatar(name: contact.name, radius: 44)),
                  const SizedBox(height: 12),
                  Text(
                    contact.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    icon: Icons.phone,
                    label: 'Số điện thoại',
                    value: contact.phone,
                  ),
                  _InfoRow(
                    icon: Icons.group,
                    label: 'Nhóm',
                    value: contact.group,
                  ),
                  _InfoRow(
                    icon: Icons.wc,
                    label: 'Giới tính',
                    value: contact.gender,
                  ),
                  _InfoRow(
                    icon: Icons.notes,
                    label: 'Ghi chú',
                    value: contact.note.isEmpty
                        ? 'Không có ghi chú'
                        : contact.note,
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('Liên hệ yêu thích'),
                    value: contact.favorite,
                    onChanged: (value) => widget.store
                        .setFavorite(contact.phone, value ?? false),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _call(contact),
                    icon: const Icon(Icons.call),
                    label: const Text('Gọi điện'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Quay lại'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => _confirmDelete(contact),
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    label: Text(
                      'Xóa liên hệ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label, style: Theme.of(context).textTheme.bodySmall),
      subtitle: Text(value, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}