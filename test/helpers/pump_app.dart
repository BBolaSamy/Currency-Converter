import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpMaterialApp(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(MaterialApp(home: child));
}
