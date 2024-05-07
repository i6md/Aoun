import 'package:flutter/material.dart';

import '../shared/cubit/cubit.dart';

class FilterDialog extends StatefulWidget {
  final List<String> selectedFilters;
  final List<String> resourceTypes;

  FilterDialog({required this.selectedFilters, required this.resourceTypes});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<String> selectedFilters = [];

  @override
  void initState() {
    super.initState();
    selectedFilters = widget.selectedFilters;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter by Resource Type', style: TextStyle(color: Colors.indigo, fontSize: 20)),
      content: SingleChildScrollView(
        child: Column(
          children: widget.resourceTypes.map((type) {
            return CheckboxListTile(
              title: Text(type, style: TextStyle(fontSize: 18)),
              value: selectedFilters.contains(type),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedFilters.add(type);
                  } else {
                    selectedFilters.remove(type);
                  }
                });
              },
              activeColor: Colors.indigo,
              checkColor: Colors.white,
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel', style: TextStyle(color: Colors.red, fontSize: 18)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Apply', style: TextStyle(color: Colors.green, fontSize: 18)),
          onPressed: () {
            Navigator.of(context).pop(selectedFilters);
          },
        ),
      ],
    );
  }
}