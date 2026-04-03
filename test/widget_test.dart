import 'package:flutter_test/flutter_test.dart';

import 'package:subqdocs_bloc/main.dart';

void main() {
  testWidgets('app builds MaterialApp with splash route', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byType(MyApp), findsOneWidget);
  });
}
