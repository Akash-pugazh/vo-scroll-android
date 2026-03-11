import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/voice_command.dart';
import '../../core/services/command_store.dart';
import '../../core/services/platform_voice_bridge.dart';

final commandStoreProvider = Provider((ref) => CommandStore());
final platformVoiceBridgeProvider = Provider((ref) => PlatformVoiceBridge());

final commandsControllerProvider =
    AsyncNotifierProvider<CommandsController, List<VoiceCommand>>(
  CommandsController.new,
);

class CommandsController extends AsyncNotifier<List<VoiceCommand>> {
  @override
  Future<List<VoiceCommand>> build() async {
    final store = ref.read(commandStoreProvider);
    final loaded = await store.load();
    if (loaded.isEmpty) {
      final defaults = [
        const VoiceCommand(id: '1', phrase: 'next', action: 'scroll_next'),
        const VoiceCommand(id: '2', phrase: 'okay', action: 'scroll_next'),
      ];
      await store.save(defaults);
      return defaults;
    }
    return loaded;
  }

  Future<void> addCommand(String phrase) async {
    final normalized = phrase.trim();
    if (normalized.isEmpty) return;

    final current = state.value ?? <VoiceCommand>[];
    final exists = current.any(
      (command) => command.phrase.toLowerCase() == normalized.toLowerCase(),
    );
    if (exists) return;

    final next = [
      ...current,
      VoiceCommand(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        phrase: normalized,
        action: 'scroll_next',
      ),
    ];
    await ref.read(commandStoreProvider).save(next);
    state = AsyncValue.data(next);
  }

  Future<void> setListening(bool enable) async {
    final bridge = ref.read(platformVoiceBridgeProvider);
    final commands = state.value ?? <VoiceCommand>[];
    if (enable) {
      await bridge.startListening(commands.where((c) => c.enabled).toList());
      return;
    }
    await bridge.stopListening();
  }

  Future<void> triggerManualScroll() async {
    await ref.read(platformVoiceBridgeProvider).testScrollNext();
  }
}
