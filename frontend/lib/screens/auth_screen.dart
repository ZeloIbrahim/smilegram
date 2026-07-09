// connextion + inscription , un seul ecran

import "package:flutter/material.dart";
import "../services/api_service.dart";
import "../services/auth_storage.dart";

class AuthScreen extends StatefulWidget {
  final VoidCallback onSuccess;

  const AuthScreen({super.key, required this.onSuccess});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _api = ApiService();

  bool _modeInscription = false;
  bool _chargement = false;
  String? _erreur;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _nomCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _usernameCtrl.dispose();
    _prenomCtrl.dispose();
    _nomCtrl.dispose();
    super.dispose();
  }

  Future<void> _soumettre() async {
    setState(() {
      _chargement = true;
      _erreur = null;
    });

    try {
      final token = _modeInscription
          ? await _api.register(
              email: _emailCtrl.text.trim(),
              password: _passwordCtrl.text,
              username: _usernameCtrl.text.trim(),
              prenom: _prenomCtrl.text.trim(),
              nom: _nomCtrl.text.trim(),
            )
          : await _api.login(email: _emailCtrl.text.trim(), password: _passwordCtrl.text);

      await AuthStorage.saveToken(token);
      widget.onSuccess();
    } catch (e) {
      setState(() => _erreur = e.toString().replaceFirst("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _chargement = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.emoji_emotions_outlined, size: 56, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 12),
                Text("Smilegram", textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 26)),
                const SizedBox(height: 4),
                Text(
                  _modeInscription ? "Cree ton compte" : "Content de te revoir",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 28),

                if (_modeInscription) ...[
                  TextField(controller: _prenomCtrl, decoration: const InputDecoration(labelText: "Prenom")),
                  const SizedBox(height: 12),
                  TextField(controller: _nomCtrl, decoration: const InputDecoration(labelText: "Nom")),
                  const SizedBox(height: 12),
                  TextField(controller: _usernameCtrl, decoration: const InputDecoration(labelText: "Nom d'utilisateur")),
                  const SizedBox(height: 12),
                ],

                TextField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordCtrl,
                  decoration: const InputDecoration(labelText: "Mot de passe"),
                  obscureText: true,
                ),

                if (_erreur != null) ...[
                  const SizedBox(height: 14),
                  Text(_erreur!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                ],

                const SizedBox(height: 22),
                ElevatedButton(
                  onPressed: _chargement ? null : _soumettre,
                  child: _chargement
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(_modeInscription ? "S'inscrire" : "Se connecter"),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() => _modeInscription = !_modeInscription),
                  child: Text(_modeInscription ? "Deja un compte ? Se connecter" : "Pas de compte ? S'inscrire"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
