import 'package:flutter/services.dart';

import '../models/voice_command.dart';

class PlatformVoiceBridge {
  static const MethodChannel _channel = MethodChannel('voice_scroll/bridge');

  Future<void> startListening(List<VoiceCommand> commands) async {
    final phrases = commands
        .map((command) => command.phrase.trim())
        .where((phrase) => phrase.isNotEmpty)
        .toSet()
        .toList(growable: false);

    await _channel.invokeMethod<void>('startListening', {
      'phrases': phrases,
    });
  }

  Future<void> stopListening() async {
    await _channel.invokeMethod<void>('stopListening');
  }

  Future<void> testScrollNext() async {
    await _channel.invokeMethod<void>('scrollNext');
  }
}
