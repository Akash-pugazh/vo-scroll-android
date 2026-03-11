import 'package:flutter/material.dart';

import '../features/home/home_page.dart';

class VoiceScrollApp extends StatelessWidget {
  const VoiceScrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoiceScroll',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
