package com.tiengviet.entity;

public class Course {
    private int id;
    private String title;
    private String description;
    private String level;
    private boolean isPublished;
    private String thumbnailUrl;
    public Course() {}
    private String status;

    public Course(int id, String title, String description, String level, boolean isPublished, String thumbnailUrl, String status) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.level = level;
        this.isPublished = isPublished;
        this.thumbnailUrl = thumbnailUrl;
        this.status = status;
}
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }
    public boolean isPublished() { return isPublished; }
    public void setPublished(boolean published) { isPublished = published; }

    public String getThumbnailUrl() { return thumbnailUrl; }
    public void setThumbnailUrl(String thumbnailUrl) { this.thumbnailUrl = thumbnailUrl; }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
