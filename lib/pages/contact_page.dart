import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _ouvrirLien(BuildContext context, Uri uri) async {
    final ouvert = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ouvert && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d\'ouvrir ce lien sur cet appareil.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const telephone = '+243 976 645 158';
    const email = 'josuewatelaninwa@gmail.com';
    const adresse = 'Goma, Republique Democratique du Congo';

    final contacts = [
      _ContactLien(
        icone: Icons.phone_outlined,
        titre: 'Telephone',
        valeur: telephone,
        uri: Uri(scheme: 'tel', path: telephone.replaceAll(RegExp(r'\s+'), '')),
      ),
      _ContactLien(
        icone: Icons.email_outlined,
        titre: 'E-mail',
        valeur: email,
        uri: Uri(scheme: 'mailto', path: email),
      ),
      _ContactLien(
        icone: Icons.location_on_outlined,
        titre: 'Adresse',
        valeur: adresse,
        uri: Uri.https('www.google.com', '/maps/search/', {
          'api': '1',
          'query': adresse,
        }),
      ),
      _ContactLien(
        icone: Icons.work_outline,
        titre: 'LinkedIn',
        valeur: 'www.linkedin.com/in/josue-watelaninwa',
        uri: Uri.https('www.linkedin.com', '/in/josue-watelaninwa'),
      ),
      _ContactLien(
        icone: Icons.code,
        titre: 'GitHub',
        valeur: 'github.com/Josuewatelaninwa',
        uri: Uri.parse('https://github.com/Josuewatelaninwa/'),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Padding(
            padding: EdgeInsets.all(18),
            child: Row(
              children: [
                Icon(Icons.connect_without_contact, size: 30),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Besoin de me joindre ? Touchez une coordonnee pour l\'ouvrir.',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...contacts.map(
          (contact) => Card(
            color: Colors.white,
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(contact.icone),
              ),
              title: Text(
                contact.titre,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(contact.valeur),
              trailing: const Icon(Icons.open_in_new, size: 20),
              onTap: () => _ouvrirLien(context, contact.uri),
            ),
          ),
        ),
      ],
    );
  }
}

class _ContactLien {
  const _ContactLien({
    required this.icone,
    required this.titre,
    required this.valeur,
    required this.uri,
  });

  final IconData icone;
  final String titre;
  final String valeur;
  final Uri uri;
}
