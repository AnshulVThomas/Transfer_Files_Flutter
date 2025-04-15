package com.example.transfer_files;

import android.content.Context;
import io.flutter.plugin.common.MethodChannel;
import java.io.*;
import java.net.*;
import java.util.concurrent.*;
import android.os.Handler;
import android.os.Looper;

public class FileDownloader{
        private static final ExecutorService diskWriterExecutor = Executors.newFixedThreadPool(2);
          private static MethodChannel logChannel;
           private static final Handler mainHandler = new Handler(Looper.getMainLooper());
         public static void receiveFile(DataInputStream input, String clientIP) {
        try {
            String fileName = input.readUTF();
            long fileSize = input.readLong();

            File outputDir = new File("/storage/emulated/0/MyCustomFolder");
            if (!outputDir.exists()) outputDir.mkdirs();

            File outputFile = new File(outputDir, "received_" + fileName);
            logToFlutter("Receiving file: " + outputFile.getAbsolutePath());

            // Use a pipe stream for non-blocking disk writing
            PipedOutputStream pipedOutput = new PipedOutputStream();
            PipedInputStream pipedInput = new PipedInputStream(pipedOutput);
            diskWriterExecutor.submit(() -> writeToFile(pipedInput, outputFile));

            byte[] buffer = new byte[65536];
            long totalBytesRead = 0;
            int bytesRead;
            long startTime = System.currentTimeMillis();

            while (totalBytesRead < fileSize) {
                bytesRead = input.read(buffer);
                if (bytesRead == -1) break;
                pipedOutput.write(buffer, 0, bytesRead);
                totalBytesRead += bytesRead;

                int progress = (int) ((totalBytesRead * 100) / fileSize);
                double speed = (totalBytesRead / (1024.0 * 1024.0)) / ((System.currentTimeMillis() - startTime) / 1000.0 + 1);
                logToFlutter("[Upload] Progress: " + progress + "% - Speed: " + String.format("%.2f", speed) + " MB/s");
            }
            pipedOutput.close();

            logToFlutter("File received successfully.");
        } catch (IOException e) {
            logToFlutter("File receive error: " + e.getMessage());
        }
    }




     private static void writeToFile(InputStream inputStream, File outputFile) {
        try (BufferedOutputStream fileOutput = new BufferedOutputStream(new FileOutputStream(outputFile))) {
            byte[] buffer = new byte[65536];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                fileOutput.write(buffer, 0, bytesRead);
            }
            logToFlutter("File successfully written to disk: " + outputFile.getAbsolutePath());
        } catch (IOException e) {
            logToFlutter("Error writing file: " + e.getMessage());
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