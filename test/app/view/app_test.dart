import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home/app/app.dart';
import 'package:smart_home/rooms/room.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(const RoomsPage() as Type), findsOneWidget);
    });
  });
}
