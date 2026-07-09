// barre du bas 

import "package:flutter/material.dart";
import "home_screen.dart";
import "feed_screen.dart";
import "account_screen.dart";

class MainNavigation extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;

  const MainNavigation({super.key, required this.onToggleTheme, required this.onLogout});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    // IndexedStack garde chaque ecran en memoire (le feed ne recharge pas
    // a chaque fois qu'on revient dessus)
    final ecrans = [
      HomeScreen(onToggleTheme: widget.onToggleTheme),
      const FeedScreen(),
      AccountScreen(onLogout: widget.onLogout),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: ecrans),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: "Accueil"),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: "Pour toi"),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: "Compte"),
        ],
      ),
    );
  }
}
