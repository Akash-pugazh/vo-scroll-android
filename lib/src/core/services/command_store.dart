import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/voice_command.dart';

class CommandStore {
  static const _commandsKey = 'voice_commands';

  Future<List<VoiceCommand>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_commandsKey) ?? <String>[];
    return raw
        .map((jsonStr) => VoiceCommand.fromMap(
              json.decode(jsonStr) as Map<String, dynamic>,
            ))
        .toList(growable: false);
  }

  Future<void> save(List<VoiceCommand> commands) async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = commands
        .map((command) => json.encode(command.toMap()))
        .toList(growable: false);
    await prefs.setStringList(_commandsKey, serialized);
  }
}
