import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:get_storage/get_storage.dart';
import 'package:weight_tracking/constants.dart';
import 'package:weight_tracking/models/weight_entry.dart';

class AddEntryFabCard extends StatefulWidget {
  @override
  _AddEntryFabCardState createState() => _AddEntryFabCardState();
}

class _AddEntryFabCardState extends State<AddEntryFabCard> {
  bool _cardIsOpen = false;
  double get cardWidth => MediaQuery.of(context).size.width - 32;
  double cardHeight = 200;

  final format = DateFormat('yyyy-MM-dd');
  DateTime _selectedDate = DateTime.now();
  late TextEditingController _dateController;

  late double _initialWeigth;
  late double _selectedWeight;

  @override
  void initState() { 
    super.initState();
    _setInitialWeight();
    _dateController = TextEditingController(text: format.format(_selectedDate));
  }

  void _setInitialWeight() {
    final box = GetStorage();
    WeightEntry? previousEntry;
    final previousWeightEntry = box.read(kPreviousWeightEntry);
    if (previousWeightEntry is WeightEntry) previousEntry = previousWeightEntry;
    else if (previousWeightEntry != null) previousEntry = WeightEntry.fromJson(previousWeightEntry);

    _initialWeigth = previousEntry?.weight ?? 85;
    _selectedWeight = previousEntry?.weight ?? 85;
  }

  void _save() {
    final box = GetStorage();

    List<WeightEntry> entries = box.read<List<dynamic>>(kWeightEntriesListKey)
          ?.map((e) {
            if (e is WeightEntry) return e; 
            return WeightEntry.fromJson(e);
          })
          .toList()
        ?? [];
    
    WeightEntry? previousEntry;
    final previousWeightEntry = box.read(kPreviousWeightEntry);
    if (previousWeightEntry is WeightEntry) previousEntry = previousWeightEntry;
    else if (previousWeightEntry != null) previousEntry = WeightEntry.fromJson(previousWeightEntry);

    final newEntry = WeightEntry(
      date: _selectedDate,
      weight: _selectedWeight,
    );

    entries.add(newEntry);

    box.write(kWeightEntriesListKey, entries);
    if (previousEntry == null || newEntry.date.isAfter(previousEntry.date)) {
      box.write(kPreviousWeightEntry, newEntry);
    }
  }

  Widget _renderFab() {
    return InkWell(
      onTap: () {
        setState(() {
          _cardIsOpen = true;
        });
      },
      child: Icon(Icons.add, color: Colors.white),
    );
  }

  Widget _renderDatePicker() {
    return SizedBox(
      width: cardWidth / 3,
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
              lastDate: DateTime(2022),
            );
            if (date != null) {
              setState(() {
                _selectedDate = date;
                _dateController.text = format.format(date);
              });
            }
          },
      ),
    );
  }

  Widget _renderWeightPicker() {
    return SizedBox(
      height: cardHeight,
      width: cardWidth / 3,
      child: CupertinoPicker.builder(
        scrollController: FixedExtentScrollController(
          initialItem: (_initialWeigth * 10).floor(),
        ),
        itemExtent: 69,
        selectionOverlay: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.symmetric(horizontal: BorderSide(width: 1, color: Colors.blueGrey[200]!))
          ),
        ),
        onSelectedItemChanged: (index) {
          print(index);
          setState(() {
            _selectedWeight = index / 10;
          });
        },
        itemBuilder: (context, index) {
          return Text(
            '${index / 10}',
            style: TextStyle(
              fontSize: 64,
            ),
          );
        },
      ),
    );
  }

  Widget _renderUpsertEntryCard() {
    return Container(
      width: cardWidth,
      height: cardHeight,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _renderDatePicker(),
              _renderWeightPicker(),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _save();
                      setState(() {
                        _cardIsOpen = false;
                      });
                    }, 
                    child: Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _cardIsOpen = false;
                      });
                    }, 
                    child: Text('Cancle'),

                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = _cardIsOpen ? cardWidth  : 56;
    double h = _cardIsOpen ? cardHeight : 56;

    return AnimatedContainer(
      curve: Curves.ease,
      constraints: BoxConstraints(
        minWidth: w,   maxWidth: w,
        minHeight: h,  maxHeight: h,
      ),
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _cardIsOpen ? Colors.blueGrey[50] : Colors.blue,
        boxShadow: kElevationToShadow[1],
        borderRadius: _cardIsOpen
            ? BorderRadius.all(Radius.circular(0.0))
            : BorderRadius.all(Radius.circular(50)),
      ),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: !_cardIsOpen ? _renderFab() : _renderUpsertEntryCard(),
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
