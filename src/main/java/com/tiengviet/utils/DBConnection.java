package com.tiengviet.utils;

import java.net.URI;
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

                    // Parse URL từ Render
                    URI dbUri = new URI(dbUrlFromEnv);

                    String username = dbUri.getUserInfo().split(":")[0];
                    String password = dbUri.getUserInfo().split(":")[1];
                    String host = dbUri.getHost();
                    int port = dbUri.getPort() == -1 ? 5432 : dbUri.getPort();
                    String dbName = dbUri.getPath().substring(1); // bỏ dấu '/'

                    // JDBC URL chuẩn
                    String jdbcUrl = String.format(
                            "jdbc:postgresql://%s:%d/%s?sslmode=require",
                            host, port, dbName
                    );

                    Class.forName("org.postgresql.Driver");
                    connection = DriverManager.getConnection(jdbcUrl, username, password);

                    System.out.println("✅ SUCCESS: Connected to PostgreSQL on Render!");
                } catch (Exception e) {
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
