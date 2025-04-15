package com.example.transfer_files;

import android.os.Handler;
import android.os.Looper;
import io.flutter.plugin.common.MethodChannel;

import java.io.*;
import java.net.Socket;

public class Client {
    private static MethodChannel logChannel;
    private static final Handler mainHandler = new Handler(Looper.getMainLooper());
    
    // ✅ Declare socket as a static field so it's accessible from both startClient and stopClient
    private static Socket socket;

    public static void startClient(String ip, int port, String mode, String filePath, MethodChannel channel) {
        logChannel = channel;

        new Thread(() -> {
            try {
                socket = new Socket(ip, port);  // ✅ Assign to the static socket
                logToFlutter("Connected to server: " + ip + ":" + port);

                DataOutputStream output = new DataOutputStream(socket.getOutputStream());
                DataInputStream input = new DataInputStream(socket.getInputStream());

                Controler.setLogChannel(logChannel);

                if (mode.equalsIgnoreCase("UPLOAD")) {
                    File file = new File(filePath);
                    if (!file.exists()) {
                        logToFlutter("File not found: " + filePath);
                        return;
                    }

                    output.writeUTF("UPLOAD");
                    output.writeUTF(file.getName());
                    output.writeLong(file.length());

                    FileUploader.setLogChannel(logChannel);
                    FileUploader.sendFile(output, filePath);

                } else if (mode.equalsIgnoreCase("DOWNLOAD")) {
                    output.writeUTF("DOWNLOAD");
                    output.writeUTF(filePath);

                    Controler.handle(socket, "localhost");
                } else {
                    logToFlutter("Invalid mode. Use 'UPLOAD' or 'DOWNLOAD'.");
                }

            } catch (IOException e) {
                logToFlutter("Client error: " + e.getMessage());
            }
        }).start();
    }

    public static void stopClient() {
        try {
            if (socket != null && !socket.isClosed()) {
                socket.close();
                logToFlutter("Client connection closed.");
            }
        } catch (IOException e) {
            logToFlutter("Error stopping client: " + e.getMessage());
        }
    }

    private static void logToFlutter(String message) {
        if (logChannel != null) {
            mainHandler.post(() -> logChannel.invokeMethod("log", message));
        } else {
            System.out.println("[Client] " + message);
        }
    }
}
