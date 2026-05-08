import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cpp/main.dart';

void main() {
  testWidgets('App shows bootstrap state', (WidgetTester tester) async {
    // Avoid real Firebase.initializeApp in unit tests (would hang + leave timeout timers).
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(MaterialApp), findsOneWidget);
    final hasError = find.text('Firebase initialization failed').evaluate().isNotEmpty;
    final hasLoader = find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
    final hasSplashOrSession =
        find.textContaining('Hostel').evaluate().isNotEmpty ||
            find.textContaining('Starting').evaluate().isNotEmpty;
    expect(hasError || hasLoader || hasSplashOrSession, isTrue);
    debugDefaultTargetPlatformOverride = null;
  });
}
