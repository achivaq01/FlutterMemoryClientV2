import 'dart:io' show Platform;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'app_data.dart';
import 'app.dart';

void main() async {
  // For Linux, macOS and Windows, initialize WindowManager
  try {
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      WidgetsFlutterBinding.ensureInitialized();
      await WindowManager.instance.ensureInitialized();
      windowManager.waitUntilReadyToShow().then(showWindow);
      //windowManager.setSize(const Size(800.0, 600.0));
    }
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }

  // Define the app as a ChangeNotifierProvider
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppData(),
      child: const App(),
    ),
  );
}

// Show the window when it's ready
void showWindow(_) async {
  windowManager.setMinimumSize(const Size(300.0, 600.0));
  await windowManager.setTitle('Memory!');
}
