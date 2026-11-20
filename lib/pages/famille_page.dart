import 'package:flutter/material.dart';

class FamillePage extends StatelessWidget {
  const FamillePage({super.key});

  // Petit widget simple pour afficher un membre de la famille
  // TODO: Tu peux ajouter d'autres cartes dans la ListView ci-dessous si tu as plus de membres
  Widget _carteMembre({
    required String nom,
    required String lien,
    required String profession,
    required String photo,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage(photo),
        ),
        title: Text(
          nom,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Lien : $lien\nProfession : $profession'),
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO: Remplace par le titre souhaite pour la page famille
        title: const Text('Ma Famille'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          // TODO: Remplace les informations de ton pere
          _carteMembre(
            nom: 'WATELANINWA Papy', // TODO: Vrai nom du pere
            lien: 'Pere', // TODO: Lien de parente
            profession: 'Engenneer', // TODO: Profession du pere
            photo: 'assets/images/pere.jpg', // TODO: Chemin de la photo du pere
          ),

          // TODO: Remplace les informations de ta mere
          _carteMembre(
            nom: 'Mwinja Esther', // TODO: Vrai nom de ta mere
            lien: 'Mere', // TODO: Lien de parente
            profession: 'commercante', // TODO: Profession de ta mere
            photo: 'assets/images/mere.jpg', // TODO: Chemin de la photo de ta mere
          ),

          // TODO: Remplace les informations d'un frere ou d'une soeur
          _carteMembre(
            nom: 'Peter Penuel', // TODO: Vrai nom
            lien: 'Frere', // TODO: Lien de parente
            profession: 'Etudiant', // TODO: Profession
            photo: 'assets/images/frere.jpg', // TODO: Chemin de la photo
          ),

          // TODO: Pour ajouter un autre membre, copie-colle un bloc _carteMembre(...) ci-dessus
        ],
      ),
    );
  }
}