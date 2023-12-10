import 'package:flutter/cupertino.dart';
import 'package:flutter_memory_client/layout_connecting.dart';
import 'package:flutter_memory_client/layout_game.dart';
import 'package:flutter_memory_client/layout_main.dart';
import 'package:flutter_memory_client/layout_waiting.dart';
import 'package:provider/provider.dart';

import 'app_data.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  Widget _setLayout(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    switch (appData.connectionStatus) {
      case ConnectionStatus.connecting:
        return const LayoutConnecting();
      case ConnectionStatus.waiting:
        return const LayoutWaiting();
      case ConnectionStatus.connected:
        return const LayoutGame();
      default:
        return const LayoutMain();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: const CupertinoThemeData(brightness: Brightness.light),
        home: _setLayout(context),
    );
  }
}
