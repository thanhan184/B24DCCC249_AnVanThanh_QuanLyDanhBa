import 'package:contact_manager/data/contact_store.dart';
import 'package:contact_manager/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('đăng nhập sai hiện thông báo lỗi', (tester) async {
    await tester.pumpWidget(ContactApp(store: ContactStore()));

    await tester.enterText(find.byType(TextField).at(0), 'admin');
    await tester.enterText(find.byType(TextField).at(1), 'saimatkhau');
    await tester.tap(find.widgetWithText(FilledButton, 'Đăng nhập'));
    await tester.pump();

    expect(find.text('Sai tên đăng nhập hoặc mật khẩu'), findsOneWidget);
    expect(find.text('Danh bạ liên hệ'), findsNothing);
  });

  testWidgets('đăng nhập đúng vào danh sách với thống kê 3 và 1',
          (tester) async {
        await tester.pumpWidget(ContactApp(store: ContactStore()));

        await tester.enterText(find.byType(TextField).at(0), 'admin');
        await tester.enterText(find.byType(TextField).at(1), '123456');
        await tester.tap(find.widgetWithText(FilledButton, 'Đăng nhập'));
        await tester.pumpAndSettle();

        expect(find.text('Tổng số liên hệ: 3'), findsOneWidget);
        expect(find.text('Liên hệ yêu thích: 1'), findsOneWidget);
        expect(find.text('Nguyễn Văn An'), findsOneWidget);
      });
}