import 'package:cv_flutter_josue/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('connexion, navigation, contacts et deconnexion', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MonAppCv());

    expect(find.text('Se connecter'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).obscureText,
      isTrue,
    );

    await tester.enterText(find.byType(TextField).at(0), 'josue');
    await tester.enterText(find.byType(TextField).at(1), '1234');
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('Mon CV'), findsOneWidget);
    await tester.tap(find.text('Famille'));
    await tester.pumpAndSettle();
    expect(find.text('Les personnes qui comptent'), findsOneWidget);

    await tester.tap(find.text('Contact'));
    await tester.pumpAndSettle();
    expect(find.text('josuewatelaninwa@gmail.com'), findsOneWidget);
    final contactTile = find.ancestor(
      of: find.text('josuewatelaninwa@gmail.com'),
      matching: find.byType(ListTile),
    );
    expect(tester.widget<ListTile>(contactTile).onTap, isNotNull);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Se deconnecter'));
    await tester.pumpAndSettle();

    expect(find.text('Connexion - CV de Josue'), findsOneWidget);
  });
}
