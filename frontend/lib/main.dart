import 'package:flutter/material.dart';
import "services/auth_storage.dart";
import "screens/auth_gate.dart";
import "theme/app_theme.dart";


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
  
  }

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState(){
    super.initState();
    _chargerPreferenceTheme();
  }

  Future<void> _chargerPreferenceTheme() async {
    final sombre = await AuthStorage.getDarkMode();
    setState(() => _themeMode = sombre ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> _basculerTheme() async {
    final nouveauModeSombre = _themeMode == ThemeMode.light;
    setState(() => _themeMode = nouveauModeSombre ? ThemeMode.dark : ThemeMode.light);
    await AuthStorage.setDarkMode(nouveauModeSombre);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smilegram",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      home: AuthGate(onToggleTheme: _basculerTheme),
    );
  }

}

