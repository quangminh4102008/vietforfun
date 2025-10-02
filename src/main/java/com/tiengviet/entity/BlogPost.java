package com.tiengviet.entity;

public class BlogPost {
    private String title;
    private String description;
    private String imageUrl;
    private String category;
    private String slug;
    private String content;

    // Sửa lại constructor cho đúng thứ tự và bỏ đi postUrl không cần thiết
    public BlogPost(String title, String description, String imageUrl, String category, String slug, String content) {
        this.title = title;
        this.description = description;
        this.imageUrl = imageUrl;
        this.category = category;
        this.slug = slug;
        this.content = content;
    }

    // --- Các Getters và Setters giữ nguyên (hoặc có thể bỏ Setters nếu không cần) ---

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}