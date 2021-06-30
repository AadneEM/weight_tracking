import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracking/controllers/state_controller.dart';
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
    _setInitialData();
  }

  void _setInitialData() {
    DateTime _selectedDate = DateTime.now();
    _dateController = TextEditingController(text: format.format(_selectedDate));

    var previousEntry = Get.find<StateController>().latestEntry;

    _initialWeigth = previousEntry?.weight ?? 85;
    _selectedWeight = previousEntry?.weight ?? 85;
  }

  void _save() {
    final newEntry = WeightEntry(
      date: _selectedDate,
      weight: _selectedWeight,
    );

    Get.find<StateController>().addEntry(newEntry);

    _setInitialData();

    setState(() {
      _cardIsOpen = false;
    });
  }

  void _cancle() {
    _setInitialData();
    setState(() {
      _cardIsOpen = false;
    });
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
            border: Border.symmetric(
              horizontal: BorderSide(
                width: 1,
                color: Colors.blueGrey[200]!,
              ),
            ),
          ),
        ),
        onSelectedItemChanged: (index) {
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
                    onPressed: () => _save(),
                    child: Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () => _cancle(),
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
    double w = _cardIsOpen ? cardWidth : 56;
    double h = _cardIsOpen ? cardHeight : 56;

    return AnimatedContainer(
      curve: Curves.ease,
      constraints: BoxConstraints(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h),
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _cardIsOpen ? Colors.blueGrey[50] : Colors.blue,
        boxShadow: kElevationToShadow[1],
        borderRadius: BorderRadius.all(Radius.circular(_cardIsOpen ? 0.0 : 50.0)),
      ),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          switch (child.runtimeType) {
            case Container:
              return SizeTransition(
                sizeFactor: animation,
                child: child,
              );
            default:
              return FadeTransition(
                opacity: animation,
                child: child,
              );
          }
        },
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
