import 'dart:ui';
import 'package:dirtx/main.dart';
import 'package:flutter/material.dart';

class DIRTXFootageSelectionCard extends StatefulWidget {
  const DIRTXFootageSelectionCard({super.key});

  @override
  State<DIRTXFootageSelectionCard> createState() => _DIRTXFootageSelectionCardState();
}

class _DIRTXFootageSelectionCardState extends State<DIRTXFootageSelectionCard> {

  TextEditingController deviceAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            color: Colors.black.withValues(alpha: 0),
          ),
        ),
        Center(
          child: SizedBox(
            width: 480,
            child: AlertDialog(
              backgroundColor: DIRTXAppColorScheme.rustLight,
              scrollable: true,
              title: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.add_to_queue_rounded, size: 38, color: DIRTXAppColorScheme.rustMedium),
                        SizedBox.square(dimension: 8,),
                        Text("Input footage", style: TextStyle(color: DIRTXAppColorScheme.rustMedium, fontSize: 30, fontWeight: FontWeight.bold))
                      ],
                    ),
                    Spacer(),
                    IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(Icons.close_rounded), color: DIRTXAppColorScheme.rustVibrant,),
                  ],
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Padding(
                      padding:
                      EdgeInsets.fromLTRB(6, 6, 6, 3),
                      child: Text(
                        "Live video feed",
                        style: TextStyle(fontSize: 16, color: DIRTXAppColorScheme.greyDark),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: DIRTXAppColorScheme.rustMedium, width: 1.0),
                              borderRadius: BorderRadius.circular(12),

                            ),
                            clipBehavior: Clip.none,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.add_link_sharp, size: 20, color: DIRTXAppColorScheme.rustVibrant,),
                                  SizedBox.square(dimension: 6),
                                  Expanded(
                                    child: TextFormField(
                                      controller: deviceAddressController,
                                      decoration: InputDecoration(
                                        fillColor: Colors.transparent,
                                        border: InputBorder.none,
                                        hintText: "192.168.0.1/video",
                                        hintStyle: TextStyle(color: Colors.black38),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox.square(dimension: 12),

                        Tooltip(
                          preferBelow: false,
                          verticalOffset: 35,
                          message: "Enter live view",
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: DIRTXAppColorScheme.rustMedium, foregroundColor: Colors.white),
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16, bottom: 16),
                              child: Icon(Icons.arrow_forward),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox.square(dimension: 18),
                    const Padding(
                      padding:
                      EdgeInsets.fromLTRB(6, 6, 6, 6),
                      child: Text(
                        "File import",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    SizedBox.square(dimension: 2),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          // backgroundColor: DIRTXAppColorScheme.rustMedium,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: DIRTXAppColorScheme.rustMedium,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(12)
                          )
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.file_open_outlined, color: Colors.black),
                            SizedBox.square(dimension: 8),
                            Text("Import image or video",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)
                            )
                          ]
                        )
                      ),
                    ),
                    const SizedBox.square(dimension: 18),
                    const Text("DIRTX supports both live footage processing from drone feed through wireless connection or through file import from local storage.", style: TextStyle(color: DIRTXAppColorScheme.greyDark), textAlign: TextAlign.justify,),
                    const SizedBox.square(dimension: 18),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: DIRTXAppColorScheme.rustMedium,
                      ),
                      width: double.infinity,
                      height: 12,
                    ),
                  ],
                ),
              ),
              // actions: [ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: const Text("Close"))],
            ),
          ),
        ),
      ],
    );
  }
}
