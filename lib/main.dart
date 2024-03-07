import 'package:flutter/material.dart';
import 'package:mandelbulb/screens/workspace.dart';
import 'package:show_fps/show_fps.dart';

void main() {
  runApp(const MandelBulb());
}

class MandelBulb extends StatelessWidget {
  const MandelBulb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const ShowFPS(
        alignment: Alignment.topRight,
        visible: true,
        showChart: false,
        borderRadius: BorderRadius.all(Radius.circular(11)),
        child: WorkSpace(),
      ),
    );
  }
}
