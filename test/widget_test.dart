import 'package:flutter_test/flutter_test.dart';
import 'package:ikiwatch/app.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const IkiwatchApp());
    expect(find.text('IKIWATCH'), findsWidgets);
  });
}
