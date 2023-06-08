import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';

class DatePickerPopup extends StatefulWidget {
  final String message;
  late final Function onDialogClose;

  DatePickerPopup({required this.message, required this.onDialogClose});

  @override
  State<DatePickerPopup> createState() => _DatePickerPopup();
}

class _DatePickerPopup extends State<DatePickerPopup> {
  DateTime? _selectedDate = DateTime(2022,5);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return AlertDialog(
      content: Text(widget.message),
      actions: [
        InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Done Button
              Container(
                  height:20,
                  width: width,
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: InkWell(
                    onTap: () {
                      widget.onDialogClose(_selectedDate!);
                    },
                    child: const Text(
                      "Done",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.yellow),
                    ),
                  )),
              //Date picker
              Container(
                color: Colors.white,
                child: DatePickerWidget(
                  looping: false,
                  firstDate: DateTime(1940),
                  dateFormat: "yyyy/MMMM/dd",
                  onChange: (DateTime newDate, _) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                    print(_selectedDate);
                  },
                  lastDate: DateTime(2022,5),
                  pickerTheme: const DateTimePickerTheme(
                    backgroundColor: Colors.transparent,
                    itemTextStyle: TextStyle(color: Colors.black, fontSize: 19),
                    dividerColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }
}
