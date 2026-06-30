import 'package:cloud_billr/controllers/providers.dart';
import 'package:cloud_billr/utils/color_scheme.dart';
import 'package:cloud_billr/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

late AppColorScheme appColors; // global instance

void main() {
  runApp(MultiProvider(
    providers: providers,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        final brightness = MediaQuery.of(context).platformBrightness;
        appColors = brightness == Brightness.dark? AppColorScheme.dark : AppColorScheme.light;
        return child!;
      },
      themeMode: ThemeMode.system,
      
      home: Scaffold(
        body: Center(
          child: HomeScreen(),
        ),
      ),
    );
  }
}
