import 'package:material_ui/material_ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _identifiantController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();

  String _messageErreur = '';

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

      Navigator.pushReplacementNamed(context, '/home');
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
      appBar: AppBar(title: const Text('Connexion - CV de Josue')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 44,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Bienvenue',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF153047),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connectez-vous pour découvrir mon parcours.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: Colors.blueGrey),
                ),
                const SizedBox(height: 28),
                Card(
                  elevation: 2,
                  color: Colors.white,
                  shadowColor: const Color(0x1A153047),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        TextField(
                          controller: _identifiantController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Identifiant',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _motDePasseController,
                          obscureText: true,
                          onSubmitted: (_) => _seConnecter(),
                          decoration: const InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                        if (_messageErreur.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            _messageErreur,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _seConnecter,
                            icon: const Icon(Icons.login),
                            label: const Text('Se connecter'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
