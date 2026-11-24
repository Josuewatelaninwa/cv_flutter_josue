import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';

class FamillePage extends StatefulWidget {
  const FamillePage({super.key});

  @override
  State<FamillePage> createState() => _FamillePageState();
}

class _FamillePageState extends State<FamillePage> {
  final ApiService _api = ApiService.instance;
  List<FamilyMember> _membres = [];
  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _chargerMembres();
  }

  Future<void> _chargerMembres() async {
    setState(() {
      _chargement = true;
      _erreur = null;
    });
    try {
      final membres = await _api.getFamilyMembers();
      if (!mounted) return;
      setState(() {
        _membres = membres;
        _chargement = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _erreur = error.message;
        _chargement = false;
      });
    }
  }

  Future<void> _ouvrirFormulaire({FamilyMember? membre}) async {
    final enregistre = await showDialog<bool>(
      context: context,
      builder: (_) => _MembreFormDialog(membre: membre),
    );
    if (enregistre == true && mounted) await _chargerMembres();
  }

  Future<void> _supprimerMembre(FamilyMember membre) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text('La fiche de ${membre.fullName} sera supprimée.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirme != true || !mounted) return;
    try {
      await _api.deleteFamilyMember(membre.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Membre supprimé.')));
      await _chargerMembres();
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      'Membres chargés depuis votre API.',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),
              IconButton.filled(
                tooltip: 'Ajouter un membre',
                onPressed: () => _ouvrirFormulaire(),
                icon: const Icon(Icons.person_add_alt_1),
              ),
            ],
          ),
        ),
        Expanded(child: _contenu()),
      ],
    );
  }

  Widget _contenu() {
    if (_chargement) return const Center(child: CircularProgressIndicator());
    if (_erreur != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined, size: 44),
              const SizedBox(height: 12),
              Text(_erreur!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _chargerMembres,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }
    if (_membres.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Aucun membre pour le moment.\nTouchez + pour en ajouter.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _chargerMembres,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: _membres.length,
        itemBuilder: (context, index) {
          final membre = _membres[index];
          return Card(
            color: Colors.white,
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(14, 8, 4, 8),
              leading: _PhotoMembre(imageUrl: membre.imageUrl, radius: 29),
              title: Text(
                membre.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  '${membre.parente} · Né(e) le ${membre.dateNaissance}\n'
                  'Lieu : ${membre.lieuNaissance}',
                ),
              ),
              isThreeLine: true,
              trailing: PopupMenuButton<String>(
                tooltip: 'Actions',
                onSelected: (action) {
                  if (action == 'modifier') {
                    _ouvrirFormulaire(membre: membre);
                  } else {
                    _supprimerMembre(membre);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'modifier', child: Text('Modifier')),
                  PopupMenuItem(value: 'supprimer', child: Text('Supprimer')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MembreFormDialog extends StatefulWidget {
  const _MembreFormDialog({this.membre});

  final FamilyMember? membre;

  @override
  State<_MembreFormDialog> createState() => _MembreFormDialogState();
}

class _MembreFormDialogState extends State<_MembreFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  late final TextEditingController _nom;
  late final TextEditingController _postnom;
  late final TextEditingController _prenom;
  late final TextEditingController _lieu;
  late final TextEditingController _date;
  late final TextEditingController _parente;
  XFile? _image;
  Uint8List? _imageBytes;
  bool _enregistrement = false;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    final membre = widget.membre;
    _nom = TextEditingController(text: membre?.nom ?? '');
    _postnom = TextEditingController(text: membre?.postnom ?? '');
    _prenom = TextEditingController(text: membre?.prenom ?? '');
    _lieu = TextEditingController(text: membre?.lieuNaissance ?? '');
    _date = TextEditingController(text: membre?.dateNaissance ?? '');
    _parente = TextEditingController(text: membre?.parente ?? '');
  }

  @override
  void dispose() {
    _nom.dispose();
    _postnom.dispose();
    _prenom.dispose();
    _lieu.dispose();
    _date.dispose();
    _parente.dispose();
    super.dispose();
  }

  Future<void> _choisirPhoto() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1280,
        maxHeight: 1280,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (bytes.length > 2 * 1024 * 1024) {
        if (mounted) {
          setState(() => _erreur = 'La photo doit faire 2 Mo maximum.');
        }
        return;
      }
      if (mounted) {
        setState(() {
          _image = image;
          _imageBytes = bytes;
          _erreur = null;
        });
      }
    } on PlatformException catch (error) {
      if (mounted) {
        setState(() {
          _erreur = error.message ?? 'Impossible de sélectionner cette photo.';
        });
      }
    }
  }

  Future<void> _choisirDate() async {
    final current = DateTime.tryParse(_date.text);
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: current != null && !current.isAfter(now)
          ? current
          : DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (selected != null) {
      _date.text =
          '${selected.year.toString().padLeft(4, '0')}-'
          '${selected.month.toString().padLeft(2, '0')}-'
          '${selected.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _enregistrement = true;
      _erreur = null;
    });
    final fields = <String, String>{
      'nom': _nom.text.trim(),
      'postnom': _postnom.text.trim(),
      'prenom': _prenom.text.trim(),
      'lieu_naissance': _lieu.text.trim(),
      'date_naissance': _date.text.trim(),
      'parente': _parente.text.trim(),
    };
    try {
      if (widget.membre == null) {
        await ApiService.instance.createFamilyMember(fields, image: _image);
      } else {
        await ApiService.instance.updateFamilyMember(
          widget.membre!.id,
          fields,
          image: _image,
        );
      }
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _erreur = error.message;
        _enregistrement = false;
      });
    }
  }

  String? _champObligatoire(String? value, int limite) {
    if (value == null || value.trim().isEmpty) return 'Champ obligatoire.';
    if (value.trim().length > limite) {
      return 'Maximum $limite caractères.';
    }
    return null;
  }

  String? _validerDate(String? value) {
    if (value == null || value.trim().isEmpty) return 'Champ obligatoire.';
    final formatted = value.trim();
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(formatted)) {
      return 'Utilisez le format AAAA-MM-JJ.';
    }
    final date = DateTime.tryParse(formatted);
    if (date == null ||
        '${date.year.toString().padLeft(4, '0')}-'
                '${date.month.toString().padLeft(2, '0')}-'
                '${date.day.toString().padLeft(2, '0')}' !=
            formatted) {
      return 'Date invalide.';
    }
    if (date.isAfter(DateTime.now())) return 'La date ne peut pas être future.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final membre = widget.membre;
    return AlertDialog(
      title: Text(membre == null ? 'Ajouter un membre' : 'Modifier un membre'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_image != null)
                  CircleAvatar(
                    radius: 38,
                    backgroundImage: MemoryImage(_imageBytes!),
                  )
                else
                  _PhotoMembre(imageUrl: membre?.imageUrl, radius: 38),
                TextButton.icon(
                  onPressed: _enregistrement ? null : _choisirPhoto,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(
                    _image == null
                        ? 'Choisir une photo (2 Mo max)'
                        : _image!.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _champ(_nom, 'Nom', 50),
                _champ(_postnom, 'Postnom', 50),
                _champ(_prenom, 'Prénom', 50),
                _champ(_lieu, 'Lieu de naissance', 100),
                TextFormField(
                  controller: _date,
                  readOnly: true,
                  validator: _validerDate,
                  onTap: _enregistrement ? null : _choisirDate,
                  decoration: const InputDecoration(
                    labelText: 'Date de naissance',
                    hintText: 'AAAA-MM-JJ',
                    suffixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                _champ(_parente, 'Lien de parenté (ex. Père)', 50),
                if (_erreur != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _erreur!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _enregistrement ? null : () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _enregistrement ? null : _enregistrer,
          child: _enregistrement
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Enregistrer'),
        ),
      ],
    );
  }

  Widget _champ(TextEditingController controller, String label, int limite) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        controller: controller,
        validator: (value) => _champObligatoire(value, limite),
        maxLength: limite,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class _PhotoMembre extends StatelessWidget {
  const _PhotoMembre({required this.imageUrl, required this.radius});

  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final placeholder = Icon(
      Icons.person,
      size: radius,
      color: Theme.of(context).colorScheme.primary,
    );
    if (imageUrl == null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: placeholder,
      );
    }

    final diameter = radius * 2;
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: ClipOval(
        child: SizedBox(
          width: diameter,
          height: diameter,
          child: Image.network(
            imageUrl!,
            width: diameter,
            height: diameter,
            fit: BoxFit.cover,
            webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
            errorBuilder: (_, _, _) => Center(child: placeholder),
          ),
        ),
      ),
    );
  }
}
