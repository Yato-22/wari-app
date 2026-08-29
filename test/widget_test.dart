import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wari_connect_app/main.dart';
import 'package:wari_connect_app/screens/home_map_screen.dart';

void main() {
  testWidgets('WariConnectApp launches successfully and renders home screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const WariConnectApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(HomeMapScreen), findsOneWidget);
    expect(find.text('SOS'), findsOneWidget);
    expect(find.byType(RichText), findsWidgets);
  });
}


