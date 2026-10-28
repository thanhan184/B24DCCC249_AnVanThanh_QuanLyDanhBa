import 'package:flutter/material.dart';

import '../data/contact_store.dart';
import '../widgets/contact_list_item.dart';
import '../widgets/contact_stats.dart';
import 'add_contact_screen.dart';
import 'contact_detail_screen.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key, required this.store});

  final ContactStore store;

  Future<void> _openAdd(BuildContext context) async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddContactScreen(store: store)),
    );
    if (added == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm liên hệ')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh bạ liên hệ')),
      // AnimatedBuilder build lại mỗi khi store gọi notifyListeners().
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final contacts = store.contacts;
          return Column(
            children: [
              ContactStats(
                total: store.totalCount,
                favorite: store.favoriteCount,
              ),
              Expanded(
                child: contacts.isEmpty
                    ? const Center(child: Text('Danh bạ trống'))
                    : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 88),
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ContactListItem(
                      contact: contact,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ContactDetailScreen(
                              store: store,
                              phone: contact.phone,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAdd(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Thêm liên hệ'),
      ),
    );
  }
}