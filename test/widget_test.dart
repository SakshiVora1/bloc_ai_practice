import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:subqdocs_bloc/main.dart';

void main() {
  testWidgets('app shows splash with logo', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump();

    expect(find.byType(SvgPicture), findsOneWidget);
  });
}
