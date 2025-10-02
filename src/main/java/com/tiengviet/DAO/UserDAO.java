package com.tiengviet.DAO;

import com.tiengviet.entity.User;
import com.tiengviet.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import static com.tiengviet.utils.DBConnection.getConnection;

public class UserDAO {

    public boolean registerUser(User user) throws SQLException {
        String sql = "INSERT INTO users (username, email, hash_password, role, is_active, level) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getHashPassword());
            stmt.setString(4, user.getRole());
            stmt.setBoolean(5, user.isActive());
            stmt.setString(6, user.getLevel());

            return stmt.executeUpdate() > 0;
        }
    }

    public static User getUserByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("hash_password"),
                        rs.getString("email"),
                        rs.getString("role"),
                        rs.getBoolean("is_active"),
                        rs.getString("level")
                );
            }
        }
        return null;
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                User user = new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("hash_password"),
                        rs.getString("email"),
                        rs.getString("role"),
                        rs.getBoolean("is_active"),
                        rs.getString("level")
                );
                users.add(user);
            }
        }
        return users;
    }

    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE users SET username=?, email=?, hash_password=?, role=?, is_active=?, level=? WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getHashPassword());
            stmt.setString(4, user.getRole());
            stmt.setBoolean(5, user.isActive());
            stmt.setString(6, user.getLevel());
            stmt.setInt(7, user.getId());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }


    public void softDeleteUser(int userId) throws SQLException {
        String sql = "UPDATE users SET is_active = false WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.executeUpdate();
        }
    }

    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("hash_password"),
                        rs.getString("email"),
                        rs.getString("role"),
                        rs.getBoolean("is_active"),
                        rs.getString("level")
                );
            }
        }
        return null;
    }
    public static boolean activateUserByEmail(String email) throws SQLException {
        String sql = "UPDATE users SET is_active = true WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    public boolean updatePasswordByEmail(String email, String newHashedPassword) throws SQLException {
        String sql = "UPDATE users SET hash_password = ? WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newHashedPassword);
            stmt.setString(2, email);

            return stmt.executeUpdate() > 0;
        }
    }

}
