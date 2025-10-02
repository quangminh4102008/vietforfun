package com.tiengviet.utils; // Đảm bảo package này đúng

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

                    // SỬA LỖI Ở ĐÂY: Chuẩn hóa URL cho JDBC
                    String jdbcUrl = "jdbc:" + dbUrlFromEnv;
                    if (jdbcUrl.startsWith("jdbc:postgres://")) {
                        jdbcUrl = jdbcUrl.replace("jdbc:postgres://", "jdbc:postgresql://");
                    }

                    Class.forName("org.postgresql.Driver");
                    connection = DriverManager.getConnection(jdbcUrl); // Dùng chuỗi đã sửa
                    System.out.println("Successfully connected to PostgreSQL database!");

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