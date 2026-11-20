import 'package:material_ui/material_ui.dart';

import 'contact_page.dart';
import 'famille_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _indexActuel = 0;

  static const _titres = ['Mon CV', 'Ma Famille', 'Mes Coordonnees'];
  static const _pages = [CvPage(), FamillePage(), ContactPage()];

  void _selectionnerPage(int index) {
    setState(() {
      _indexActuel = index;
    });
    Navigator.pop(context);
  }

  void _seDeconnecter() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titres[_indexActuel])),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF153047)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: const [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage('assets/images/profil.jpg'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BARAKA Watelaninwa Josue',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Etudiant en Informatique',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _elementMenu(
                icon: Icons.person_outline,
                label: 'Mon CV',
                index: 0,
              ),
              _elementMenu(
                icon: Icons.family_restroom,
                label: 'Ma Famille',
                index: 1,
              ),
              _elementMenu(
                icon: Icons.contact_phone_outlined,
                label: 'Mes Coordonnees',
                index: 2,
              ),
              const Spacer(),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Se deconnecter'),
                iconColor: Theme.of(context).colorScheme.error,
                textColor: Theme.of(context).colorScheme.error,
                onTap: _seDeconnecter,
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _indexActuel, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexActuel,
        onDestinationSelected: (index) {
          setState(() {
            _indexActuel = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'CV',
          ),
          NavigationDestination(
            icon: Icon(Icons.family_restroom),
            label: 'Famille',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_phone_outlined),
            selectedIcon: Icon(Icons.contact_phone),
            label: 'Contact',
          ),
        ],
      ),
    );
  }

  Widget _elementMenu({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: _indexActuel == index,
      selectedColor: Theme.of(context).colorScheme.primary,
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => _selectionnerPage(index),
    );
  }
}

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  Widget _sectionCard(
    BuildContext context, {
    required String titre,
    required IconData icone,
    required List<String> lignes,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icone, color: colorScheme.primary),
                const SizedBox(width: 10),
                Text(
                  titre,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF153047),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...lignes.map(
              (ligne) => Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 9),
                      child: Icon(
                        Icons.circle,
                        size: 7,
                        color: colorScheme.primary,
                      ),
                    ),
                    Expanded(child: Text(ligne)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F766E), Color(0xFF153047)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 43,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 39,
                    backgroundImage: AssetImage('assets/images/profil.jpg'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'BARAKA Watelaninwa Josue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Etudiant en Informatique - Debutant Flutter',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Ne le 15 Janvier 2004 a Bukavu',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            context,
            titre: 'Profil',
            icone: Icons.account_circle_outlined,
            lignes: const [
              'Jeune etudiant motive, ne a Bukavu, debutant en programmation et passionne par le developpement d\'applications mobiles avec Flutter.',
            ],
          ),
          _sectionCard(
            context,
            titre: 'Formation',
            icone: Icons.school_outlined,
            lignes: const [
              'Diplome d\'Etat : LYCEE MADRE ELENA (2022-2023)',
              'Licence en cours : Institut Supérieur d\'informatique et de gestion (2023-2026)',
              'Initiation au developpement mobile avec Flutter : Programmation mobile : flutter (2026)',
            ],
          ),
          _sectionCard(
            context,
            titre: 'Experiences (Stages, Projets, Emplois)',
            icone: Icons.work_outline,
            lignes: const [
              ' Emploi : Techinicien et Ingnieur système chez Green World International (KASOK UNITED)) (2026-Aujourdhui)',
              'Projet academique : Application mobile CV en Flutter (2026)',
              'Formation Pratique : Photographie et Vidéographie (2023-2024)',
              
            ],
          ),
          _sectionCard(
            context,
            titre: 'Competences techniques',
            icone: Icons.code,
            lignes: const [
              'Langages / Frameworks : Dart, Flutter (bases), HTML/CSS (Moyen)',
              'Outils : Git, GitHub, VS Code / Android Studio, Microsoft Office',
            ],
          ),
          _sectionCard(
            context,
            titre: 'Competences linguistiques',
            icone: Icons.translate,
            lignes: const [
              'Francais : Niveau : Intermediaire',
              'Swahili : Niveau: Langue maternelle;',
              'Anglais : Niveau : Notions ',
            ],
          ),
          _sectionCard(
            context,
            titre: 'Centres d\'interet',
            icone: Icons.favorite_border,
            lignes: const [
              'Programmation et nouvelles technologies, lecture, sport, musique',
            ],
          ),
        ],
      ),
    );
  }
}
