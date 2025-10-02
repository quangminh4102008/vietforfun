package com.tiengviet.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
public class DBConnection {
    private static Connection connection;

    public static Connection getConnection() {
        // Chỉ kết nối nếu chưa có kết nối nào
        if (connection == null) {
            try {
                // Lấy chuỗi kết nối từ biến môi trường của Render
                String dbUrl = System.getenv("DATABASE_URL");

                // Nếu không tìm thấy biến môi trường (ví dụ khi chạy ở máy local)
                if (dbUrl == null || dbUrl.isEmpty()) {
                    throw new RuntimeException("DATABASE_URL environment variable is not set.");
                }

                Class.forName("org.postgresql.Driver");
                connection = DriverManager.getConnection(dbUrl);
                System.out.println("Connected to PostgreSQL database!");

            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
                throw new RuntimeException("Failed to connect to the database.", e);
            }
        }
        return connection;
    }
}