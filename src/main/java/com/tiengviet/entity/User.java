package com.tiengviet.entity;

public class User {
    private int id;
    private String username;
    private String hashPassword;
    private String email;
    private String role;        // 'user' or 'admin'
    private boolean isActive;
    private String level;
    // Constructors
    public User() {
    }

    public User(int id, String username, String hashPassword, String email, String role, boolean isActive, String level) {
        this.id = id;
        this.username = username;
        this.hashPassword = hashPassword;
        this.email = email;
        this.role = role;
        this.isActive = isActive;
        this.level = level;
    }

    // Getters & Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getHashPassword() {
        return hashPassword;
    }

    public void setHashPassword(String hashPassword) {
        this.hashPassword = hashPassword;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        this.isActive = active;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }
}
