package com.example.transfer_files;

import java.io.*;
import java.net.Socket;
import android.os.Handler;
import android.os.Looper;
import io.flutter.plugin.common.MethodChannel;

public class Controler {

    private static MethodChannel logChannel;
    private static final Handler mainHandler = new Handler(Looper.getMainLooper());

    public static void setLogChannel(MethodChannel channel) {
        logChannel = channel;
    }





    public static void handle(Socket socket, String clientIP) {
        try (DataInputStream input = new DataInputStream(socket.getInputStream());
             DataOutputStream output = new DataOutputStream(socket.getOutputStream())) {

            String requestType = input.readUTF();

            if (requestType.equals("UPLOAD")) {
                FileDownloader.setLogChannel(logChannel);
                FileDownloader.receiveFile(input, clientIP);
            } else if (requestType.equals("DOWNLOAD")) {
                String filePath = input.readUTF();
                FileUploader.setLogChannel(logChannel);
                FileUploader.sendFile(output, filePath);
            }
        } catch (IOException e) {
            logToFlutter("Client error: " + e.getMessage());
        }
    }





    private static void logToFlutter(String message) {
        if (logChannel != null) {
            mainHandler.post(() -> logChannel.invokeMethod("log", message));
        } else {
            System.out.println("[ClientHandler] " + message);
        }
    }



    
}
