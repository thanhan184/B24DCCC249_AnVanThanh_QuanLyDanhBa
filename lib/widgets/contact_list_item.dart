import 'package:flutter/material.dart';

import '../models/contact.dart';
import 'contact_avatar.dart';

class ContactListItem extends StatelessWidget {
  const ContactListItem({
    super.key,
    required this.contact,
    required this.onTap,
  });

  final Contact contact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: ContactAvatar(name: contact.name),
        title: Text(contact.name),
        subtitle: Text('${contact.phone} • ${contact.group}'),
        trailing: Icon(
          contact.favorite ? Icons.star : Icons.star_border,
          color: contact.favorite ? Colors.amber.shade700 : Colors.grey,
        ),
      ),
    );
  }
}