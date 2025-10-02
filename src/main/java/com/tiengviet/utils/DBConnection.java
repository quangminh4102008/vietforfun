// PHIÊN BẢN HOÀN CHỈNH - SỬA LỖI PARSE URL
package com.tiengviet.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static Connection connection;

    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                try {
                    String dbUrlFromEnv = System.getenv("DATABASE_URL");

                    if (dbUrlFromEnv == null || dbUrlFromEnv.isEmpty()) {
                        System.err.println("CRITICAL ERROR: DATABASE_URL environment variable is not set.");
                        throw new RuntimeException("DATABASE_URL environment variable is not set.");
                    }

                    // Bước 1: Chuẩn hóa tiền tố cho JDBC
                    String jdbcUrl = "jdbc:" + dbUrlFromEnv;
                    if (jdbcUrl.startsWith("jdbc:postgres://")) {
                        jdbcUrl = jdbcUrl.replace("jdbc:postgres://", "jdbc:postgresql://");
                    }

                    // Bước 2: Thêm tham số sslmode=require để tương thích với Render
                    // Kiểm tra xem URL đã có dấu '?' chưa
                    if (jdbcUrl.contains("?")) {
                        jdbcUrl += "&sslmode=require";
                    } else {
                        jdbcUrl += "?sslmode=require";
                    }

                    Class.forName("org.postgresql.Driver");
                    connection = DriverManager.getConnection(jdbcUrl);
                    System.out.println("FINAL SUCCESS: Successfully connected to PostgreSQL database on Render!");

                } catch (ClassNotFoundException | SQLException e) {
                    e.printStackTrace();
                    throw new RuntimeException("Failed to connect to the database.", e);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            connection = null;
        }
        return connection;
    }
}