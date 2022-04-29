import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/notification_services.dart';
import '../../services/theme_services.dart';
import '../../ui/pages/add_task_page.dart';
import '../../ui/size_config.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/button.dart';
import '../../ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  final NotifyHelper _notifyHelper = NotifyHelper();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _notifyHelper.initializeNotification();
    _notifyHelper.requestIOSPermissions();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          ///////////////////////
          _addTaskBar(),
          ///////////////////////
          _addDateBar(),
          ///////////////////////
          const SizedBox(height: 10),
          ///////////////////////
          _showTasks(),
          ///////////////////////
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////
  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_outlined,
          size: 22,
          color: Get.isDarkMode ? white : darkGreyClr,
        ),
        onPressed: () async {
          ThemeServices().switchTheme();
          //await NotifyHelper().displayNotification(title: 'motsfaa', body: 'mjksdn.mnmd.');
        },
      ),
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      actions: [
        IconButton(
          icon: Icon(
            Icons.cleaning_services,
            size: 22,
            color: Get.isDarkMode ? white : darkGreyClr,
          ),
          onPressed: () {
            _taskController.deleteAllTask();
            _notifyHelper.cancelAllNotification();
            //_notifyHelper.displayNotification(title: 'jdjdj', body: 'dddd');
          },
        ),
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/person.jpeg'),
            radius: 19,
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////
  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ////////////////////////////////////
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              ///////////////////
              Text(
                'Today',
                style: headingStyle,
              ),
            ],
          ),
          ////////////////////////////////////
          MyButton(
            label: '+ Add Task',
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 6),
      child: DatePicker(
        DateTime.now(),
        width: 60,
        height: 90,
        initialSelectedDate: DateTime.now(),
        selectedTextColor: white,
        selectionColor: primaryClr,
        onDateChange: (_newDate) {
          setState(() {
            _selectedDate = _newDate;
          });
        },
        dayTextStyle: dateTimeStyle(14.0),
        dateTextStyle: dateTimeStyle(20.0),
        monthTextStyle: dateTimeStyle(14.0),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  DateTime convertStringToDateTime(String strDate) {
    return DateFormat.yMd().parse(strDate);
  }

  ////////////////////////////////////////////////////////////
  bool checkIfTaskMatchSelectedDate(Task task) {
    DateTime dateOfTask = DateFormat.yMd().parse(task.date!);
    if (_selectedDate.difference(dateOfTask).inDays.isNegative) {
      return false;
    } else if (task.date == DateFormat.yMd().format(_selectedDate) ||
        task.repeat == 'Daily' ||
        (task.repeat == 'Weekly' &&
            _selectedDate.difference(dateOfTask).inDays % 7 == 0) ||
        (task.repeat == 'Monthly' && _selectedDate.day == dateOfTask.day)) {
      return true;
    } else {
      return false;
    }
  }

  ////////////////////////////////////////////////////////////
  _showTasks() {
    return Expanded(
      child: Obx(
        () {
          if (_taskController.taskList.isEmpty) {
            return _noTaskMsg();
          } else {
            return RefreshIndicator(
              displacement: 10,
              onRefresh: _onRefreshMethod,
              child: ListView.builder(
                scrollDirection: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                itemCount: _taskController.taskList.length,
                itemBuilder: (_c, _index) {
                  //////////////////////////////////////////////
                  Task task = _taskController.taskList[_index];
                  //////////////////////////////////////////////
                  if (checkIfTaskMatchSelectedDate(task)) {
                    ////////////////
                    DateTime dateTime = DateFormat.jm().parse(task.startTime!);
                    TimeOfDay time = TimeOfDay.fromDateTime(dateTime);
                    print('Hour : ${time.hour} && Minute : ${time.minute}');
                    _notifyHelper.scheduledNotification(
                        time.hour, time.minute, task);
                    //////////////////////////
                    return AnimationConfiguration.staggeredList(
                      position: _index,
                      duration: const Duration(milliseconds: 600),
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: InkWell(
                            onTap: () {
                              showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }

  ////////////////////////////
  Future<void> _onRefreshMethod() async {
    _taskController.getTasks();
  }
  ////////////////////////////

  ////////////////////////////////////////////////////////////
  Stack _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(seconds: 2),
          child: RefreshIndicator(
            displacement: 10,
            onRefresh: _onRefreshMethod,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizedBox(
                    height: SizeConfig.orientation == Orientation.landscape
                        ? 10.0
                        : 150.0,
                  ),
                  SvgPicture.asset(
                    'assets/images/task.svg',
                    height: 100,
                    color: primaryClr.withOpacity(0.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'You do not have any tasks yet!\nAdd new tasks to make your days productive',
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.orientation == Orientation.landscape
                        ? 10.0
                        : 150.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////
  showBottomSheet(BuildContext _c, Task _task) {
    return Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (_task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (_task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.30
                : SizeConfig.screenHeight * 0.40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey,
                ),
              ),
              ///////////////////////////////
              const SizedBox(height: 15),
              ///////////////////////////////
              _task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheet(
                      label: 'Task Completed',
                      onT: () {
                        _taskController.markTaskCompleted(_task.id);
                        _notifyHelper.cancelNotification(_task.id!);
                        Get.back();
                      },
                      clr: primaryClr,
                    ),
              ///////////////////////////////
              _buildBottomSheet(
                label: 'Delete Task',
                onT: () {
                  _taskController.deleteTask(_task.id);
                  _notifyHelper.cancelNotification(_task.id!);
                  Get.back();
                },
                clr: Colors.red[400]!,
              ),
              ///////////////////////////////
              Divider(
                color: Get.isDarkMode ? Colors.grey[300] : Colors.grey[600],
              ),
              ///////////////////////////////
              _buildBottomSheet(
                label: 'Cancel',
                onT: () {
                  Get.back();
                },
                clr: primaryClr,
              ),
              ///////////////////////////////
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      backgroundColor: Get.isDarkMode
          ? const Color.fromARGB(255, 24, 24, 24)
          : Colors.grey[200],
      isDismissible: true,
    );
  }

  ////////////////////////////////////////////////////////////
  _buildBottomSheet({
    required String label,
    required Function() onT,
    required Color clr,
    bool isClose = false,
  }) {
    return InkWell(
      enableFeedback: true, //
      onTap: onT,
      child: Container(
        width: SizeConfig.screenWidth * 0.9,
        height: 50.0,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 2.0,
            color: isClose
                ? (Get.isDarkMode ? Colors.grey[600] : Colors.grey[300])!
                : clr,
          ),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: titleStyle.copyWith(color: white),
          ),
        ),
      ),
    );
  }
}
