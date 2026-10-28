import 'package:contact_manager/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isValidPhone', () {
    test('chấp nhận 10 chữ số bắt đầu bằng 0', () {
      expect(Validators.isValidPhone('0901234567'), isTrue);
    });
    test('từ chối 9 chữ số', () {
      expect(Validators.isValidPhone('090123456'), isFalse);
    });
    test('từ chối 11 chữ số', () {
      expect(Validators.isValidPhone('09012345678'), isFalse);
    });
    test('từ chối không bắt đầu bằng 0', () {
      expect(Validators.isValidPhone('1901234567'), isFalse);
    });
    test('từ chối ký tự chữ', () {
      expect(Validators.isValidPhone('09012a4567'), isFalse);
    });
  });

  group('validateName', () {
    test('từ chối rỗng và toàn khoảng trắng', () {
      expect(Validators.validateName(''), isNotNull);
      expect(Validators.validateName('   '), isNotNull);
    });
    test('chấp nhận tên hợp lệ', () {
      expect(Validators.validateName('An'), isNull);
    });
  });

  group('validatePhone', () {
    test('báo lỗi khi trùng', () {
      final r = Validators.validatePhone('0901234567', exists: (_) => true);
      expect(r, contains('đã có'));
    });
    test('hợp lệ khi không trùng', () {
      final r = Validators.validatePhone('0901234567', exists: (_) => false);
      expect(r, isNull);
    });
  });
}