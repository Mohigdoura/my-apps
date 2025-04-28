import 'package:auth_test/l10n/l10n.dart';
import 'package:auth_test/pages/welcome/welcome_page.dart';
import 'package:auth_test/services/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // IMPORTANT!

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdkaXlneHlxZWd1YmJnaGd0eWZ0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ1NzE4MDksImV4cCI6MjA2MDE0NzgwOX0.oiDt5enmPDMKoLkjAI4arec_-txN0fMkFbfqlMeaAU0",
    url: "https://gdiygxyqegubbghgtyft.supabase.co",
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize the language provider
    Future.microtask(() => ref.read(languageProvider.notifier).initialize());
  }

  @override
  Widget build(BuildContext context) {
    // Watch the language provider to rebuild when locale changes
    final locale = ref.watch(languageProvider);

    return MaterialApp(
      locale: locale,
      supportedLocales: L10n.all,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      title: 'Food Delivery',

      debugShowCheckedModeBanner: false,
      home: AppStartup(),
    );
  }
}
