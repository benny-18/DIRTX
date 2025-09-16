// lib/DIRTXFlaskBackend.dart
// where i store DIRTX's variables
// so that it's accessible throughout the app

// Global variables

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dirtx/main.dart';
import 'package:dirtx/misc/DIRTXLoadingCard.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dirtx/DIRTXAppHome.dart';

int resolution = 320;
double sensitivity = 70;
double strictness = 50;
int border = 2;
bool hideLabel = false;
bool hideScores = true;

// bool isLiveFeed = false;
final ValueNotifier<bool> isLiveFeedNotifier = ValueNotifier(false);
bool isImport = false;

String currentConn = "none";
// String deviceName = "DroidCamX (Benny's Pixel 6)";
String deviceName = "DJI Neo (Wi-Fi Direct)";


const String dirtxBackend = "http://127.0.0.1:5000";

final List<String> messages = [
  "Processing detections...",
  "Analyzing image...",
  "Running inference...",
  "Detecting objects...",
  "Hold on, finding stuff...",
  "Looking closely...",
  "Scanning the scene...",
  "Spotting objects...",
  "Crunching the pixels...",
  "Searching for patterns...",
  "Performing analysis...",
];

late String currentLoadingMessage;

String getRandomMessage() {
  final random = Random();
  int index = random.nextInt(messages.length);
  return messages[index];
}

// for the path of last output
ValueNotifier<String?> backendOutputDirNotifier = ValueNotifier(null);

ValueNotifier<String?> currentConnNotifier = ValueNotifier(null);

String? backendOutputDir;

Future<void> setArguments({
  required int resolution, required int border,
  required double sensitivity, required double strictness,
  required bool hideLabel, required bool hideConfidence,
}) async {

  final url = Uri.parse('$dirtxBackend/arguments');


  final body = {
    "imgsz": resolution, "conf_thres": sensitivity, "iou_thres": strictness, "line_thickness": border, "hide_labels": hideLabel, "hide_conf": hideConfidence,
  };

  final response = await http.post(
    url,

    headers: {"Content-Type": "application/json"},
    body: jsonEncode(body),
  );
  // if (response.statusCode == 200) {
  //
  //   //debug chuchu
  //   print("arguments: ${response.body}");
  // } else {
  //   print("error nayawa: ${response.body}");
  //
  // }
}

Future<void> uploadForInference(File file) async {
  final url = Uri.parse('$dirtxBackend/infer');


  var request = http.MultipartRequest('POST', url);

  request.files.add(await http.MultipartFile.fromPath('file', file.path));

  final streamedResponse = await request.send();


  final response = await http.Response.fromStream(streamedResponse);
  if (response.statusCode == 200) {


    final Map<String, dynamic> payload = jsonDecode(response.body);

    String rawPath = payload['output_dir'] ?? '';
    rawPath = rawPath.replaceAll(RegExp(r'\u001b\[[0-9;]*m'), '');
    if (rawPath.startsWith('/mnt/')) {

      rawPath = rawPath.replaceFirst('/mnt/', '');
      rawPath = '${rawPath[0].toUpperCase()}:\\${rawPath.substring(2).replaceAll('/', '\\')}';


    }

    backendOutputDir = rawPath;
    backendOutputDirNotifier.value = rawPath;


    print("Output directory set: $backendOutputDir");
  } else {

    print("error tangyawa: ${response.body}");
  }
}

Future<void> pickAndUploadMedia(BuildContext context) async {

  // need hin new safe context para loader dialog instead of plain buildcontext context la
  // needed if magamit hin await, which is asya nat gamit pag call hin na function from DIRTXFootageSelectionCard.dart
  // yawa unta di kon kalimtan utro
  final safeContext = Navigator.of(context, rootNavigator: true).context;
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['png', 'jpg', 'jpeg', 'mp4'],

  );

  currentConn = "fromImport";
  print(currentConn);
  currentConnNotifier.value = currentConn;

  if (result != null && result.files.single.path != null) {
    File selectedFile = File(result.files.single.path!);

    showDialog(
      context: safeContext,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) => DIRTXLoadingCard(),

    );


    await uploadForInference(selectedFile);

    Navigator.of(safeContext, rootNavigator: true).pop();  // close

    isLiveFeedNotifier.value = false;

    ScaffoldMessenger.of(safeContext).showSnackBar(
      SnackBar(
        width: 240,
        backgroundColor: DIRTXAppColorScheme.rustLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const Text("Analysis finished", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: DIRTXAppColorScheme.rustVibrant)),
            Spacer(),
            IconButton(onPressed: (){ ScaffoldMessenger.of(safeContext).hideCurrentSnackBar(); }, icon: Icon(Icons.close_rounded), color: DIRTXAppColorScheme.rustMedium,)
          ],
        ),
        behavior: SnackBarBehavior.floating,
      )
    );


  } else {
    print("No file selected.");
  }
}

Future<void> stopLiveView() async {
  try {
    final response = await http.post(Uri.parse("http://127.0.0.1:5000/stop_live"));
    if (response.statusCode == 200) {
      print("Live view stopped successfully.");
    } else {
      print("Failed to stop live view: ${response.statusCode}");
    }
  } catch (e) {
    print("Error stopping live view: $e");
  }
}
