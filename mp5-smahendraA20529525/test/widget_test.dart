// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mp5/main.dart';
import 'package:mp5/views/home_page.dart';
import 'package:mp5/views/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('SearchPage Widget Tests', () {
    late SharedPreferences sharedPreferences;

    setUp(() {
      sharedPreferences = MockSharedPreferences();
    });

    testWidgets('SearchPage should display text fields and buttons', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SearchPage()));
      expect(find.text('Search In:'), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsNWidgets(3));
      expect(find.text('Sources:'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Recent Searches:'), findsOneWidget);
      expect(find.byType(Chip), findsNothing);
    });
  });

  testWidgets('HomePage initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(find.text('Top Headlines'), findsOneWidget);
  });

  testWidgets('App initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(const News());

    expect(find.byType(HomePage), findsOneWidget);
  });
}
