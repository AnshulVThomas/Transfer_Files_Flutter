
import "package:permission_handler/permission_handler.dart";
Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      requestCameraPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // Opens the app-specific settings page
    }
    return false;
  }