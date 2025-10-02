package com.tiengviet.DAO;

import com.tiengviet.entity.Question;
import com.tiengviet.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {
    private Connection conn;

    {
        try {
            conn = DBConnection.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<Question> getQuestionsByCourse(int courseId) throws SQLException {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM questions WHERE course_id = ? AND status = 'active'";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setId(rs.getInt("id"));
                q.setCourseId(rs.getInt("course_id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setType(rs.getString("type"));
                q.setAudioUrl(rs.getString("audio_url"));
                q.setCorrectAnswer(rs.getString("correct_answer"));
                q.setOptionA(rs.getString("option_a"));
                q.setOptionB(rs.getString("option_b"));
                q.setOptionC(rs.getString("option_c"));
                q.setOptionD(rs.getString("option_d"));
                q.setExplanation(rs.getString("explanation"));
                q.setStatus(rs.getString("status"));
                q.setImageUrl(rs.getString("image_url"));
                list.add(q);
            }
        }
        return list;
    }

    public void addQuestion(Question q) throws SQLException {
        String sql = "INSERT INTO questions (course_id, question_text, type, audio_url, image_url, correct_answer, option_a, option_b, option_c, option_d, explanation, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, q.getCourseId());
            stmt.setString(2, q.getQuestionText());
            stmt.setString(3, q.getType());
            stmt.setString(4, q.getAudioUrl());
            stmt.setString(5, q.getImageUrl());
            stmt.setString(6, q.getCorrectAnswer());
            stmt.setString(7, q.getOptionA());
            stmt.setString(8, q.getOptionB());
            stmt.setString(9, q.getOptionC());
            stmt.setString(10, q.getOptionD());
            stmt.setString(11, q.getExplanation());
            stmt.setString(12, q.getStatus());
            stmt.executeUpdate();
        }
    }

    public void updateQuestion(Question q) throws SQLException {
        String sql = "UPDATE questions SET question_text=?, type=?, audio_url=?, correct_answer=?,image_url=?, option_a=?, option_b=?, option_c=?, option_d=?, explanation=?, status=? WHERE id=?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, q.getQuestionText());
            stmt.setString(2, q.getType());
            stmt.setString(3, q.getAudioUrl());
            stmt.setString(4, q.getCorrectAnswer());
            stmt.setString(5, q.getImageUrl());
            stmt.setString(6, q.getOptionA());
            stmt.setString(7, q.getOptionB());
            stmt.setString(8, q.getOptionC());
            stmt.setString(9, q.getOptionD());
            stmt.setString(10, q.getExplanation());
            stmt.setString(11, q.getStatus());
            stmt.setInt(12, q.getId());
            stmt.executeUpdate();
        }
    }

    public void softDeleteQuestion(int id) throws SQLException {
        String sql = "UPDATE questions SET status = 'deleted' WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public Question getQuestionById(int id) throws SQLException {
        String sql = "SELECT * FROM questions WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Question q = new Question();
                q.setId(rs.getInt("id"));
                q.setCourseId(rs.getInt("course_id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setType(rs.getString("type"));
                q.setAudioUrl(rs.getString("audio_url"));
                q.setCorrectAnswer(rs.getString("correct_answer"));
                q.setOptionA(rs.getString("option_a"));
                q.setOptionB(rs.getString("option_b"));
                q.setOptionC(rs.getString("option_c"));
                q.setOptionD(rs.getString("option_d"));
                q.setExplanation(rs.getString("explanation"));
                q.setStatus(rs.getString("status"));
                q.setImageUrl(rs.getString("image_url"));
                return q;
            }
        }
        return null;
    }
}
