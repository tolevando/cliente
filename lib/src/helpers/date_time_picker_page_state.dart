import 'package:flutter/material.dart';

class DateTimePickerPage extends StatefulWidget {
  @override
  _DateTimePickerPageState createState() => _DateTimePickerPageState();
}
class _DateTimePickerPageState extends State<DateTimePickerPage> {
  DateTime pickedDate;
  TimeOfDay time;
  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Time Picker'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(height: 10,)
      ),
    );
  }
  
}