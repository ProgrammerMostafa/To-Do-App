import 'package:flutter/material.dart';
import 'package:flutter_advanced_testing/db/db_helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/theme_services.dart';
import '../ui/pages/home_page.dart';
import '../ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /////////////////////////////////
  await GetStorage.init();       //
  await DBHelper.initDB();
  /////////////////////////////////
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme, //<----//
      home: const HomePage(),
    );
  }
}
