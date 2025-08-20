import 'package:cloud_billr/controllers/providers.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        primaryColor: AppColors.primaryColorLight, // Light mode primary color
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryColorLight,
          secondary: AppColors.secondaryColorLight,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryColorDark, // Dark mode primary color
        colorScheme: ColorScheme.dark(
          primary: AppColors.primaryColorDark,
          secondary: AppColors.secondaryColorDark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: Center(
          child: HomeScreen(),
        ),
      ),
    );
  }
}
