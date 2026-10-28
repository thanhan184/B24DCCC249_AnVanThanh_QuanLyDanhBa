import 'package:flutter/foundation.dart';

import '../models/contact.dart';

/// Kho dữ liệu dùng chung, nằm trong bộ nhớ (RAM).
/// Chỉ được tạo MỘT lần ở main.dart rồi truyền cho các màn hình.
class ContactStore extends ChangeNotifier {
  ContactStore() {
    // Dữ liệu mẫu: chỉ chạy một lần khi kho được tạo.
    _contacts.addAll([
      Contact(
        name: 'Nguyễn Văn An',
        phone: '0901234567',
        group: 'Bạn bè',
        gender: 'Nam',
        favorite: false,
      ),
      Contact(
        name: 'Trần Thị Bình',
        phone: '0912345678',
        group: 'Gia đình',
        gender: 'Nữ',
        favorite: true,
      ),
      Contact(
        name: 'Lê Minh Châu',
        phone: '0987654321',
        group: 'Công việc',
        gender: 'Nữ',
        favorite: false,
      ),
    ]);
  }

  final List<Contact> _contacts = [];

  /// Danh sách chỉ đọc: bên ngoài không thể add/remove trực tiếp.
  List<Contact> get contacts => List.unmodifiable(_contacts);

  int get totalCount => _contacts.length;

  int get favoriteCount => _contacts.where((c) => c.favorite).length;

  Contact? findByPhone(String phone) {
    for (final c in _contacts) {
      if (c.phone == phone) return c;
    }
    return null;
  }

  bool phoneExists(String phone) => findByPhone(phone) != null;

  /// Thêm liên hệ. Trả về false nếu số điện thoại đã tồn tại.
  bool addContact(Contact contact) {
    if (phoneExists(contact.phone)) return false;
    _contacts.add(contact);
    notifyListeners();
    return true;
  }

  /// Xóa liên hệ theo số điện thoại. Trả về false nếu không tìm thấy.
  bool removeContact(String phone) {
    final index = _contacts.indexWhere((c) => c.phone == phone);
    if (index < 0) return false;
    _contacts.removeAt(index);
    notifyListeners();
    return true;
  }

  /// Cập nhật yêu thích trên đối tượng thật trong kho.
  bool setFavorite(String phone, bool value) {
    final contact = findByPhone(phone);
    if (contact == null) return false;
    if (contact.favorite != value) {
      contact.favorite = value;
      notifyListeners();
    }
    return true;
  }
}