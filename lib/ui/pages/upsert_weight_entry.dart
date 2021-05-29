import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants.dart';
import '../../models/weight_entry.dart';

class UpsertWeightEntry extends StatefulWidget {
  final WeightEntry? weightEntry;

  UpsertWeightEntry([this.weightEntry]);

  @override
  _UpsertWeightEntryState createState() => _UpsertWeightEntryState();
}

class _UpsertWeightEntryState extends State<UpsertWeightEntry> {
  final _formKey = GlobalKey<FormState>();

  final format = DateFormat('yyyy-MM-dd');

  late TextEditingController _weightController;
  late TextEditingController _dateController;
  late TextEditingController _commentController;

  late DateTime _selectedDate;
  late bool _isCheatDay;

  void save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      final newEntry = WeightEntry(
        date: _selectedDate,
        weight: double.parse(_weightController.text),
        comment: _commentController.text,
        cheatDay: _isCheatDay,
      );

      final box = GetStorage();
      List<WeightEntry> entries = box.read<List<dynamic>>(kWeightEntriesListKey)
          ?.map((e) {
            if (e is WeightEntry) return e; 
            return WeightEntry.fromJson(e);
          })
          .toList()
        ?? [];

      entries.add(newEntry);
      box.write(kWeightEntriesListKey, entries);

      Get.back();
    } catch(err) {
      if (kDebugMode) debugPrint(err.toString());
    }
  }

  @override
  void initState() {
    _selectedDate = widget.weightEntry?.date ?? DateTime.now();
    _isCheatDay = widget.weightEntry?.cheatDay ?? false;

    _weightController = TextEditingController(text: widget.weightEntry?.weight.toString());
    _dateController = TextEditingController(text: format.format(_selectedDate));
    _commentController = TextEditingController(text: widget.weightEntry?.comment);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add weight entry'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => save(),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                ),
                validator: (value) {
                  if (value == null || value == '') {
                    return 'Weight can\'t be empty';
                  }
                  double? weight = double.tryParse(value);
                  if (weight == null) {
                    return 'Weight must be a number';
                  }

                  return null;
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: TextField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                ),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(1995),
                    lastDate: DateTime.now(),
                  );

                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                      _dateController.text = format.format(date);
                    });
                  }
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Comment',
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Text('Cheat day '),
                  Checkbox(
                    value: _isCheatDay,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _isCheatDay = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _dateController.dispose();
    _commentController.dispose();
    super.dispose();
  }
}
