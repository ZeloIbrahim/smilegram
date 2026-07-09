// verifie si y'a deja connecter au demaarrage 

import "package:flutter/material.dart";
import "../services/auth_storage.dart";
import "auth_screen.dart";
import "main_navigation.dart";

class AuthGate extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const AuthGate({super.key, required this.onToggleTheme});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _chargement = true;
  bool _authentifie = false;

  @override
  void initState() {
    super.initState();
    _verifierSession();
  }

  Future<void> _verifierSession() async {
    final token = await AuthStorage.getToken();
    setState(() {
      _authentifie = token != null;
      _chargement = false;
    });
  }

  void _onAuthSuccess() => setState(() => _authentifie = true);

  void _onLogout() => setState(() => _authentifie = false);

  @override
  Widget build(BuildContext context) {
    if (_chargement) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_authentifie) {
      return AuthScreen(onSuccess: _onAuthSuccess);
    }
    return MainNavigation(onToggleTheme: widget.onToggleTheme, onLogout: _onLogout);
  }
}
