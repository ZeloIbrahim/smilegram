import "package:flutter/material.dart";

class StatCard extends StatelessWidget {
  final IconData icone;
  final String valeur;
  final String label;

  const StatCard({super.key, required this.icone, required this.valeur, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 20, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 6),
            Text(valeur, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 2),
            Text(label, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
