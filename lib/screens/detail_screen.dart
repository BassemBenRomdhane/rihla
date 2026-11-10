import 'package:flutter/material.dart';

// TODO: adjust these imports to match your project's package name / paths.
import '../models/destination.dart';
import '../widgets/favorite_button.dart';
import 'reservation_screen.dart';
import '../models/reservation.dart';
import '../services/api_service.dart';
class DetailScreen extends StatefulWidget {
  final Destination destination;

  const DetailScreen({super.key, required this.destination});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _travelers = 2;
  Future<void> _reserver() async {
    final reservation = await Navigator.push<Reservation>(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationScreen(
          destination: widget.destination,
          voyageurs: _travelers,
        ),
      ),
    );

    // TODO 3 : retour sans valider -> rien à faire
    if (reservation == null) return;
    // TODO 4 : l'écran a pu être retiré pendant l'attente
    if (!mounted) return;
    final String id;
    try {
      id = await ApiService.creerReservation(reservation);
    } catch (e) {
      if (!mounted) return; //l'utilisateur a pu quitter l'écran 
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    backgroundColor: Colors.red,
    content: const Text('Envoi impossible : json-server est-il lancé ?'),
  ),
);      return;
    }
    if (!mounted) return;
    await showDialog<void>(

      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Réservation confirmée'),
        // TODO 5
        content: Text(
          '$id votre numero de réservation est enregistré.\n\n'
          '${reservation.nom}, votre voyage à ${reservation.destination.nom} '
          'est enregistré.\n\n'
          'Voyageurs : ${reservation.voyageurs}\n'
          'Formule : ${reservation.formule}\n'
          'Total : ${reservation.total} DT\n\n'
          'Une confirmation sera envoyée à ${reservation.email}.',
        ),
        actions: [
          FilledButton(

            onPressed: () => Navigator.pop(context),
            child: const Text('Parfait'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final destination = widget.destination;
    final theme = Theme.of(context);
    final total = destination.prix * _travelers;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header image with overlaid buttons ---
            SizedBox(
              height: 340,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                     Hero(
                        tag: 'image-${destination.nom}',
                        child: Image.asset(destination.image, fit: BoxFit.cover),
                     ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 12,
                    left: 16,
                    child: _RoundWhiteButton(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 12,
                    right: 16,
                    child: _RoundWhiteButton(
                      child: const FavoriteButton(),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Name / region / rating badge ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              destination.nom,
                              style: theme.textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16),
                                const SizedBox(width: 4),
                                Text(destination.region),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star,
                                size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              destination.note.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- Three equal-width info tiles ---
                  Row(
                    children: [
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.schedule,
                          label: 'Durée',
                          value: destination.duree,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.category_outlined,
                          label: 'Catégorie',
                          value: destination.categorie,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.group_outlined,
                          label: 'Description',
                          value: destination.description,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- About ---
                  Text(
                    'À propos',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(destination.description),
                  const SizedBox(height: 24),

                  // --- Travelers selector ---
                  Row(
                    children: [
                      Text(
                        'Voyageurs',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton.outlined(
                        icon: const Icon(Icons.remove),
                        onPressed: _travelers > 1
                            ? () => setState(() => _travelers--)
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '$_travelers',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      IconButton.outlined(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => _travelers++),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // --- Bottom bar: total + reserve ---
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total', style: theme.textTheme.bodySmall),
                  Text(
                    '$total DT',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  onPressed: _reserver,
                  child: const Text('Réserver'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundWhiteButton extends StatelessWidget {
  final Widget child;
  const _RoundWhiteButton({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(child: child),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(height: 6),
          Text(label, style: theme.textTheme.labelSmall),
          Text(
            value,
            style: theme.textTheme.bodySmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}