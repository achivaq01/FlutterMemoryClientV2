import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'app_data.dart';

class ShowFlutterToast {
  ShowFlutterToast._();

  BuildContext? _contextToUse;

  static final ShowFlutterToast _instance = ShowFlutterToast._();

  static ShowFlutterToast get instance => _instance;

  void setContext(BuildContext context) {
    _instance._contextToUse = context;
  }

  void showToastFunction(String toastTile, String toastDescription) {
    if (_contextToUse != null) {
      toastification.show(
        type: ToastificationType.success,
        context: _contextToUse!,
        title: toastTile,
        description: toastDescription,
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topCenter,
      );
    } else {
      throw Exception("couldn't show toast");
    }
  }

  Future<void> showMyDialog(String textBody) async {
    AppData appData = Provider.of<AppData>(_contextToUse!, listen: false);
    return showCupertinoDialog<void>(
      context: _contextToUse!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Game Over!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('RANKING:'),
                Text(textBody),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoButton(
              child: const Text('Play Again'),
              onPressed: () {
                appData.playAgain();
                Navigator.of(context).pop();
              },
            ),
            CupertinoButton(
              child: const Text('Exit'),
              onPressed: () {
                appData.disconnectFromServer();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
