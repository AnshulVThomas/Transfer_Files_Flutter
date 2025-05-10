package com.example.transfer_files;

import java.util.HashMap;
import java.util.Map;


import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.provider.Settings;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String SERVER_CHANNEL = "com.example.transfer_files/server";
    private static final String LOG_CHANNEL = "com.example.transfer_files/logs";
    private MethodChannel logChannel;
    private final Handler mainThreadHandler = new Handler(Looper.getMainLooper());

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        logChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), LOG_CHANNEL);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), SERVER_CHANNEL)
                .setMethodCallHandler((call, result) -> {
                   switch (call.method) {
                case "startServer":
                    String ip = call.argument("ip");
                    int port = call.argument("port");

                    if (!checkPermissions()) {
                        requestPermissions();
                        result.error("PERMISSION_ERROR", "Storage permission required", null);
                        return;
                    }

                    new Thread(() -> {
                        try {
                            Server.startServer(ip, port, logChannel, getApplicationContext());
                            mainThreadHandler.post(() -> result.success("Server started"));
                        } catch (Exception e) {
                            mainThreadHandler.post(() ->
                                result.error("SERVER_ERROR", "Failed to start server: " + e.getMessage(), null));
                        }
                    }).start();
                    break;

                case "startClient":
                    String serverIp = call.argument("ip");
                    int serverPort = call.argument("port");
                    String mode = call.argument("mode");
                    String filePath = call.argument("filePath");

                    if (!checkPermissions()) {
                        requestPermissions();
                        result.error("PERMISSION_ERROR", "Storage permission required", null);
                        return;
                    }

                    new Thread(() -> {
                        try {
                            Client.startClient(serverIp, serverPort, mode, filePath, logChannel);
                            mainThreadHandler.post(() -> result.success("Client started"));
                             mainThreadHandler.post(() -> {
                        if (logChannel != null) {
                            HashMap<String, Object> args = new HashMap<>();
                            args.put("ip", "192.168.1.10");
                            args.put("port", "8080");
                            args.put("mode","client");
                            logChannel.invokeMethod("setActive", args);
            }
        });
                        } catch (Exception e) {
                            mainThreadHandler.post(() ->
                                result.error("CLIENT_ERROR", "Failed to start client: " + e.getMessage(), null));
                        }
                    }).start();
                    
                    break;

                case "stopClient":
                    Client.stopClient();
                    result.success("Client stopped");
                break;

                case "stopServer":
                    Server.stopServer();
                    result.success("Server stopped");
                    break;

                default:
                    result.notImplemented();
            }
                });
    }

    private boolean checkPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {  // Android 11+
            return Environment.isExternalStorageManager();
        } else {
            return ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED;
        }
    }

    private void requestPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {  // Android 11+
            try {
                Intent intent = new Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION);
                intent.setData(Uri.parse("package:" + getPackageName()));
                startActivity(intent);
            } catch (Exception e) {
                Intent intent = new Intent();
                intent.setAction(Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION);
                startActivity(intent);
            }
        } else {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        
        if (requestCode == 1) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {  // Android 11+
                if (Environment.isExternalStorageManager()) {
                    logToFlutter("Permission granted.");
                } else {
                    logToFlutter("Permission denied. Please enable 'Manage All Files' in settings.");
                }
            } else {  // Android 10 and below
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    logToFlutter("Permission granted.");
                } else {
                    logToFlutter("Permission denied.");
                }
            }
        }
    }

    private void logToFlutter(String message) {
        mainThreadHandler.post(() -> {
            if (logChannel != null) {
                logChannel.invokeMethod("log", message);
            }
        });
    }
}
