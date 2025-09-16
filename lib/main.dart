import 'package:dirtx/DIRTXAppHome.dart';
import 'package:dirtx/DIRTXSplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WindowManager.instance.ensureInitialized();
  runApp(DIRTXMain());
  
  windowManager.setTitleBarStyle(TitleBarStyle.hidden);
  windowManager.center(animate: true);

  // windowManager.waitUntilReadyToShow().then((_) async {
  //   await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
  //   await windowManager.center(animate: true);
  // });
}

class DIRTXAppColorScheme {

  // DIRTX Colors
  static const Color rustLight = Color(0xFFFEF8EB);
  static const Color rustMedium = Color(0xFFC36145);
  static const Color rustVibrant = Color(0xFFAF2F0D);

  static const Color greyLight = Color(0xFFD4D4D4);
  static const Color greyDark = Color(0xFF3A3A3A);
}

class DIRTXMain extends StatelessWidget {
  const DIRTXMain({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: DIRTXAppColorScheme.rustLight,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: DIRTXAppColorScheme.rustVibrant),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          }
        ),
        fontFamily: "SpaceGrotesk",
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontWeight: FontWeight.w400), // regular
          bodyMedium: TextStyle(fontWeight: FontWeight.w500, color: DIRTXAppColorScheme.greyDark), // light
          titleLarge: TextStyle(fontWeight: FontWeight.w700), // bold
        ),
      ),
      themeAnimationStyle: AnimationStyle(curve: Curves.easeInOutCubicEmphasized, duration: Duration(seconds: 2)),
      home: DIRTXSplashScreen(),
    );
  }
}