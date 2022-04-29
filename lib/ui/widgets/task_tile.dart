import 'package:flutter/material.dart';
import '/models/task.dart';
import '/ui/size_config.dart';
import '/ui/theme.dart';

class TaskTile extends StatelessWidget {
  const TaskTile(this.task, {Key? key}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(
          SizeConfig.orientation == Orientation.landscape ? 4.0 : 20.0,
        ),
      ),
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: task.color == 0
              ? primaryClr
              : task.color == 1
                  ? pinkClr
                  : orangeClr,
        ),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            //////////////////////////////////////
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title!,
                      style: specialTextStyle(16, white, FontWeight.bold),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 12.0),
                        Text(
                          '${task.startTime} - ${task.endTime}',
                          style: specialTextStyle(
                              13, Colors.grey[100]!, FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      task.note!,
                      style: specialTextStyle(
                          14, Colors.grey[100]!, FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
            //////////////////////////////////////
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.6),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task.isCompleted == 0 ? 'TODO' : 'Completed',
                style: specialTextStyle(10, white, FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
