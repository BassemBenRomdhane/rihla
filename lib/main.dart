import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:rihla/providers/favoris_model.dart';
import 'package:rihla/widgets/HomeScreen.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavorisModel(),
      child: const RihlaApp(),
    ),
  );
}

class RihlaApp extends StatelessWidget {
  const RihlaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rihla',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0E7C86)),
      ),
      home: const HomeScreen(),
    );
  }
}