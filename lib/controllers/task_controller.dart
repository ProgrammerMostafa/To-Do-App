import 'package:flutter/material.dart';
import 'package:flutter_advanced_testing/db/db_helper.dart';
import 'package:flutter_advanced_testing/models/task.dart';
import 'package:flutter_advanced_testing/services/notification_services.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

class TaskController extends GetxController {
  RxList<Task> taskList = <Task>[].obs;

  NotifyHelper notify = NotifyHelper();

  /////////////////////////////////////////////
  Future<int> addTask(Task task) async {
    // DateTime date = DateFormat.jm().parse(task.startTime!);
    // TimeOfDay time = TimeOfDay.fromDateTime(date);
    // print('Hour : ${time.hour} && minute : ${time.minute}');
    // notify.initializeNotification();
    // notify.scheduledNotification(time.hour, time.minute, task);
    return DBHelper.insert_row_DB(task);
  }

  /////////////////////////////////////////////
  void getTasks() async {
    List<Map<String, dynamic>> returnTasks = await DBHelper.query_DB();
    taskList.assignAll(returnTasks.map((data) => Task.fromMap(data)).toList());
  }

  /////////////////////////////////////////////
  deleteTask(int? id) async {
    await DBHelper.delete_row_DB(id!);
    getTasks();
  }

  /////////////////////////////////////////////
  deleteAllTask() async {
    await DBHelper.delete_all();
    getTasks();
  }

  /////////////////////////////////////////////
  markTaskCompleted(int? id) async {
    await DBHelper.update_row_DB(id!);
    getTasks();
  }
}
