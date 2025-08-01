import 'package:flutter/material.dart';

class DIRTXAppHome extends StatefulWidget {
  const DIRTXAppHome({super.key});

  @override
  State<DIRTXAppHome> createState() => _DIRTXAppHomeState();
}

class _DIRTXAppHomeState extends State<DIRTXAppHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("DIRTX"),
      ),

      body: Center(
        child: Text("Hello world!"),
      )
    );
  }
}
