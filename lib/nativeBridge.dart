import 'dart:async';
import 'package:flutter/services.dart';
import "package:transfer_files/Connections/connections.dart";
// import "package:transfer_files/Connections/cLogs.dart" ; // Adjust import as needed

const MethodChannel logChannel = MethodChannel('your_channel_name');

class NativeBridge {
  static final NativeBridge _instance = NativeBridge._internal();
  factory NativeBridge() => _instance;

  NativeBridge._internal() {
    logChannel.setMethodCallHandler(_handleMethodCall);
  }

  // Stream for log events
  final StreamController<String> _logStreamController = StreamController.broadcast();
  Stream<String> get logStream => _logStreamController.stream;

  // Stream for Active profile updates (optional, if needed in UI)
  final StreamController<Active> _activeStreamController = StreamController.broadcast();
  Stream<Active> get activeStream => _activeStreamController.stream;

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "log":
        final log = call.arguments;
        _logStreamController.add(log);
        break;

      case "setActive":
        try {
          final ab = Active(
            ip: call.arguments['ip'],
            port: call.arguments['port'],
            mode: call.arguments['mode'],
          );

          Active.addActive(ab);
          _activeStreamController.add(ab); // Optional if you want to listen to new actives
          print("🔥🔥🔥 Active profiles: ${Active.getActive()}");
        } catch (e, stack) {
          print("🔥🔥🔥 Error in addActive: $e");
          print(stack);
        }
        break;

      default:
        print("Unknown method: ${call.method}");
    }
  }
}
