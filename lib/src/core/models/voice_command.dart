class VoiceCommand {
  const VoiceCommand({
    required this.id,
    required this.phrase,
    required this.action,
    this.enabled = true,
  });

  final String id;
  final String phrase;
  final String action;
  final bool enabled;

  VoiceCommand copyWith({
    String? id,
    String? phrase,
    String? action,
    bool? enabled,
  }) {
    return VoiceCommand(
      id: id ?? this.id,
      phrase: phrase ?? this.phrase,
      action: action ?? this.action,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phrase': phrase,
      'action': action,
      'enabled': enabled,
    };
  }

  factory VoiceCommand.fromMap(Map<String, dynamic> map) {
    return VoiceCommand(
      id: map['id'] as String,
      phrase: map['phrase'] as String,
      action: map['action'] as String,
      enabled: map['enabled'] as bool? ?? true,
    );
  }
}
