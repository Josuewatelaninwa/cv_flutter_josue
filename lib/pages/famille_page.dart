import 'package:material_ui/material_ui.dart';

class FamillePage extends StatelessWidget {
  const FamillePage({super.key});

  Widget _carteMembre({
    required BuildContext context,
    required String nom,
    required String lien,
    required String profession,
    required String photo,
  }) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundImage: AssetImage(photo),
        ),
        title: Text(nom, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text('Lien : $lien\nProfession : $profession'),
        ),
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text(
          'Les personnes qui comptent',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF153047),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Quelques membres de ma famille.',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: Colors.blueGrey),
        ),
        const SizedBox(height: 16),
        _carteMembre(
          context: context,
          nom: 'WATELANINWA Papy',
          lien: 'Pere',
          profession: 'Engenneer',
          photo: 'assets/images/pere.jpg',
        ),
        _carteMembre(
          context: context,
          nom: 'Mwinja Esther',
          lien: 'Mere',
          profession: 'commercante',
          photo: 'assets/images/mere.jpg',
        ),
        _carteMembre(
          context: context,
          nom: 'Peter Penuel',
          lien: 'Frere',
          profession: 'Etudiant',
          photo: 'assets/images/frere.jpg',
        ),
      ],
    );
  }
}
