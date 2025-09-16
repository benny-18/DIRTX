import 'dart:io';
import 'dart:ui';

import 'package:dirtx/DIRTXAppHome.dart';
import 'package:dirtx/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:window_manager/window_manager.dart';

class DIRTXSplashScreen extends StatefulWidget {
  const DIRTXSplashScreen({super.key});

  @override
  State<DIRTXSplashScreen> createState() => _DIRTXSplashScreenState();
}

class _DIRTXSplashScreenState extends State<DIRTXSplashScreen> {

  bool _serverOk = false;

  @override
  void initState() {
    super.initState();

    windowManager.setSize(Size(920, 480));
    windowManager.setResizable(false);
    windowManager.center(animate: true);

    checkServerAndNavigate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkServerAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    try {
      final response = await http.get(Uri.parse("http://127.0.0.1:5000/hello"))
          .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200 && response.body.contains("I am DIRTX.")) {
        setState(() => _serverOk = true);

        await windowManager.minimize();

        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DIRTXAppHome()),
          );
        }

        await windowManager.restore();
      }
    } catch (e) {
      debugPrint("Server check failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                spacing: 18,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 180, child: Image(image: AssetImage('assets/images/dirtx-logo.png'))),
                      SizedBox.square(dimension: 16),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: Size.square(36),
                            side: BorderSide(color: DIRTXAppColorScheme.rustVibrant, width: 2, strokeAlign: BorderSide.strokeAlignCenter),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: (){},
                          child: Text("v1.0", style: TextStyle(fontWeight: FontWeight.bold, color: DIRTXAppColorScheme.rustVibrant),)
                      ),
                    ],
                  ),
                  const Text(style: TextStyle(color: DIRTXAppColorScheme.greyDark, fontSize: 14), textAlign: TextAlign.justify, "DIRTX (Drone Imaging for Red Tide Detection Using AI-Based and Machine Learning-Powered System for Tacloban Coastal Areas) is an AI-powered application developed to assist in the early detection of harmful algal blooms (HABs), commonly known as red tide, in coastal waters."),
                  // const Text("J. Pelpinosas, M. Masubay, K. Aguinalde, C. Labarro", style: TextStyle(color: DIRTXAppColorScheme.greyDark)),

                  SizedBox.square(dimension: 2),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: [
                      SizedBox(
                        // width: 320,
                          child: LinearProgressIndicator(
                            minHeight: 24,
                            borderRadius: BorderRadius.circular(16),
                            color: DIRTXAppColorScheme.rustMedium,
                          )
                      ),
                      Row(
                        children: [
                          Icon(Icons.hourglass_top_rounded, size: 17, color: DIRTXAppColorScheme.rustVibrant,),
                          SizedBox.square(dimension: 8),
                          Text(_serverOk ? "Connecting to backend..." : "Waiting for DIRTX backend...", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: DIRTXAppColorScheme.rustMedium)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox.square(dimension: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: Size.fromHeight(36),
                            foregroundColor: Colors.white,
                            backgroundColor: DIRTXAppColorScheme.rustMedium,
                            side: BorderSide(color: DIRTXAppColorScheme.greyLight, width: 0, strokeAlign: BorderSide.strokeAlignCenter),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: (){
                            exit(0);
                          },
                          child:
                          Text("Close app")
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.only(top: 24, right: 24, bottom: 24),
              child: Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: DIRTXAppColorScheme.rustMedium, width: 4.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Image(
                      height: double.infinity,
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/bridgewaterenviro.com-red-tide-1.jpeg"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: const Text("Image courtesy of Bridgewater Environmental\nServices. http://www.bridgewaterenviro.com", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w100)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
