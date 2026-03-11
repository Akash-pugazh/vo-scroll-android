import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commands/commands_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _controller = TextEditingController();
  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    final commandsAsync = ref.watch(commandsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('VoiceScroll')),
      body: commandsAsync.when(
        data: (commands) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create your voice gesture phrases and keep listening in background.',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'New phrase (e.g., hmm, next, okay)',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () async {
                      final text = _controller.text.trim();
                      if (text.isEmpty) return;
                      await ref
                          .read(commandsControllerProvider.notifier)
                          .addCommand(text);
                      _controller.clear();
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _isListening,
                title: const Text('Always listening mode'),
                subtitle: const Text('Uses foreground service on Android'),
                onChanged: (value) async {
                  setState(() => _isListening = value);
                  await ref
                      .read(commandsControllerProvider.notifier)
                      .setListening(value);
                },
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () async {
                  await ref
                      .read(commandsControllerProvider.notifier)
                      .triggerManualScroll();
                },
                child: const Text('Test Scroll Next'),
              ),
              const SizedBox(height: 16),
              const Text('Configured commands:'),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: commands.length,
                  itemBuilder: (context, index) {
                    final command = commands[index];
                    return Card(
                      child: ListTile(
                        title: Text(command.phrase),
                        subtitle: Text('Action: ${command.action}'),
                        trailing: Icon(
                          command.enabled
                              ? Icons.check_circle
                              : Icons.cancel_outlined,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        error: (error, _) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
