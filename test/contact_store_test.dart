import 'package:contact_manager/data/contact_store.dart';
import 'package:contact_manager/models/contact.dart';
import 'package:flutter_test/flutter_test.dart';

Contact _newContact(String phone, {bool favorite = false}) => Contact(
  name: 'Test',
  phone: phone,
  group: 'Khác',
  gender: 'Nam',
  favorite: favorite,
);

void main() {
  test('dữ liệu mẫu: 3 liên hệ, 1 yêu thích', () {
    final store = ContactStore();
    expect(store.totalCount, 3);
    expect(store.favoriteCount, 1);
  });

  test('thêm liên hệ mới và thông báo thay đổi', () {
    final store = ContactStore();
    var notified = 0;
    store.addListener(() => notified++);
    expect(store.addContact(_newContact('0900000001', favorite: true)), isTrue);
    expect(store.totalCount, 4);
    expect(store.favoriteCount, 2);
    expect(notified, 1);
  });

  test('không thêm số điện thoại trùng', () {
    final store = ContactStore();
    expect(store.addContact(_newContact('0901234567')), isFalse);
    expect(store.totalCount, 3);
  });

  test('đổi yêu thích cập nhật thống kê', () {
    final store = ContactStore();
    store.setFavorite('0901234567', true);
    expect(store.favoriteCount, 2);
    store.setFavorite('0901234567', false);
    expect(store.favoriteCount, 1);
  });

  test('xóa liên hệ yêu thích giảm cả hai chỉ số', () {
    final store = ContactStore();
    expect(store.removeContact('0912345678'), isTrue);
    expect(store.totalCount, 2);
    expect(store.favoriteCount, 0);
    expect(store.findByPhone('0912345678'), isNull);
  });

  test('xóa số không tồn tại trả về false', () {
    final store = ContactStore();
    expect(store.removeContact('0000000000'), isFalse);
  });

  test('chữ cái đại diện là chữ đầu của từ cuối', () {
    expect(avatarLetter('Nguyễn Văn An'), 'A');
    expect(avatarLetter('  lê minh châu '), 'C');
    expect(avatarLetter(''), '?');
  });
}