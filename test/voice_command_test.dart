import 'package:flutter_test/flutter_test.dart';
import 'package:voice_scroll/src/core/models/voice_command.dart';

void main() {
  test('VoiceCommand maps to and from Map', () {
    const command = VoiceCommand(id: '42', phrase: 'next', action: 'scroll_next');

    final map = command.toMap();
    final restored = VoiceCommand.fromMap(map);

    expect(restored.id, '42');
    expect(restored.phrase, 'next');
    expect(restored.action, 'scroll_next');
    expect(restored.enabled, isTrue);
  });
}
