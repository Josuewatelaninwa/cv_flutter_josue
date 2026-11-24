import 'package:cv_flutter_josue/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('la connexion utilise un e-mail et valide les champs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MonAppCv());

    expect(find.text('Adresse e-mail'), findsOneWidget);
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();
    expect(find.text('Saisissez une adresse e-mail valide.'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'josue@example.com',
    );
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();
    expect(find.text('Saisissez votre mot de passe.'), findsOneWidget);
  });

  testWidgets('la création de compte valide la longueur du mot de passe', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MonAppCv());
    await tester.tap(find.text('Créer un compte'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).first,
      'josue@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, '123');
    await tester.tap(find.text('Créer un compte').last);
    await tester.pumpAndSettle();

    expect(find.text('6 caractères minimum.'), findsOneWidget);
  });
}
