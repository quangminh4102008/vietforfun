package com.tiengviet.DAO;

import com.tiengviet.entity.Resource;
import com.tiengviet.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ResourceDAO {

    /**
     * Lấy tất cả tài nguyên sẽ hiển thị cho người dùng (is_visible = true và chưa bị xóa).
     */
    public List<Resource> getAllVisibleResources() throws SQLException {
        List<Resource> resourceList = new ArrayList<>();
        // [SỬA] Thêm điều kiện is_deleted = FALSE
        String sql = "SELECT * FROM resources WHERE is_visible = TRUE AND is_deleted = FALSE ORDER BY uploaded_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Resource resource = mapResultSetToResource(rs);
                resourceList.add(resource);
            }
        }
        return resourceList;
    }

    /**
     * Lấy tất cả tài nguyên cho trang quản trị, bao gồm cả tài nguyên ẩn và đã bị xóa mềm.
     */
    public List<Resource> getAllResourcesForAdmin() throws SQLException {
        List<Resource> resourceList = new ArrayList<>();
        String sql = "SELECT * FROM resources ORDER BY id DESC"; // Giữ nguyên để admin thấy hết
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                resourceList.add(mapResultSetToResource(rs));
            }
        }
        return resourceList;
    }

    /**
     * [SỬA] Thêm một tài nguyên mới, đã sửa lỗi thiếu uploaded_at.
     */
    public void addResource(Resource resource) throws SQLException {
        // [SỬA] Thêm uploaded_at vào câu lệnh INSERT.
        // CSDL sẽ tự điền giá trị nếu bạn đã set DEFAULT CURRENT_TIMESTAMP.
        // Nếu không, ta phải truyền giá trị vào. Ở đây tôi giả định bạn chưa sửa DB.
        String sql = "INSERT INTO resources (title, description, type, url, image_url, content, is_visible, uploaded_by, uploaded_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, resource.getTitle());
            stmt.setString(2, resource.getDescription());
            stmt.setString(3, resource.getType());
            stmt.setString(4, resource.getUrl());
            stmt.setString(5, resource.getImageUrl());
            stmt.setString(6, resource.getContent());
            stmt.setBoolean(7, resource.isVisible());
            stmt.setString(8, resource.getUploadedBy());
            stmt.executeUpdate();
        }
    }

    /**
     * Cập nhật một tài nguyên đã có.
     */
    public void updateResource(Resource resource) throws SQLException {
        String sql = "UPDATE resources SET title=?, description=?, type=?, url=?, image_url=?, content=?, is_visible=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, resource.getTitle());
            stmt.setString(2, resource.getDescription());
            stmt.setString(3, resource.getType());
            stmt.setString(4, resource.getUrl());
            stmt.setString(5, resource.getImageUrl());
            stmt.setString(6, resource.getContent());
            stmt.setBoolean(7, resource.isVisible());
            stmt.setInt(8, resource.getId());
            stmt.executeUpdate();
        }
    }

    /**
     * [SỬA] Xóa mềm một tài nguyên (soft delete) thay vì xóa vĩnh viễn.
     */
    public void deleteResource(int id) throws SQLException {
        // [SỬA] Chuyển từ DELETE sang UPDATE
        String sql = "UPDATE resources SET is_deleted = TRUE WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    /**
     * Lấy một tài nguyên theo ID cho người dùng (phải visible và chưa bị xóa).
     */
    public Resource getResourceById(int id) throws SQLException {
        // [SỬA] Thêm điều kiện is_deleted = FALSE
        String sql = "SELECT * FROM resources WHERE id = ? AND is_visible = TRUE AND is_deleted = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToResource(rs);
                }
            }
        }
        return null;
    }

    /**
     * Phương thức tiện ích để chuyển ResultSet thành đối tượng Resource
     */
    private Resource mapResultSetToResource(ResultSet rs) throws SQLException {
        Resource resource = new Resource();
        resource.setId(rs.getInt("id"));
        resource.setTitle(rs.getString("title"));
        resource.setType(rs.getString("type"));
        resource.setUrl(rs.getString("url"));
        resource.setDescription(rs.getString("description"));
        resource.setImageUrl(rs.getString("image_url"));
        resource.setContent(rs.getString("content"));
        resource.setUploadedAt(rs.getTimestamp("uploaded_at"));
        resource.setVisible(rs.getBoolean("is_visible"));
        resource.setUploadedBy(rs.getString("uploaded_by"));
        resource.setDeleted(rs.getBoolean("is_deleted")); // [THÊM] Lấy giá trị cho trường isDeleted
        return resource;
    }
}