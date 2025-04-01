package com.example.transfer_files;

import android.content.Context;
import io.flutter.plugin.common.MethodChannel;
import java.io.*;
import java.net.*;
import java.util.concurrent.*;
import android.os.Handler;
import android.os.Looper;

public class Server {
    private static ServerSocket serverSocket;
    private static final ExecutorService executorService = Executors.newFixedThreadPool(4);
    private static final ExecutorService diskWriterExecutor = Executors.newFixedThreadPool(2);
    private static MethodChannel logChannel;
    private static Context appContext;
    private static final Handler mainHandler = new Handler(Looper.getMainLooper());

    public static void startServer(String ip, int port, MethodChannel logChannel, Context context) {
        Server.logChannel = logChannel;
        Server.appContext = context;

        new Thread(() -> {
            try {
                serverSocket = new ServerSocket(port, 50, InetAddress.getByName(ip));
                logToFlutter("Server started on " + ip + ":" + port);

                while (!serverSocket.isClosed()) {
                    Socket clientSocket = serverSocket.accept();
                    clientSocket.setTcpNoDelay(true);
                    clientSocket.setReceiveBufferSize(1024 * 1024);
                    String clientIP = clientSocket.getInetAddress().getHostAddress();
                    logToFlutter("Client connected: " + clientIP);

                    executorService.submit(() -> handleClient(clientSocket, clientIP));
                }
            } catch (IOException e) {
                logToFlutter("Server error: " + e.getMessage());
            }
        }).start();
    }

    public static void stopServer() {
        try {
            if (serverSocket != null) {
                serverSocket.close();
                logToFlutter("Server stopped.");
            }
        } catch (IOException e) {
            logToFlutter("Error stopping server: " + e.getMessage());
        }
    }

    private static void handleClient(Socket socket, String clientIP) {
        try (DataInputStream input = new DataInputStream(socket.getInputStream());
             DataOutputStream output = new DataOutputStream(socket.getOutputStream())) {
            
            String requestType = input.readUTF(); // "UPLOAD" or "DOWNLOAD"

            if (requestType.equals("UPLOAD")) {
                receiveFile(input, clientIP);
            } else if (requestType.equals("DOWNLOAD")) {
                String filePath = input.readUTF();
                sendFile(output, filePath);
            }
        } catch (IOException e) {
            logToFlutter("Client error: " + e.getMessage());
        }
    }

    private static void receiveFile(DataInputStream input, String clientIP) {
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

    private static void sendFile(DataOutputStream output, String filePath) {
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
}
