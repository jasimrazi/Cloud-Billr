import 'package:cloud_billr/controllers/providers.dart';
import 'package:cloud_billr/controllers/theme_provider.dart';
import 'package:cloud_billr/utils/color_scheme.dart';
import 'package:cloud_billr/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/responsive.dart';

late AppColorScheme appColors; // global instance

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  ThemeMode initialThemeMode = ThemeMode.system;
  try {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt('theme_mode_pref');
    if (modeIndex != null) {
      initialThemeMode = ThemeMode.values[modeIndex];
    }
  } catch (e) {
    debugPrint('Error loading theme preference on launch: $e');
  }

  runApp(MultiProvider(
    providers: createProviders(initialThemeMode: initialThemeMode),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Inter',
      ),
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final brightness = themeProvider.themeMode == ThemeMode.system
            ? MediaQuery.of(context).platformBrightness
            : (themeProvider.themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light);
        appColors = brightness == Brightness.dark ? AppColorScheme.dark : AppColorScheme.light;
        return child!;
      },
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      
      home: Scaffold(
        body: Center(
          child: HomeScreen(),
        ),
      ),
    );
  }
}
