import 'package:flutter/material.dart';

void main() {
  runApp(const SchedlyApp());
}

class SchedlyApp extends StatelessWidget {
  const SchedlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Schedly',
      home: Scaffold(
        body: Center(
          child: Text('Schedly'),
        ),
      ),
    );
  }
}
