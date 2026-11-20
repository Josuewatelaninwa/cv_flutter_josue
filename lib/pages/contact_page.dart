import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO: Remplace par le titre souhaite pour la page contact
        title: const Text('Mes Coordonnees'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.phone),
              title: Text('Telephone'),
              // TODO: Remplace par ton vrai numero de telephone
              subtitle: Text('+243 XXX XXX XXX'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.email),
              title: Text('E-mail'),
              // TODO: Remplace par ta vraie adresse e-mail
              subtitle: Text('josue.exemple@email.com'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Adresse'),
              // TODO: Remplace par ton adresse actuelle (quartier, commune, ville, pays)
              subtitle: Text('Bukavu / Goma, Republique Democratique du Congo'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.work),
              title: Text('LinkedIn'),
              // TODO: Remplace par le lien ou pseudo de ton profil LinkedIn
              subtitle: Text('linkedin.com/in/ton-profil-josue'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.code),
              title: Text('GitHub'),
              // TODO: Remplace par le lien de ton compte GitHub
              subtitle: Text('https://github.com/ton-pseudo-github'),
            ),
          ),
        ],
      ),
    );
  }
}