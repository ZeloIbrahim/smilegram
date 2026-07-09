// defi photo du jour

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "../models/user_profile.dart";
import "../services/api_service.dart";
import "../widgets/stat_card.dart";

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _api = ApiService();
  final _picker = ImagePicker();

  UserProfile? _profil;
  bool _chargement = true;
  bool _envoiEnCours = false;
  bool _dejaPosteAujourdHui = false;
  String? _erreurChargement;

  @override
  void initState() {
    super.initState();
    _chargerProfil();
  }

  Future<void> _chargerProfil() async {
    setState(() {
      _chargement = true;
      _erreurChargement = null;
    });
    try {
      final profil = await _api.getProfil();
      setState(() {
        _profil = profil;
        _chargement = false;
      });
    } catch (e) {
      setState(() {
        _erreurChargement = "Impossible de charger ton profil.";
        _chargement = false;
      });
    }
  }

  Future<void> _choisirEtEnvoyerPhoto(ImageSource source) async {
    final xfile = await _picker.pickImage(source: source, imageQuality: 85);
    if (xfile == null) return;

    setState(() => _envoiEnCours = true);
    try {
      final bytes = await xfile.readAsBytes();
      final resultat = await _api.postPhoto(photoBytes: bytes, filename: xfile.name);
      final profilActuel = _profil!;
      setState(() {
        _dejaPosteAujourdHui = true;
        _profil = UserProfile(
          id: profilActuel.id,
          email: profilActuel.email,
          username: profilActuel.username,
          prenom: profilActuel.prenom,
          nom: profilActuel.nom,
          photoProfil: profilActuel.photoProfil,
          pointsTotal: resultat["points_total"] as int,
          streakActuel: resultat["streak_actuel"] as int,
          meilleurStreak: resultat["meilleur_streak"] as int,
        );
      });
    } catch (e) {
      final message = e.toString().replaceFirst("Exception: ", "");
      if (message.contains("deja poste")) {
        setState(() => _dejaPosteAujourdHui = true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _envoiEnCours = false);
    }
  }

  void _afficherChoixSource() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text("Prendre une photo"),
              onTap: () {
                Navigator.pop(context);
                _choisirEtEnvoyerPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text("Choisir depuis la galerie"),
              onTap: () {
                Navigator.pop(context);
                _choisirEtEnvoyerPhoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smilegram"),
        actions: [
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: _chargement
          ? const Center(child: CircularProgressIndicator())
          : _erreurChargement != null
              ? Center(child: Text(_erreurChargement!))
              : RefreshIndicator(
                  onRefresh: _chargerProfil,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _carteDefiDuJour(),
                      const SizedBox(height: 16),
                      _rangeeStatistiques(),
                    ],
                  ),
                ),
    );
  }

  Widget _carteDefiDuJour() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              _dejaPosteAujourdHui ? Icons.check_circle_outline : Icons.camera_alt_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 14),
            Text(
              _dejaPosteAujourdHui ? "Photo du jour postee !" : "Ton sourire du jour",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              _dejaPosteAujourdHui
                  ? "Reviens demain pour continuer ta serie."
                  : "Poste une photo souriante pour garder ta serie.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (!_dejaPosteAujourdHui) ...[
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: _envoiEnCours ? null : _afficherChoixSource,
                icon: _envoiEnCours
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.camera_alt),
                label: Text(_envoiEnCours ? "Envoi..." : "Prendre une photo"),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _rangeeStatistiques() {
    final profil = _profil!;
    return Row(
      children: [
        Expanded(child: StatCard(icone: Icons.local_fire_department_outlined, valeur: "${profil.streakActuel}", label: "jours de suite")),
        const SizedBox(width: 10),
        Expanded(child: StatCard(icone: Icons.star_outline, valeur: "${profil.pointsTotal}", label: "points")),
        const SizedBox(width: 10),
        Expanded(child: StatCard(icone: Icons.emoji_events_outlined, valeur: "${profil.meilleurStreak}", label: "record")),
      ],
    );
  }
}
