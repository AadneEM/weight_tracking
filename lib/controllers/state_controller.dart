import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:weight_tracking/models/weight_entry.dart';

import '../constants.dart';

class StateController extends GetxController {
  final entries = RxList<WeightEntry>([]);
  final selectedTab = 0.obs;

  StateController() {
    final box = GetStorage();
    List<WeightEntry> storedEntries = (box
            .read<List<dynamic>>(kWeightEntriesListKey)
            ?.map((e) {
              if (e is WeightEntry) return e;
              if (e is Map<String, dynamic>) return WeightEntry.fromMap(e);
              if (e is String) return WeightEntry.fromJson(e);
              if (kDebugMode) developer.log('Stored weight entry is not a valid type: $e', name: 'Get storage error');
              return null;
            })
            .where((e) => e != null)
            .cast<WeightEntry>()
            .toList() ??
        [])
      ..sort((a, b) => b.date.compareTo(a.date));
    entries.value = storedEntries;
  }

  void addEntry(WeightEntry newEntry) {
    entries.add(newEntry);
    entries.sort((a, b) => b.date.compareTo(a.date));

    final box = GetStorage();
    box.write(kWeightEntriesListKey, entries);

    super.update();
  }

  void removeEntry(WeightEntry entry) {
    entries.remove(entry);

    final box = GetStorage();
    box.write(kWeightEntriesListKey, entries);

    super.update();
  }

  WeightEntry? get latestEntry => entries.isNotEmpty ? entries.first : null;
}
