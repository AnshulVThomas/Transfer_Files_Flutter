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

                    executorService.submit(() -> Controler.handle(clientSocket, clientIP));
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
                 FileDownloader.setLogChannel(logChannel);
                FileDownloader.receiveFile(input, clientIP);
            } else if (requestType.equals("DOWNLOAD")) {
                String filePath = input.readUTF();
                FileUploader.sendFile(output, filePath);
            }
        } catch (IOException e) {
            logToFlutter("Client error: " + e.getMessage());
        }
    }
     private static void logToFlutter(String message) {
        if (logChannel != null) {
            mainHandler.post(() -> logChannel.invokeMethod("log", message));
        }
    }
}
