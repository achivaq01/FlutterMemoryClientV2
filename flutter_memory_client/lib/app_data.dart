import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memory_client/show_toast.dart';
import 'package:web_socket_channel/io.dart';

enum ConnectionStatus {
  disconnected,
  disconnecting,
  connecting,
  waiting,
  connected
}

typedef ToastCallback = void Function({
  BuildContext? context,
  String? title,
  Duration? autoCloseDuration,
});

class AppData with ChangeNotifier {
  String ip = "localhost";
  String port = "8888";
  String name = "";
  String uuid = "";
  int paintColumn = -1;
  int paintRow = -1;
  int movements = 0;
  Color paintColor = Colors.black12;
  bool repaint = true;
  late var cellList;

  IOWebSocketChannel? _socketClient;
  ConnectionStatus connectionStatus = ConnectionStatus.disconnected;

  String messages = "";

  AppData() {
    _getLocalIpAddress();
  }

  void _getLocalIpAddress() async {
    try {
      final List<NetworkInterface> interfaces = await NetworkInterface.list(
          type: InternetAddressType.IPv4, includeLoopback: false);
      if (interfaces.isNotEmpty) {
        final NetworkInterface interface = interfaces.first;
        final InternetAddress address = interface.addresses.first;
        ip = address.address;
        notifyListeners();
      }
    } catch (e) {
      // ignore: avoid_print
      print("Can't get local IP address : $e");
    }
  }

  void connectToServer() async {
    connectionStatus = ConnectionStatus.connecting;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 3));

    _socketClient = IOWebSocketChannel.connect("ws://$ip:$port");
    _socketClient!.stream.listen(
      (message) {
        final data = jsonDecode(message);
        print(data);

        if (connectionStatus != ConnectionStatus.connected) {
          connectionStatus = ConnectionStatus.waiting;
        }

        switch (data['type']) {
          case 'connection':
            if (data['status'] != 'connected') {
              //TODO
              return;
            }
            ShowFlutterToast singletonToast = ShowFlutterToast.instance;
            singletonToast.showToastFunction(
                'Connected!', 'Connected to the server');
            sendMessage('connection', 'status', 'connected', 'name', name);
            break;

          case 'UUID':
            uuid = data['UUID'];

          case 'game':
            if (data['status'] == 'start') {
              connectionStatus = ConnectionStatus.connected;
              notifyListeners();
              cellList = data['board'];
              repaint = true;

              print(cellList);
            } else {
              ShowFlutterToast singletonToast = ShowFlutterToast.instance;
              singletonToast.showMyDialog(data['ranking']);
            }
            break;

          case 'request color':
            String hexadecimalColor= data['color'];
            Color newColor = Color(HexColor.getColorFromHex(hexadecimalColor));
            paintColor = newColor;

            break;

          case 'repaint':
            repaint = true;
            cellList = data['board'];
            break;

          case 'turn':
            ShowFlutterToast singletonToast = ShowFlutterToast.instance;
            singletonToast.showToastFunction(
                'Its your turn!', '');
            break;

          default:
            messages += "Message from '${data['from']}': ${data['value']}\n";
            break;
        }

        notifyListeners();
      },
      onError: (error) {
        connectionStatus = ConnectionStatus.disconnected;
        notifyListeners();
      },
      onDone: () {
        //sendMessage('connection', 'status', 'disconnection', 'UUID', uuid);
        connectionStatus = ConnectionStatus.disconnected;
        notifyListeners();
      },
    );
  }

  sendMessage(String typeValue, String key1, String value1, String key2,
      String value2) {
    final message = {'type': typeValue, key1: value1, key2: value2};
    _socketClient!.sink.add(jsonEncode(message));
  }

  void disconnectFromServer() async {
    sendMessage('connection', 'status', 'disconnection', 'UUID', uuid);
    connectionStatus = ConnectionStatus.disconnected;
    _socketClient?.sink.close();

    notifyListeners();
  }

  void playAgain() async {
    sendMessage('play again', 'UUID', uuid, '', '');
    connectionStatus = ConnectionStatus.waiting;
    notifyListeners();
  }

}

class HexColor extends Color {
  static int getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(getColorFromHex(hexColor));
}

