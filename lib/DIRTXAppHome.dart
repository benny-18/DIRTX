import 'package:dirtx/main.dart';
import 'package:flutter/material.dart';
import 'package:dirtx/DIRTXConfigurationPanel.dart';
import 'package:dirtx/DIRTXAboutCard.dart';

class DIRTXAppHome extends StatefulWidget {
  const DIRTXAppHome({super.key});

  @override
  State<DIRTXAppHome> createState() => _DIRTXAppHomeState();
}

class _DIRTXAppHomeState extends State<DIRTXAppHome> with SingleTickerProviderStateMixin {

  String appVersion = "v1.0";

  String hasConn = "true";
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

      // ==================================================== APPBAR ======================================================================

    appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox.square(dimension: 4),
              Image(
                image: AssetImage('assets/images/dirtx-logo.png'),
                width: 130,
              ),
              SizedBox.square(dimension: 10),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size.square(36),
                    side: BorderSide(color: DIRTXAppColorScheme.rustVibrant, width: 2, strokeAlign: BorderSide.strokeAlignCenter),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DIRTXAboutCard();
                        }
                    );
                  },
                  child: Text(appVersion, style: TextStyle(fontWeight: FontWeight.bold, color: DIRTXAppColorScheme.rustVibrant),)
              ),
          ],),
        ),

        actions: [

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Row(
              children: [
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

                SizedBox.square(dimension: 12,),

                Padding(padding: EdgeInsets.only(top: 18, bottom: 18), child: VerticalDivider(thickness: 2, color: DIRTXAppColorScheme.greyLight)),

                SizedBox.square(dimension: 12,),

                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: DIRTXAppColorScheme.rustMedium,
                      fixedSize: Size.fromHeight(36),
                      side: BorderSide(color: DIRTXAppColorScheme.greyLight, width: 2, strokeAlign: BorderSide.strokeAlignCenter),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    ),
                    onPressed: (){},
                    child: Row(children: [
                      Icon(Icons.add_link_sharp, size: 16),
                      SizedBox.square(dimension: 6),
                      Text("Connect device")
                    ],)
                ),

                SizedBox.square(dimension: 16,),

                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xCCC36145),
                      fixedSize: Size.fromHeight(36),
                      side: BorderSide(color: DIRTXAppColorScheme.greyLight, width: 2, strokeAlign: BorderSide.strokeAlignCenter),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    ),
                    onPressed: (){},
                    child: Row(children: [
                      Icon(Icons.history_rounded, size: 16),
                      SizedBox.square(dimension: 6),
                      Text("History")
                    ],)
                ),

                SizedBox.square(dimension: 16,),

                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                        fixedSize: Size.square(36),
                        side: BorderSide(color: DIRTXAppColorScheme.greyLight, width: 2, strokeAlign: BorderSide.strokeAlignCenter),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: EdgeInsets.zero,
                    ),
                    onPressed: (){},
                    child: Icon(Icons.more_vert_rounded, size: 24, color: DIRTXAppColorScheme.greyDark,)
                ),

                SizedBox.square(dimension: 24,),
              ],
            ),
          )
        ],
      ),

      // ==================================================== BODY ======================================================================

      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 6, 24, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: double.infinity),
            child: Row(
              children: [

                Expanded(child: Container(
                  padding: EdgeInsets.zero,
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: DIRTXAppColorScheme.rustVibrant, width: 4.0, strokeAlign: BorderSide.strokeAlignOutside),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Image(
                    fit: BoxFit.cover,
                    // image: AssetImage('assets/images/bridgewaterenviro.com-red-tide-1.jpeg'),
                    image: AssetImage('assets/images/test.jpg')
                  )
                )),

                SizedBox.square(dimension: 24),

                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 280),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: DIRTXAppColorScheme.greyLight, width: 2.0, strokeAlign: BorderSide.strokeAlignOutside),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
                      child: DIRTXConfigurationPanel()
                    ),
                  )
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
