import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rihla/providers/favoris_model.dart';
import 'package:rihla/providers/reglages_model.dart';
import 'package:rihla/widgets/HomeScreen.dart';

const graine = Color(0xFF00695C);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final reglages = ReglagesModel();
  await reglages.charger();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavorisModel()..charger()),
        ChangeNotifierProvider.value(value: reglages),
      ],
      child: const RihlaApp(),
    ),
  );
}

class RihlaApp extends StatelessWidget {
  const RihlaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sombre = context.select<ReglagesModel, bool>((r) => r.sombre);

    return MaterialApp(
      title: 'Rihla',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: graine)),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: graine,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: sombre ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}