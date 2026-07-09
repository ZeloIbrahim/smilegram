//  profil + deconnection 

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "../models/user_profile.dart";
import "../services/api_service.dart";
import "../services/auth_storage.dart";
import "../widgets/stat_card.dart";

class AccountScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const AccountScreen({super.key, required this.onLogout});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _api = ApiService();
  final _picker = ImagePicker();

  UserProfile? _profil;
  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    try {
      final profil = await _api.getProfil();
      setState(() {
        _profil = profil;
        _chargement = false;
      });
    } catch (e) {
      setState(() => _chargement = false);
    }
  }

  Future<void> _changerPhotoProfil() async {
    final xfile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (xfile == null) return;

    final bytes = await xfile.readAsBytes();
    try {
      final profil = await _api.updateProfil(photoBytes: bytes, filename: xfile.name);
      setState(() => _profil = profil);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la mise a jour de la photo")),
        );
      }
    }
  }

  Future<void> _deconnexion() async {
    await AuthStorage.clearToken();
    widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    if (_chargement) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final profil = _profil;
    if (profil == null) {
      return const Scaffold(body: Center(child: Text("Impossible de charger le profil.")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Compte")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: GestureDetector(
              onTap: _changerPhotoProfil,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundImage: profil.photoProfil != null
                        ? NetworkImage("${ApiService.baseUrl}/uploads/${profil.photoProfil}")
                        : null,
                    child: profil.photoProfil == null ? const Icon(Icons.person, size: 40) : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.edit, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text("${profil.prenom} ${profil.nom}", textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 2),
          Text("@${profil.username}", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: StatCard(icone: Icons.local_fire_department_outlined, valeur: "${profil.streakActuel}", label: "serie")),
              const SizedBox(width: 10),
              Expanded(child: StatCard(icone: Icons.emoji_events_outlined, valeur: "${profil.meilleurStreak}", label: "record")),
              const SizedBox(width: 10),
              Expanded(child: StatCard(icone: Icons.star_outline, valeur: "${profil.pointsTotal}", label: "points")),
            ],
          ),
          const SizedBox(height: 28),
          OutlinedButton.icon(
            onPressed: _deconnexion,
            icon: const Icon(Icons.logout),
            label: const Text("Se deconnecter"),
          ),
        ],
      ),
    );
  }
}
