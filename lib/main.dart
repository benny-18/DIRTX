import 'package:dirtx/DIRTXAppHome.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DIRTXMain());
}

class DIRTXMain extends StatelessWidget {
  const DIRTXMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 175, 47, 13)),
        fontFamily: "SpaceGrotesk",
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontWeight: FontWeight.w400), // regular
          bodyMedium: TextStyle(fontWeight: FontWeight.w300), // light
          titleLarge: TextStyle(fontWeight: FontWeight.w700), // bold
        ),
      ),
      home: const DIRTXAppHome(),
    );
  }
}