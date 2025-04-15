package com.example.transfer_files;

import android.content.Context;
import io.flutter.plugin.common.MethodChannel;
import java.io.*;
import java.net.*;
import java.util.concurrent.*;
import android.os.Handler;
import android.os.Looper;

public class FileUploader{

          
         private static MethodChannel logChannel;
           private static final Handler mainHandler = new Handler(Looper.getMainLooper());


    










       public static void sendFile(DataOutputStream output, String filePath) {
        File file = new File(filePath);
        if (!file.exists()) {
            logToFlutter("File not found: " + filePath);
            return;
        }

        try (FileInputStream input = new FileInputStream(file);
             BufferedOutputStream bufferedOutput = new BufferedOutputStream(output)) {
            
            output.writeUTF(file.getName());
            output.writeLong(file.length());

            byte[] buffer = new byte[65536];
            long totalBytesSent = 0;
            int bytesRead;
            long startTime = System.currentTimeMillis();

            while ((bytesRead = input.read(buffer)) != -1) {
                bufferedOutput.write(buffer, 0, bytesRead);
                totalBytesSent += bytesRead;

                int progress = (int) ((totalBytesSent * 100) / file.length());
                double speed = (totalBytesSent / (1024.0 * 1024.0)) / ((System.currentTimeMillis() - startTime) / 1000.0 + 1);
                logToFlutter("[Download] Progress: " + progress + "% - Speed: " + String.format("%.2f", speed) + " MB/s");
            }

            logToFlutter("File sent successfully.");
        } catch (IOException e) {
            logToFlutter("File send error: " + e.getMessage());
        }
    }

    private static void logToFlutter(String message) {
        if (logChannel != null) {
            mainHandler.post(() -> logChannel.invokeMethod("log", message));
        }
    }

    public static void setLogChannel(MethodChannel channel) {
    logChannel = channel;
}

}




