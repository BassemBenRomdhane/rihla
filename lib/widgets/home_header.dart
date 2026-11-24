import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rihla/providers/reglages_model.dart';

class HomeHeader extends StatelessWidget {
  final String prenom;

  const HomeHeader({super.key, required this.prenom});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme; // la palette Material 3 du thème
    final estSombre = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ahlan, $prenom 👋',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Où partez-vous\n aujourd'hui ?",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(estSombre ? Icons.light_mode : Icons.dark_mode),
          onPressed: () => context.read<ReglagesModel>().basculerTheme(),
        ),
        CircleAvatar(
          radius: 26,
          backgroundColor: cs.primaryContainer,
          child: Text(
            prenom[0].toUpperCase(),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: cs.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }
}