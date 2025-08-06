import 'dart:ui';
import 'package:dirtx/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DIRTXAboutCard extends StatelessWidget {
  const DIRTXAboutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          color: Colors.black.withValues(alpha: 0),
        ),
      ),
      Center(
        child: SizedBox(
          width: 640,
          height: 540,
          child: AlertDialog(
            scrollable: true,
            insetPadding: EdgeInsets.zero,
            backgroundColor: DIRTXAppColorScheme.rustLight,


            content: Padding(
              padding: EdgeInsets.only(left: 12, right: 12, top: 28),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 240, child: Image(image: AssetImage('assets/images/dirtx-logo.png'))),
                  const Text("The proponents presented this capstone project to the Faculty of the IT and Computer Education Unit at Leyte Normal University in Tacloban City as part of the requirements for their degree in Bachelor of Science in Information Technology.", style: TextStyle(color: DIRTXAppColorScheme.greyDark), textAlign: TextAlign.justify,),
                  const Text("About DIRTX", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: DIRTXAppColorScheme.rustVibrant)),
                  const Text("DIRTX (Drone Imaging for Red Tide Detection Using AI-Based and Machine Learning-Powered System for Tacloban Coastal Areas) is an AI-powered application developed to assist in the early detection of harmful algal blooms (HABs), commonly known as red tide, in coastal waters. The system was created to address the limitations of traditional water sampling methods, which are time-consuming, labor-intensive, and often reactive rather than preventive.", style: TextStyle(color: DIRTXAppColorScheme.greyDark), textAlign: TextAlign.justify,),
                  const Text("DIRTX uses drone imaging and pre-recorded videos to analyze water conditions through machine learning and computer vision techniques. Leveraging YOLOv9 for instance segmentation and OpenCV for image preprocessing, the system can identify potential HAB clusters in water bodies and visually mark them for rapid analysis. The system’s purpose is to serve as a decision-support tool for marine biologists, environmental agencies, and local government units in their efforts to protect marine ecosystems and ensure public health and safety.", style: TextStyle(color: DIRTXAppColorScheme.greyDark), textAlign: TextAlign.justify,),
                  const Text("License", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: DIRTXAppColorScheme.rustVibrant)),
                  const Text("DIRTX is distributed under the GNU General Public License v3.0 (GNU GPL v3). This license allows users to run, study, share, and modify the software freely, as long as any derivative work is also distributed under the same license. In short, you're free to use and adapt DIRTX, but your modified version must also remain open-source.", style: TextStyle(color: DIRTXAppColorScheme.greyDark), textAlign: TextAlign.justify,),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: const TextStyle(color: DIRTXAppColorScheme.greyDark, fontFamily: "SpaceGrotesk"),
                      children: [
                        TextSpan(text: 'View the full license at our official GitHub repository:\n', style: TextStyle(color: DIRTXAppColorScheme.greyDark, fontWeight: FontWeight.w500)),
                        TextSpan(
                          text: 'https://github.com/benny-18/DIRTX',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse('https://github.com/benny-18/DIRTX'), mode: LaunchMode.platformDefault);
                            },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox.square(dimension: 0),

                      Row(
                        spacing: 24,
                        children: [
                          SizedBox(
                            width: 320,
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: DIRTXAppColorScheme.greyLight, width: 3.0, strokeAlign: BorderSide.strokeAlignOutside),
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              child: Image(
                                  fit: BoxFit.cover,
                                  isAntiAlias: true,
                                  image: AssetImage('assets/images/capstone-team.jpg')
                              )
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("TEAM", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: DIRTXAppColorScheme.rustMedium)),
                              const Text("COUGHSTONE", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: DIRTXAppColorScheme.rustVibrant)),
                              const SizedBox.square(dimension: 8),
                              const Text("Aguinalde, Kenaniah", style: TextStyle(color: DIRTXAppColorScheme.greyDark), textAlign: TextAlign.justify,),
                              const Text("Labarro, Caryl", style: TextStyle(color: DIRTXAppColorScheme.greyDark), textAlign: TextAlign.justify,),
                              const Text("Masubay, Marvin", style: TextStyle(color: DIRTXAppColorScheme.greyDark), textAlign: TextAlign.justify,),
                              const Text("Pelpinosas, Janea", style: TextStyle(color: DIRTXAppColorScheme.greyDark), textAlign: TextAlign.justify,),

                            ]
                          ),
                        ]
                      ),
                    ],
                  ),
                ],
              ),
            ),

            actions: [
              Padding(
                padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Row(
                    children: [
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
                      const SizedBox.square(dimension: 12),
                      const Text("First version release", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: DIRTXAppColorScheme.rustVibrant)),],
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size.fromHeight(36),
                      foregroundColor: Colors.white,
                      backgroundColor: DIRTXAppColorScheme.rustVibrant,
                      side: BorderSide(color: DIRTXAppColorScheme.greyLight, width: 0, strokeAlign: BorderSide.strokeAlignCenter),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child:
                    Text("Close")
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    ]
    );
  }
}
