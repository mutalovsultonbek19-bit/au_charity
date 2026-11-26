import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'state/donation_store.dart';
import 'config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DonationStore.instance.load();
  if (AppConfig.hasSupabase) {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
  }
  runApp(const AuCharityApp());
}

class AuCharityApp extends StatefulWidget {
  const AuCharityApp({super.key});
  @override
  State<AuCharityApp> createState() => _AuCharityAppState();
}

class _AuCharityAppState extends State<AuCharityApp> {
  Locale _locale = const Locale('uz');
  void setLocale(String languageCode) => setState(() => _locale = Locale(languageCode));

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'AU CHARITY',
    debugShowCheckedModeBanner: false,
    locale: _locale,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF145C45),
        primary: const Color(0xFF145C45),
        secondary: const Color(0xFFC7A65A),
        surface: const Color(0xFFF7F8F6),
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F8F6),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF7F8F6),
        foregroundColor: Color(0xFF163D32),
        centerTitle: false,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    home: HomeScreen(locale: _locale, onLocaleChanged: setLocale),
  );
}
