
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;

  const SectionTitle({
    super.key,
    required this.title,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),

        if (action != null)
          TextButton(
            onPressed: () {
              // Action à définir
            },
            child: Text(action!),
          ),
      ],
    );
  }
}