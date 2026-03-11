import 'package:flutter/services.dart';

import '../models/voice_command.dart';

class PlatformVoiceBridge {
  static const MethodChannel _channel = MethodChannel('voice_scroll/bridge');

  Future<void> startListening(List<VoiceCommand> commands) async {
    await _channel.invokeMethod<void>('startListening', {
      'commands': commands.map((c) => c.toMap()).toList(growable: false),
    });
  }

  Future<void> stopListening() async {
    await _channel.invokeMethod<void>('stopListening');
  }

  Future<void> testScrollNext() async {
    await _channel.invokeMethod<void>('scrollNext');
  }
}
