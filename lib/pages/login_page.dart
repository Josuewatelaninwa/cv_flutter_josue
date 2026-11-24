import 'package:material_ui/material_ui.dart';

import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _messageErreur = '';
  bool _chargement = false;
  bool _inscription = false;

  Future<void> _soumettre() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _chargement = true;
      _messageErreur = '';
    });
    final email = _emailController.text.trim();
    final password = _motDePasseController.text;
    try {
      if (_inscription) {
        await ApiService.instance.register(email, password);
        if (!mounted) return;
        setState(() {
          _inscription = false;
          _chargement = false;
          _messageErreur = 'Compte créé. Connectez-vous avec vos identifiants.';
        });
      } else {
        await ApiService.instance.login(email, password);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _messageErreur = error.message;
        _chargement = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                  _inscription
                      ? 'Créez un compte avec l’API pour continuer.'
                      : 'Connectez-vous pour découvrir mon parcours.',
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Adresse e-mail',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (value) {
                              final email = value?.trim() ?? '';
                              if (email.length > 100 ||
                                  !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                      .hasMatch(email)) {
                                return 'Saisissez une adresse e-mail valide.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _motDePasseController,
                            obscureText: true,
                            onFieldSubmitted: (_) => _soumettre(),
                            decoration: const InputDecoration(
                              labelText: 'Mot de passe',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            validator: (value) {
                              final password = value ?? '';
                              if (password.isEmpty) {
                                return 'Saisissez votre mot de passe.';
                              }
                              if (_inscription && password.length < 6) {
                                return '6 caractères minimum.';
                              }
                              return null;
                            },
                          ),
                          if (_messageErreur.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              _messageErreur,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _messageErreur.startsWith('Compte créé')
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _chargement ? null : _soumettre,
                              icon: _chargement
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(
                                      _inscription
                                          ? Icons.person_add
                                          : Icons.login,
                                    ),
                              label: Text(
                                _inscription
                                    ? 'Créer un compte'
                                    : 'Se connecter',
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _chargement
                                ? null
                                : () {
                                    setState(() {
                                      _inscription = !_inscription;
                                      _messageErreur = '';
                                    });
                                  },
                            child: Text(
                              _inscription
                                  ? 'J’ai déjà un compte'
                                  : 'Créer un compte',
                            ),
                          ),
                        ],
                      ),
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
