package com.tiengviet.entity;

import java.sql.Timestamp;

public class Resource {
    private int id;
    private String title;
    private String type;        // PDF, Video, Audio, Website
    private String url;
    private String description;
    private Timestamp uploadedAt;
    private String imageUrl;
    private String content;
    private boolean isVisible;
    private String uploadedBy;
    private boolean isDeleted;

    public Resource() {}

    public Resource(int id, String title, String type, String url, String description, boolean isVisible, String uploadedBy,  Timestamp uploadedAt,  String imageUrl, String content, boolean isDeleted) {
        this.id = id;
        this.title = title;
        this.type = type;
        this.url = url;
        this.description = description;
        this.isVisible = isVisible;
        this.uploadedBy = uploadedBy;
        this.uploadedAt = new Timestamp(System.currentTimeMillis());
        this.imageUrl = imageUrl;
        this.content = content;
        this.isDeleted = isDeleted;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public boolean isVisible() { return isVisible; }
    public void setVisible(boolean visible) { isVisible = visible; }

    public String getUploadedBy() { return uploadedBy; }
    public void setUploadedBy(String uploadedBy) { this.uploadedBy = uploadedBy; }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }
}
