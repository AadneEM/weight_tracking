import 'package:uuid/uuid.dart';

class WeightEntry {
  late String id;
  late DateTime date;
  late double weight;
  String? comment;
  late bool cheatDay;

  WeightEntry({
    required this.date,
    required this.weight,
    this.comment,
    this.cheatDay = false,
  }) {
    id = Uuid().v1();
  }

  WeightEntry copyWith({
    DateTime? date,
    double? weight,
    String? comment,
    bool? cheatDay,
  }) {
    return new WeightEntry(
      date: date ?? this.date,
      weight: weight ?? this.weight,
      comment: comment ?? this.comment,
      cheatDay: cheatDay ?? this.cheatDay,
    );
  }

  WeightEntry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = DateTime.parse(json['date']);
    weight = json['weight'];
    comment = json['comment'];
    cheatDay = json['cheatDay'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    
    data['id'] = id;
    data['date'] = date.toIso8601String();
    data['weight'] = weight;
    data['comment'] = comment;
    data['cheatDay'] = cheatDay;

    return data;
  }
}