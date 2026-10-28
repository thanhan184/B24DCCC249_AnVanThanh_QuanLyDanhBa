/// Các hàm kiểm tra dữ liệu nhập vào.
class Validators {
  static final RegExp _phoneRegex = RegExp(r'^0[0-9]{9}$');

  static bool isValidPhone(String phone) => _phoneRegex.hasMatch(phone);

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ và tên';
    }
    return null;
  }

  /// [exists] là hàm kiểm tra số đã có trong danh bạ chưa.
  static String? validatePhone(
      String? value, {
        required bool Function(String phone) exists,
      }) {
    final phone = (value ?? '').trim();
    if (phone.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    if (!isValidPhone(phone)) {
      return 'Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng 0';
    }
    if (exists(phone)) {
      return 'Số điện thoại này đã có trong danh bạ';
    }
    return null;
  }
}