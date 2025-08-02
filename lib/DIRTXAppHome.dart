import 'package:dirtx/main.dart';
import 'package:flutter/material.dart';

class DIRTXAppHome extends StatefulWidget {
  const DIRTXAppHome({super.key});

  @override
  State<DIRTXAppHome> createState() => _DIRTXAppHomeState();
}

class _DIRTXAppHomeState extends State<DIRTXAppHome> with SingleTickerProviderStateMixin {

  String appVersion = "v1.0";

  String hasConn = "false";
  // String deviceName = "DroidCamX (Benny's Pixel 6)";
  String deviceName = "DJI Mini 4 Pro (Wi-Fi Direct)";

  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();

    _blinkController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _blinkAnimation = Tween<double>(begin: 0.3125, end: 1.0).animate(_blinkController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,

        title: Row(
          children: [
            Image(
              image: AssetImage('assets/images/dirtx-logo.png'),
              width: 130,
            ),
            SizedBox.square(dimension: 10),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  fixedSize: Size.square(40),
                  side: BorderSide(color: DIRTXAppColorScheme.rustVibrant, width: 2, strokeAlign: BorderSide.strokeAlignCenter),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.zero,
                ),
                onPressed: (){},
                child: Text(appVersion, style: TextStyle(fontWeight: FontWeight.bold, color: DIRTXAppColorScheme.rustVibrant),)
            ),
        ],),

        actions: [

          Stack(
              children: [
                Visibility(
                  visible: hasConn == "false",
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        AnimatedBuilder(animation: _blinkAnimation, builder: (context, child) { return Opacity(opacity: _blinkAnimation.value, child: Icon(Icons.fiber_manual_record_rounded, size: 16, color: Colors.red,),);},),
                        SizedBox.square(dimension: 8,),
                        Text("No connection", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),)
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: hasConn == "true",
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        AnimatedBuilder(animation: _blinkAnimation, builder: (context, child) { return Opacity(opacity: _blinkAnimation.value, child: Icon(Icons.fiber_manual_record_rounded, size: 16, color: Colors.green,),);},),
                        SizedBox.square(dimension: 8,),
                        Text.rich(
                          TextSpan(
                            text: "Connected to ",
                            style: TextStyle(color: Colors.black54), // Default style
                            children: [
                              TextSpan(
                                text: deviceName,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: hasConn == "fromImport",
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        AnimatedBuilder(animation: _blinkAnimation, builder: (context, child) { return Opacity(opacity: _blinkAnimation.value, child: Icon(Icons.fiber_manual_record_rounded, size: 16, color: Colors.green,),);},),
                        SizedBox.square(dimension: 8,),
                        Text("From file import", style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ),
              ]
          ),

          SizedBox.square(dimension: 16,),

          Padding(padding: EdgeInsets.only(top: 34, bottom: 34), child: VerticalDivider(thickness: 2, color: DIRTXAppColorScheme.greyLight)),

          SizedBox.square(dimension: 16,),

          OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: DIRTXAppColorScheme.rustMedium,
                fixedSize: Size.fromHeight(40),
                side: BorderSide(color: DIRTXAppColorScheme.greyLight, width: 2, strokeAlign: BorderSide.strokeAlignCenter),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              ),
              onPressed: (){},
              child: Text("Connect device")
          ),

          SizedBox.square(dimension: 16,),

          OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                  fixedSize: Size.square(40),
                  side: BorderSide(color: DIRTXAppColorScheme.greyLight, width: 2, strokeAlign: BorderSide.strokeAlignCenter),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.zero,
              ),
              onPressed: (){},
              child: Icon(Icons.more_vert_rounded, size: 24, color: DIRTXAppColorScheme.greyDark,)
          ),

          SizedBox.square(dimension: 24,)
        ],
      ),

      body: Center(
        child: Text("Hello world!"),
      )
    );
  }
}
