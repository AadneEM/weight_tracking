import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class WeightEntry {
  late final String id;
  final DateTime date;
  final double weight;
  final String? comment;
  bool cheatDay;

  WeightEntry({
    String? id,
    required this.date,
    required this.weight,
    this.comment,
    this.cheatDay = false,
  }) {
    this.id = id ?? Uuid().v1();
  }

  WeightEntry copyWith({
    String? id,
    DateTime? date,
    double? weight,
    String? comment,
    bool? cheatDay,
  }) {
    return WeightEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      comment: comment ?? this.comment,
      cheatDay: cheatDay ?? this.cheatDay,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'weight': weight,
      'comment': comment,
      'cheatDay': cheatDay,
    };
  }

  factory WeightEntry.fromMap(Map<String, dynamic> map) {
    return WeightEntry(
      id: map['id'],
      date: DateTime.parse(map['date']),
      weight: map['weight'],
      comment: map['comment'],
      cheatDay: map['cheatDay'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WeightEntry.fromJson(String source) => WeightEntry.fromMap(json.decode(source));

  String get displayableDate {
    final format = DateFormat('dd.MM.yyyy');
    return format.format(date);
  }

  String get displayableShortDate {
    final format = DateFormat('dd.MM');
    return format.format(date);
  }

  @override
  String toString() {
    return 'WeightEntry(id: $id, date: $date, weight: $weight, comment: $comment, cheatDay: $cheatDay)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeightEntry && other.weight == weight && other.cheatDay == cheatDay && sameDateAs(other.date);
  }

  bool sameDateAs(DateTime date) {
    return this.date.year == date.year && this.date.month == date.month && this.date.day == date.day;
  }

  @override
  int get hashCode {
    return id.hashCode ^ date.hashCode ^ weight.hashCode ^ comment.hashCode ^ cheatDay.hashCode;
  }
}
