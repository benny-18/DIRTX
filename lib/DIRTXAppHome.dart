import 'dart:async';
import 'dart:convert';

import 'package:dirtx/DIRTXFootageSelectionCard.dart';
import 'package:dirtx/DIRTXHistoryPanel.dart';
import 'package:dirtx/DIRTXSplashScreen.dart';
import 'package:dirtx/main.dart';
import 'package:dirtx/misc/DIRTXFlaskBackend.dart';
import 'package:dirtx/misc/DIRTXOutputViewer.dart';
import 'package:flutter/material.dart';
import 'package:dirtx/DIRTXConfigurationPanel.dart';
import 'package:dirtx/DIRTXAboutCard.dart';
import 'package:http/http.dart' as http;
import 'package:window_manager/window_manager.dart';
import 'package:mjpeg_stream/mjpeg_stream.dart';

class DIRTXAppHome extends StatefulWidget {
  const DIRTXAppHome({super.key});


  @override
  State<DIRTXAppHome> createState() => _DIRTXAppHomeState();
}

class _DIRTXAppHomeState extends State<DIRTXAppHome> with SingleTickerProviderStateMixin {

  String appVersion = "v1.0";

  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  bool isConfigPanelShown = true;

  @override
  void initState() {
    super.initState();

    windowManager.setResizable(true);
    windowManager.setSize(Size(1200, 690));
    windowManager.setMinimumSize(Size(1200, 690));
    windowManager.center(animate: true);

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

        // leading: GestureDetector(
        //   behavior: HitTestBehavior.translucent,
        //   onPanStart: (_) => windowManager.startDragging(),
        //   child: const Icon(Icons.drag_indicator),
        // ),

        flexibleSpace: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: (_) => windowManager.startDragging(),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Row(
              children: [
                ValueListenableBuilder<String?>(
                  valueListenable: currentConnNotifier,
                  builder: (BuildContext context, String? value, Widget? child) {
                    return Stack(
                        children: [
                          Visibility(
                            visible: currentConn == "none",
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
                            visible: currentConn == "fromDrone",
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  AnimatedBuilder(animation: _blinkAnimation, builder: (context, child) { return Opacity(opacity: _blinkAnimation.value, child: Icon(Icons.fiber_manual_record_rounded, size: 16, color: Colors.green,),);},),
                                  SizedBox.square(dimension: 8,),
                                  Text.rich(
                                    TextSpan(
                                      text: "Live screencast from ",
                                      style: TextStyle(color: Colors.black54), // Default style
                                      children: [
                                        TextSpan(
                                          text: "DJI Fly on Pixel 6",
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
                            visible: currentConn == "fromImport",
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
                    );
                                    },

                ),

                SizedBox.square(dimension: 12,),

                Padding(padding: EdgeInsets.only(top: 18, bottom: 18), child: VerticalDivider(thickness: 2, color: DIRTXAppColorScheme.greyLight)),

                SizedBox.square(dimension: 12,),

                // input footage button
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: DIRTXAppColorScheme.rustMedium,
                      fixedSize: Size.fromHeight(36),
                      side: BorderSide(color: DIRTXAppColorScheme.greyLight, width: 2, strokeAlign: BorderSide.strokeAlignCenter),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    ),
                    onPressed: () async {

                      await setArguments(
                        resolution: resolution,
                        sensitivity: sensitivity,
                        strictness: strictness,
                        border: border,
                        hideLabel: hideLabel,
                        hideConfidence: hideScores,
                      );

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DIRTXFootageSelectionCard();
                        }
                      );
                    },
                    child: Row(children: [
                      Icon(Icons.add_to_queue_rounded, size: 16),
                      SizedBox.square(dimension: 8),
                      Text("Input footage")
                    ],)
                ),

                SizedBox.square(dimension: 16,),

                // history button
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xCCC36145),
                      fixedSize: Size.fromHeight(36),
                      side: BorderSide(color: DIRTXAppColorScheme.greyLight, width: 2, strokeAlign: BorderSide.strokeAlignCenter),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    ),
                    onPressed: (){
                      setState(() {
                        isConfigPanelShown = !isConfigPanelShown;
                      });
                    },
                    child: Row(children: [
                      Icon(Icons.history_rounded, size: 16),
                      SizedBox.square(dimension: 6),
                      Text("History")
                    ],)
                ),

                // SizedBox.square(dimension: 16,),
                //
                // // menu button
                // OutlinedButton(
                //     style: OutlinedButton.styleFrom(
                //       backgroundColor: Colors.white,
                //         fixedSize: Size.square(36),
                //         side: BorderSide(color: DIRTXAppColorScheme.greyLight, width: 2, strokeAlign: BorderSide.strokeAlignCenter),
                //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                //         padding: EdgeInsets.zero,
                //     ),
                //     onPressed: (){},
                //     child: Icon(Icons.more_vert_rounded, size: 24, color: DIRTXAppColorScheme.greyDark,)
                // ),

                // title bar buttons?? (minimize, maximize, close)

                SizedBox.square(dimension: 12,),
                IconButton(
                    onPressed: () {
                      windowManager.minimize();
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Icon(Icons.minimize_rounded, size: 24),
                    )
                ),
                GestureDetector(
                  onSecondaryTap: () {
                    windowManager.center(animate: true);
                  },
                  child: IconButton(
                      onPressed: () async {
                        bool value = await windowManager.isMaximized();
                        if (value = true ) {
                          windowManager.restore();
                        }
                        windowManager.maximize();
                      },
                      icon: Icon(Icons.crop_square_rounded, size: 20)
                  ),
                ),
                IconButton(
                    onPressed: () {
                      // windowManager.setSize(Size(1000, 600), animate: true);
                      windowManager.close();
                    },
                    icon: Icon(Icons.close_rounded, size: 24, color: DIRTXAppColorScheme.rustVibrant)
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
                    borderRadius: BorderRadius.circular(16)
                  ),

                  child: ValueListenableBuilder<String?>(
                    valueListenable: backendOutputDirNotifier,
                    builder: (context, dir, _) {
                      return ValueListenableBuilder<bool>(
                        valueListenable: isLiveFeedNotifier,
                        builder: (context, isLiveFeed, _) {
                          if (isLiveFeed) {
                            // return LiveFeedLoader();
                            return MJPEGStreamScreen(
                              streamUrl: 'http://127.0.0.1:5000/live_infer',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              borderRadius: 15,
                              showLogs: false,
                              timeout: Duration(seconds: 15),
                              showWatermark: false,
                              showLiveIcon: true,
                            );
                          } else if (dir == null) {
                            return Image.asset(
                              'assets/images/no-input-footage-found.png',
                              fit: BoxFit.cover,
                            );
                          } else {
                            return DIRTXOutputViewer(backendOutputDir: dir);
                          }
                        },
                      );
                    },
                  )

                  // child: MJPEGStreamScreen(
                  //   streamUrl: 'http://127.0.0.1:5000/live_infer',
                  //   fit: BoxFit.cover,
                  //   width: double.infinity,
                  //   height: 300,
                  //   borderRadius: 15,
                  //   showLogs: false,
                  //   showWatermark: false,
                  //   showLiveIcon: true,
                  // ),

                  )
                ),

                SizedBox.square(dimension: 24),

                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: DIRTXAppColorScheme.greyLight,
                        width: 2.0,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200), // fade speed
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: animation.drive(
                                Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero),
                              ),
                              child: child,
                            ),
                          );
                        },
                        // child: DIRTXSplashScreen(),
                        child: isConfigPanelShown
                            ? const DIRTXConfigurationPanel(key: ValueKey("config"))
                            : const DIRTXHistoryPanel(key: ValueKey("history")),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}

enum _StreamStatus { loading, ready, error }

class LiveFeedLoader extends StatefulWidget {
  const LiveFeedLoader({Key? key}) : super(key: key);

  @override
  _LiveFeedLoaderState createState() => _LiveFeedLoaderState();
}

class _LiveFeedLoaderState extends State<LiveFeedLoader> {
  _StreamStatus _status = _StreamStatus.loading;
  Timer? _pollingTimer;
  final int _timeoutSeconds = 20;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _triggerStreamAndStartPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _reset() {
    _pollingTimer?.cancel();
    _triggerStreamAndStartPolling();
  }

  Future<void> _triggerStreamAndStartPolling() async {
    setState(() {
      _status = _StreamStatus.loading;
      _elapsedSeconds = 0;
    });

    // 1. KNOCK FIRST: Send a fire-and-forget request to start the stream.
    // We don't await this or care about the response. Its only job is
    // to start the live_proc on the backend.
    try {
      http.get(Uri.parse('http://127.0.0.1:5000/live_infer'));
    } catch (e) {
      // Ignore errors, the polling will catch if the server is down.
    }

    // 2. THEN WAIT: Start polling the status endpoint.
    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_elapsedSeconds >= _timeoutSeconds) {
        timer.cancel();
        if (mounted) setState(() => _status = _StreamStatus.error);
        return;
      }
      _elapsedSeconds++;
      _checkBackendStatus();
    });
  }

  Future<void> _checkBackendStatus() async {
    if (_status != _StreamStatus.loading) {
      _pollingTimer?.cancel();
      return;
    }

    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:5000/live_status'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'ready') {
          _pollingTimer?.cancel();
          if (mounted) setState(() => _status = _StreamStatus.ready);
        }
      }
    } catch (e) {
      // The timeout will handle persistent connection issues.
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case _StreamStatus.ready:
        return MJPEGStreamScreen(
          streamUrl: 'http://127.0.0.1:5000/live_infer',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          borderRadius: 15,
          showLogs: false,
          timeout: Duration(seconds: 15),
          showWatermark: false,
          showLiveIcon: true,
        );
      case _StreamStatus.error:
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
              const SizedBox(height: 16),
              const Text('Failed to load live feed.', textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              const Text('The server took too long to respond.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC85A19), foregroundColor: Colors.white),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                onPressed: _reset,
              ),
            ],
          ),
        );
      case _StreamStatus.loading:
      default:
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Connecting to live feed...', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 24),
              LinearProgressIndicator(
                minHeight: 16,
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFC85A19),
              ),
              const SizedBox(height: 16),
              Text('Time elapsed: $_elapsedSeconds / $_timeoutSeconds s', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        );
    }
  }
}