import 'package:flutter/material.dart';
import 'package:flutter_advanced_testing/controllers/task_controller.dart';
import 'package:flutter_advanced_testing/models/task.dart';
import 'package:flutter_advanced_testing/ui/theme.dart';
import 'package:flutter_advanced_testing/ui/widgets/button.dart';
import 'package:flutter_advanced_testing/ui/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  final List<TimeOfDay> _initTime = [
    TimeOfDay.fromDateTime(DateTime.now()),
    TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 15))),
  ];

  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];

  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Add Task', style: headingStyle),
              ///////////////////////////////////
              InputField(
                title: 'Title',
                hint: 'Enter title here',
                controller: _titleController,
              ),
              ///////////////////////////////////
              InputField(
                title: 'Note',
                hint: 'Enter title note',
                controller: _noteController,
              ),
              ///////////////////////////////////
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () => _getDateFromUser(),
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              ///////////////////////////////////
              Row(
                children: [
                  ////////////////////////////
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: true),
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  ////////////////////////////
                  const SizedBox(width: 20.0),
                  ///////////////////////////
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: false),
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ///////////////////////////////////
              InputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early',
                widget: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<int>(
                    dropdownColor: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(12.0),
                    items: remindList
                        .map<DropdownMenuItem<int>>(
                          (int val) => DropdownMenuItem<int>(
                            child: Text('$val'),
                            value: val,
                          ),
                        )
                        .toList(),
                    onChanged: (int? _newSelected) {
                      setState(() {
                        _selectedRemind = _newSelected!;
                      });
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    underline: Container(height: 0),
                    style: subTitleStyle,
                  ),
                ),
              ),
              ///////////////////////////////////
              InputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: DropdownButton<String>(
                    dropdownColor: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(12.0),
                    items: repeatList
                        .map<DropdownMenuItem<String>>(
                          (String val) => DropdownMenuItem<String>(
                            child: Text(val),
                            value: val,
                          ),
                        )
                        .toList(),
                    onChanged: (String? _newSelected) {
                      setState(() {
                        _selectedRepeat = _newSelected!;
                      });
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    underline: Container(height: 0),
                    style: subTitleStyle,
                  ),
                ),
              ),
              ///////////////////////////////////
              const SizedBox(height: 15),
              ///////////////////////////////////
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Color', style: titleStyle),
                      Wrap(
                        children: List<Widget>.generate(
                          3,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 6.0, top: 2),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedColor = index;
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: index == 0
                                    ? primaryClr
                                    : index == 1
                                        ? pinkClr
                                        : orangeClr,
                                radius: 15,
                                child: _selectedColor == index
                                    ? const Icon(
                                        Icons.done,
                                        size: 18,
                                        color: white,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ////////////////////////
                  MyButton(
                    label: 'Create Task',
                    onTap: () => _validateData(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Flutter Demo',
        style: titleStyle,
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 22,
          color: primaryClr,
        ),
        onPressed: () => Get.back(),
      ),
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/person.jpeg'),
            radius: 19,
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  _validateData() {
    if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'All fields are required!',
        backgroundColor: white,
        colorText: Colors.red[800],
        icon: Icon(Icons.warning_amber_outlined, color: Colors.red[900]),
        snackPosition: SnackPosition.BOTTOM,
        duration : const Duration(seconds: 2),
      );
    } else {
      _addTaskToDB();
      Get.back();
    }
  }

  ////////////////////////////////////////////////////////////////////////
  _addTaskToDB() async {
    await _taskController.addTask(
      Task(
        title: _titleController.text,
        note: _noteController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        isCompleted: 0,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  _getDateFromUser() async {
    DateTime? selectedDate_user = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
      initialEntryMode: DatePickerEntryMode.calendar,
    );
    if (selectedDate_user != null) {
      setState(() {
        _selectedDate = selectedDate_user;
      });
    }
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? selectedTime_user = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _initTime[0] : _initTime[1],
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (selectedTime_user != null) {
      setState(() {
        if (isStartTime) {
          _initTime[0] = selectedTime_user;
          _startTime = selectedTime_user.format(context);
        } else {
          _initTime[1] = selectedTime_user;
          _endTime = selectedTime_user.format(context);
        }
      });
    }
  }
}
