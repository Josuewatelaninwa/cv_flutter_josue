import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controleurs pour recuperer ce que l'utilisateur tape
  final TextEditingController _identifiantController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();

  String _messageErreur = '';

  // TODO: Remplace ces identifiants de test par les tiens (ou ceux demandes par ton enseignant)
  final String _identifiantAttendu = 'josue';
  final String _motDePasseAttendu = '1234';

  void _seConnecter() {
    final String identifiantSaisi = _identifiantController.text.trim();
    final String motDePasseSaisi = _motDePasseController.text;

    if (identifiantSaisi.isEmpty || motDePasseSaisi.isEmpty) {
      setState(() {
        _messageErreur = 'Veuillez remplir l\'identifiant et le mot de passe.';
      });
      return;
    }

    if (identifiantSaisi == _identifiantAttendu &&
        motDePasseSaisi == _motDePasseAttendu) {
      setState(() {
        _messageErreur = '';
      });

      // Redirige vers l'espace principal apres connexion (impossible de revenir en arriere avec retour)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationPage()),
      );
    } else {
      setState(() {
        _messageErreur = 'Identifiant ou mot de passe incorrect.';
      });
    }
  }

  @override
  void dispose() {
    _identifiantController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO: Remplace par ton titre de page de connexion
        title: const Text('Connexion - CV de Josue'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Remplace ce texte d'accueil par le tien
            const Text(
              'Bienvenue, connectez-vous pour voir mon CV',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Champ identifiant
            TextField(
              controller: _identifiantController,
              decoration: const InputDecoration(
                // TODO: Adapte le label si tu utilises un email ou un nom d'utilisateur
                labelText: 'Identifiant',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Champ mot de passe (texte masque)
            TextField(
              controller: _motDePasseController,
              obscureText: true, // Masque les caracteres du mot de passe
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Message d'erreur si la connexion echoue
            if (_messageErreur.isNotEmpty)
              Text(
                _messageErreur,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 20),

            // Bouton "Se connecter"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _seConnecter,
                child: const Text('Se connecter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}