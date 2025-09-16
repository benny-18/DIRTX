import 'dart:ui';

import 'package:dirtx/main.dart';
import 'package:dirtx/misc/DIRTXFlaskBackend.dart';
import 'package:flutter/material.dart';

class DIRTXLoadingCard extends StatefulWidget {
  const DIRTXLoadingCard({super.key});

  @override
  State<DIRTXLoadingCard> createState() => _DIRTXLoadingCardState();
}

class _DIRTXLoadingCardState extends State<DIRTXLoadingCard> {

  @override
  void initState() {
    super.initState();
    currentLoadingMessage = getRandomMessage();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
          child: AlertDialog(
            backgroundColor: DIRTXAppColorScheme.rustLight,

            content: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 24,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Image(image: AssetImage('assets/images/dirtx-logo.png'), width: 120,),
                  ),
                  SizedBox(
                      width: 320,
                      child: LinearProgressIndicator(
                        minHeight: 16,
                        borderRadius: BorderRadius.circular(16),
                        color: DIRTXAppColorScheme.rustMedium,
                      )
                  ),
                  Row(
                    children: [
                      Icon(Icons.hourglass_top_rounded, size: 16, color: DIRTXAppColorScheme.greyDark,),
                      SizedBox.square(dimension: 8),
                      Text(currentLoadingMessage, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: DIRTXAppColorScheme.greyDark)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
