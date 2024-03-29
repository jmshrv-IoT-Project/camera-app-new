import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';

import 'models/CameraServerApiModels.dart';
import 'services/CameraServerApiHelper.dart';
import 'screens/SplashScreen.dart';
import 'screens/LoginScreen.dart';
import 'screens/CamerasScreen.dart';
import 'screens/NewCameraScreen.dart';
import 'screens/SelectedCameraScreen.dart';

void main() async {
  _setupLogging();
  await _setupHive();
  _setupCameraServerApiHelper();
  runApp(CameraApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) =>
      print("[${event.level.name}] ${event.time}: ${event.message}"));
}

Future<void> _setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CurrentUserAdapter());
  await Future.wait([
    Hive.openBox<User>("Users"),
    Hive.openBox<CurrentUser>("CurrentUser"),
  ]);
}

void _setupCameraServerApiHelper() {
  GetIt.instance.registerSingleton(CameraServerApiHelper());
}

class CameraApp extends StatelessWidget {
  const CameraApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Camera App",
      routes: {
        "/": (context) => SplashScreen(),
        "/login": (context) => LoginScreen(),
        "/cameras": (context) => CamerasScreen(),
        "/newCamera": (context) => NewCameraScreen(),
        "/camera": (context) => SelectedCameraScreen(),
      },
      initialRoute: "/",
    );
  }
}
