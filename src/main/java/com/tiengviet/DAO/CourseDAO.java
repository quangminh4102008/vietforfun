package com.tiengviet.DAO;

import com.tiengviet.entity.Course;
import com.tiengviet.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {
    public List<Course> getAllActiveCourses() throws SQLException {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT * FROM courses WHERE status = 'active'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Course c = new Course();
                c.setId(rs.getInt("id"));
                c.setTitle(rs.getString("title"));
                c.setDescription(rs.getString("description"));
                c.setLevel(rs.getString("level"));
                c.setPublished(rs.getBoolean("is_published"));
                c.setThumbnailUrl(rs.getString("thumbnail_url"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }
        }
        return list;
}
    public void addCourse(Course course) throws SQLException {
        String sql = "INSERT INTO courses (title, description, level, is_published, thumbnail_url, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, course.getTitle());
            stmt.setString(2, course.getDescription());
            stmt.setString(3, course.getLevel());
            stmt.setBoolean(4, course.isPublished());
            stmt.setString(5, course.getThumbnailUrl());
            stmt.setString(6, course.getStatus());
            stmt.executeUpdate();
        }
    }
    public List<Course> getPublishedCourses() throws SQLException {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM courses WHERE status = 'active' AND is_published = true";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("id"));
                course.setTitle(rs.getString("title"));
                course.setDescription(rs.getString("description"));
                course.setLevel(rs.getString("level"));
                course.setStatus(rs.getString("status"));
                course.setPublished(rs.getBoolean("is_published"));
                course.setThumbnailUrl(rs.getString("thumbnail_url"));
                courses.add(course);
            }
        }

        return courses;
    }

    public void updateCourse(Course course) throws SQLException {
        String sql = "UPDATE courses SET title=?, description=?, level=?, is_published=?, thumbnail_url=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, course.getTitle());
            stmt.setString(2, course.getDescription());
            stmt.setString(3, course.getLevel());
            stmt.setBoolean(4, course.isPublished());
            stmt.setString(5, course.getThumbnailUrl());
            stmt.setInt(6, course.getId());
            stmt.executeUpdate();
        }
    }
    public void softDeleteCourse(int id) throws SQLException {
        String sql = "UPDATE courses SET status = 'deleted' WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public Course getCourseById(int id) throws SQLException {
        String sql = "SELECT * FROM courses WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Course(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("level"),
                        rs.getBoolean("is_published"),
                        rs.getString("thumbnail_url"),
                        rs.getString("status")
                );
            }
        }
        return null;
    }
    public List<Course> filterCourses(String search, String level, String status, String sort) throws SQLException {
        List<Course> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM courses WHERE 1=1");

        if (search != null && !search.isEmpty()) {
            sql.append(" AND (title LIKE ? OR description LIKE ?)");
        }
        if (level != null && !level.isEmpty()) {
            sql.append(" AND level = ?");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
        }

        if (sort != null && !sort.isEmpty()) {
            sql.append(" ORDER BY ").append(sort);
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (search != null && !search.isEmpty()) {
                stmt.setString(idx++, "%" + search + "%");
                stmt.setString(idx++, "%" + search + "%");
            }
            if (level != null && !level.isEmpty()) {
                stmt.setString(idx++, level);
            }
            if (status != null && !status.isEmpty()) {
                stmt.setString(idx++, status);
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Course c = new Course(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("level"),
                        rs.getBoolean("is_published"),
                        rs.getString("thumbnail_url"),
                        rs.getString("status")
                );
                list.add(c);
            }
        }
        return list;
    }


}
