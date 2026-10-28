/// Lớp dữ liệu của một liên hệ.
class Contact {
  final String name;
  final String phone;
  final String group;
  final String gender;
  final String note;
  bool favorite;

  Contact({
    required this.name,
    required this.phone,
    required this.group,
    required this.gender,
    this.favorite = false,
    this.note = '',
  });
}

/// Hàm dùng chung lấy chữ cái đại diện: chữ cái đầu của TỪ CUỐI.
/// Ví dụ: "Nguyễn Văn An" -> "A".
String avatarLetter(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  return parts.last.substring(0, 1).toUpperCase();
}