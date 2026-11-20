import 'package:flutter/material.dart';
import 'famille_page.dart';
import 'contact_page.dart';

// Conteneur principal avec barre de navigation en bas pour passer d'une page a l'autre
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _indexActuel = 0;

  // Liste des 3 pages accessibles apres connexion
  final List<Widget> _pages = const [
    CvPage(),       // Page (2) Accueil / CV
    FamillePage(),  // Page (3) Famille
    ContactPage(),  // Page (4) Contact
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_indexActuel],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexActuel,
        onTap: (index) {
          setState(() {
            _indexActuel = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'CV',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom),
            label: 'Famille',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_phone),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}

// Page (2) d'accueil : CV complet
class CvPage extends StatelessWidget {
  const CvPage({super.key});

  // Petit widget reutilisable pour les titres de sections du CV
  Widget _titreSection(String titre) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, bottom: 6.0),
      child: Text(
        titre,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO: Remplace par le titre de ton CV
        title: const Text('Mon CV'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo + Nom + Titre / Profil
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TODO: Remplace 'assets/images/profil.jpg' par le vrai chemin de ta photo
                const CircleAvatar(
                  radius: 42,
                  backgroundImage: AssetImage('assets/images/profil.jpg'),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      // TODO: Verifie ou complete ton nom complet
                      Text(
                        'BARAKA Watelaninwa Josue',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      // TODO: Remplace par ton titre ou profil (ex: Etudiant en Informatique / Developpeur Junior)
                      Text('Etudiant en Informatique - Debutant Flutter'),
                      SizedBox(height: 4),
                      // TODO: Remplace par ta date et ton lieu de naissance reels
                      Text('Ne le 15 Janvier 2004 a Bukavu'),
                    ],
                  ),
                ),
              ],
            ),

            // Resume / Profil
            _titreSection('Profil'),
            // TODO: Remplace ce texte par ta vraie presentation / objectif professionnel
            const Text(
              'Jeune etudiant motive, ne a Bukavu, debutant en programmation et passionne par le developpement d\'applications mobiles avec Flutter.',
            ),

            // Formation
            _titreSection('Formation'),
            // TODO: Remplace par tes vrais diplomes, etablissements et annees
            const Text('- Diplome d\'Etat / Licence en cours : [Nom de ton ecole ou universite] ([Annees])'),
            const Text('- Initiation au developpement mobile avec Flutter : [Nom de ta formation/cours] ([Annee])'),

            // Experiences (stages, projets, emplois)
            _titreSection('Experiences (Stages, Projets, Emplois)'),
            // TODO: Remplace par tes vrais stages, projets academiques/personnels ou emplois
            const Text('- Projet academique : Application mobile CV en Flutter ([Annee])'),
            const Text('- Stage / Emploi : [Intitule du poste ou stage] chez [Nom de l\'organisation] ([Periode])'),

            // Competences techniques
            _titreSection('Competences techniques'),
            // TODO: Remplace par tes vraies competences techniques (langages, outils, bureautique, etc.)
            const Text('- Langages / Frameworks : Dart, Flutter (bases), HTML/CSS (a completer)'),
            const Text('- Outils : Git, GitHub, VS Code / Android Studio, Microsoft Office'),

            // Competences linguistiques
            _titreSection('Competences linguistiques'),
            // TODO: Remplace par les langues que tu parles et ton vrai niveau
            const Text('- Francais : [Niveau, ex: Courant / Intermediaire]'),
            const Text('- Swahili : [Niveau, ex: Langue maternelle / Courant]'),
            const Text('- Anglais : [Niveau, ex: Notions / Intermediaire]'),

            // Centres d'interet
            _titreSection('Centres d\'interet'),
            // TODO: Remplace par tes vrais centres d'interet
            const Text('- Programmation et nouvelles technologies, lecture, sport, musique'),
          ],
        ),
      ),
    );
  }
}