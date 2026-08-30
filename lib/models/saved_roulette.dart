import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:roulette/roulette.dart';

class SavedEntry {
  const SavedEntry({required this.text, required this.color});

  final String text;
  final Color color;

  Map<String, dynamic> toJson() => {
        'text': text,
        'color': color.toARGB32(),
      };

  factory SavedEntry.fromJson(Map<String, dynamic> json) => SavedEntry(
        text: json['text'] as String? ?? '',
        color: Color((json['color'] as num).toInt()),
      );
}

class SavedRoulette {
  const SavedRoulette({
    required this.id,
    required this.name,
    required this.entries,
    required this.createdAt,
  });

  final String id;
  final String name;
  final List<SavedEntry> entries;
  final DateTime createdAt;

  RouletteGroup toGroup() => RouletteGroup(
        entries
            .map((e) => RouletteUnit(text: e.text, color: e.color, weight: 1))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'entries': entries.map((e) => e.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory SavedRoulette.fromJson(Map<String, dynamic> json) => SavedRoulette(
        id: json['id'] as String,
        name: json['name'] as String,
        entries: (json['entries'] as List)
            .map((e) => SavedEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  static String encodeList(List<SavedRoulette> list) =>
      jsonEncode(list.map((e) => e.toJson()).toList());

  static List<SavedRoulette> decodeList(String raw) {
    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((e) => SavedRoulette.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
