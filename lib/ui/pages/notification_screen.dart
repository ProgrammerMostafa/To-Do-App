import 'package:flutter/material.dart';
import 'package:flutter_advanced_testing/ui/theme.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  final String payload;
  const NotificationScreen({
    Key? key,
    required this.payload,
  }) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = '';
  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        title: Text(
          _payload.toString().split('|')[0],
          style: const TextStyle(
            color: white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 22,
            color: primaryClr,
          ),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                Text(
                  'Hello, Mostafa',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Get.isDarkMode ? white : darkGreyClr,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'You have a new reminder',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: primaryClr,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.text_format,
                            size: 35,
                            color: white,
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Title',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          )
                        ],
                      ),
                      ///////////////////////////////
                      const SizedBox(height: 20),
                      ///////////////////////////////
                      Text(
                        _payload.toString().split('|')[0],
                        style: const TextStyle(
                          color: white,
                          fontSize: 20,
                        ),
                      ),
                      ///////////////////////////////
                      const SizedBox(height: 20),
                      ///////////////////////////////
                      Row(
                        children: const [
                          Icon(
                            Icons.description,
                            size: 35,
                            color: white,
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          )
                        ],
                      ),
                      //////////////////////////////////
                      const SizedBox(height: 20),
                      //////////////////////////////////
                      Text(
                        _payload.toString().split('|')[1],
                        style: const TextStyle(
                          color: white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      ///////////////////////////////
                      const SizedBox(height: 20),
                      ///////////////////////////////
                      Row(
                        children: const [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 35,
                            color: white,
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          )
                        ],
                      ),
                      //////////////////////////////////
                      const SizedBox(height: 20),
                      //////////////////////////////////
                      Text(
                        _payload.toString().split('|')[2],
                        style: const TextStyle(
                          color: white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
