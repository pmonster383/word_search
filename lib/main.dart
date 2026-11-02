import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/services/storage_service.dart';
import 'screens/home_screen.dart';
import 'state/game_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  // Prefer portrait orientation for mobile word search experience
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const WordSearchApp());
}

class WordSearchApp extends StatefulWidget {
  const WordSearchApp({super.key});

  @override
  State<WordSearchApp> createState() => _WordSearchAppState();
}

class _WordSearchAppState extends State<WordSearchApp> {
  late final GameState _gameState;

  @override
  void initState() {
    super.initState();
    _gameState = GameState();
  }

  @override
  void dispose() {
    _gameState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Search Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: HomeScreen(gameState: _gameState),
    );
  }
}
