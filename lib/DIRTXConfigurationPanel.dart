import 'package:dirtx/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DIRTXConfigurationPanel extends StatefulWidget {
  const DIRTXConfigurationPanel({super.key});

  @override
  State<DIRTXConfigurationPanel> createState() => _DIRTXConfigurationPanelState();
}

class _DIRTXConfigurationPanelState extends State<DIRTXConfigurationPanel> {

  int resolution = 320;
  double sensitivity = 80;
  double strictness = 50;
  int border = 2;
  bool hideLabel = false;
  bool hideScores = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Configuration",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: DIRTXAppColorScheme.rustVibrant
              )
            ),
            IconButton(
              onPressed: (){
                setState(() {
                  resolution = 320;
                  sensitivity = 80;
                  strictness = 50;
                  border = 2;
                  hideLabel = false;
                  hideScores = true;

                  // debug
                  if (kDebugMode) {
                    print("$resolution, $sensitivity, $strictness, $border, $hideLabel, $hideScores");
                  }

                });
              },
              tooltip: "Reset configuration",
              icon: Icon(Icons.refresh_rounded, size: 20,)
            )
          ],
        ),

        SizedBox.square(dimension: 8),

        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView(

              // settings when Column() widget was still used
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.max,
              // spacing: 20,

              clipBehavior: Clip.hardEdge,
              padding: EdgeInsets.all(2),
              children: [

              // resolution
              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    color: DIRTXAppColorScheme.rustLight,
                    border: Border.all(color: DIRTXAppColorScheme.greyLight, width: 1.0, strokeAlign: BorderSide.strokeAlignOutside),
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Model resolution", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox.square(dimension: 8),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 4),
                          child: ToggleButtons(
                            constraints: BoxConstraints(minHeight: 32, minWidth: 50),
                            borderWidth: 1.0,
                            borderRadius: BorderRadius.circular(6),
                            selectedBorderColor: DIRTXAppColorScheme.rustMedium,
                            isSelected: [resolution == 320, resolution == 480, resolution == 640, resolution == 960],
                            onPressed: (index) {
                              setState(() {
                                resolution = [320, 480, 640, 960][index];

                                // debugging chuchu
                                if (kDebugMode) {
                                  print(resolution);
                                }
                              });
                            },
                            children: const [
                              Text('320p', style: TextStyle(fontWeight: FontWeight.w500)),
                              Text('480p', style: TextStyle(fontWeight: FontWeight.w500)),
                              Text('640p', style: TextStyle(fontWeight: FontWeight.w500)),
                              Text('960p', style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox.square(dimension: 8),
                      // Text("Higher res = longer process time", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
                      // Text("Lower res = less accurate result", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
                      Text("320p is a good balance and helps DIRTX for faster processing. Use higher resolutions if you need more detail.", textAlign: TextAlign.justify, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ),
              SizedBox.square(dimension: 20),

              // sensitivity
              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    color: DIRTXAppColorScheme.rustLight,
                    border: Border.all(color: DIRTXAppColorScheme.greyLight, width: 1.0, strokeAlign: BorderSide.strokeAlignOutside),
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Detection sensitivity", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox.square(dimension: 8),
                      Slider(
                        year2023: false,
                        padding: EdgeInsets.zero,
                        activeColor: DIRTXAppColorScheme.rustMedium,
                        inactiveColor: Colors.transparent,
                        value: sensitivity,
                        max: 100,
                        divisions: 10,
                        label: "${sensitivity.round()}%",
                        onChanged: (double value) {
                          setState(() {
                            sensitivity = value;
                            if (kDebugMode) {
                              print("sensitivity = $sensitivity");
                            }
                          });
                        },
                      ),
                      SizedBox.square(dimension: 8),
                      Text("Controls how sure DIRTX should be before showing a detection. Higher means more accurate but fewer results.", textAlign: TextAlign.justify, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox.square(dimension: 20),

              // strictness
              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    color: DIRTXAppColorScheme.rustLight,
                    border: Border.all(color: DIRTXAppColorScheme.greyLight, width: 1.0, strokeAlign: BorderSide.strokeAlignOutside),
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Overlap strictness", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox.square(dimension: 8),
                      Slider(
                        year2023: false,
                        padding: EdgeInsets.zero,
                        activeColor: DIRTXAppColorScheme.rustMedium,
                        inactiveColor: Colors.transparent,
                        value: strictness,
                        max: 100,
                        divisions: 10,
                        label: "${strictness.round()}%",
                        onChanged: (double value) {
                          setState(() {
                            strictness = value;
                            if (kDebugMode) {
                              print("strictness = $strictness");
                            }
                          });
                        },
                      ),
                      SizedBox.square(dimension: 8),
                      Text("Adjusts how closely HAB detections can appear before being merged into one. Higher means less merging, lower removes overlaps.", textAlign: TextAlign.justify, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox.square(dimension: 20),

              // border thiccness
              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    color: DIRTXAppColorScheme.rustLight,
                    border: Border.all(color: DIRTXAppColorScheme.greyLight, width: 1.0, strokeAlign: BorderSide.strokeAlignOutside),
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Edge thickness", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("For border boxes", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
                        ],
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 90),
                        child: DropdownMenu(
                          requestFocusOnTap: false,
                          initialSelection: 2,
                          dropdownMenuEntries: [
                            DropdownMenuEntry(value: 1, label: "1px"),
                            DropdownMenuEntry(value: 2, label: "2px"),
                            DropdownMenuEntry(value: 3, label: "3px"),
                            DropdownMenuEntry(value: 4, label: "4px"),
                            DropdownMenuEntry(value: 5, label: "5px"),
                          ],
                          onSelected: (int? value) {
                            if (value != null) {
                              setState(() {
                                border = value;
                                // debug
                                if (kDebugMode) {
                                  print(border);
                                }
                              });
                            }
                          },
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: DIRTXAppColorScheme.greyDark
                          ),
                          trailingIcon: Icon(Icons.arrow_drop_down_rounded),
                          selectedTrailingIcon: Icon(Icons.arrow_drop_up_rounded),
                          enableSearch: false,
                          enableFilter: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox.square(dimension: 20),

                // hide labels
              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    color: DIRTXAppColorScheme.rustLight,
                    border: Border.all(color: DIRTXAppColorScheme.greyLight, width: 1.0, strokeAlign: BorderSide.strokeAlignOutside),
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Switch(
                      //     value: hideLabel,
                      //     onChanged: (bool value) {
                      //       setState(() {
                      //         hideLabel = value;
                      //         if (kDebugMode) {
                      //           print(hideLabel);
                      //         }
                      //       });
                      //     }
                      //   ),
                      Checkbox(
                        value: hideLabel,
                        onChanged: (bool? value) {
                          setState(() {
                            hideLabel = value!;
                            if (kDebugMode) {
                              print("label: $hideLabel");
                            }
                          });
                        },
                      ),
                      SizedBox.square(dimension: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hide label display", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Hide classes in the result", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox.square(dimension: 20),

              // hide scores
              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    color: DIRTXAppColorScheme.rustLight,
                    border: Border.all(color: DIRTXAppColorScheme.greyLight, width: 1.0, strokeAlign: BorderSide.strokeAlignOutside),
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Switch(
                      //     value: hideScores,
                      //     onChanged: (bool value) {
                      //       setState(() {
                      //         hideScores = value;
                      //         if (kDebugMode) {
                      //           print("scores: $hideScores");
                      //         }
                      //       });
                      //     }
                      // ),
                      Checkbox(
                        value: hideScores,
                        onChanged: (bool? value) {
                          setState(() {
                            hideScores = value!;
                            if (kDebugMode) {
                              print("scores = $hideScores");
                            }
                          });
                        },
                      ),
                      SizedBox.square(dimension: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hide accuracy scores", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("No confidence % on objects", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              ],
            ),
          ),
        ),

        // run detections button
        Column(
          children: [
            SizedBox.square(dimension: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size.fromHeight(36),
                    foregroundColor: Colors.white,
                    backgroundColor: DIRTXAppColorScheme.rustMedium,
                    side: BorderSide(color: DIRTXAppColorScheme.greyLight, width: 0, strokeAlign: BorderSide.strokeAlignCenter),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: (){},
                  child:
                  Text("Run detection")
              ),
            ),
          ],
        ),

      ],
    );
  }
}
