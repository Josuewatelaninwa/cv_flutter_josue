import 'package:flutter/material.dart';
import 'pages/login_page.dart';

// TODO: Garde bien cette fonction main(), sinon Flutter ne peut pas demarrer
void main() {
  runApp(const MonAppCv());
}

class MonAppCv extends StatelessWidget {
  const MonAppCv({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO: Remplace le titre de l'application si besoin
      title: 'CV de Josue',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // TODO: Tu peux changer la couleur principale (ex: Colors.blue, Colors.teal)
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Demarre sur la Page (1) de connexion
      home: const LoginPage(),
    );
  }
}