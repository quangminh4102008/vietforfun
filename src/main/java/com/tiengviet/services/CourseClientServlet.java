package com.tiengviet.services;

import com.tiengviet.DAO.CourseDAO;
import com.tiengviet.entity.Course;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/courses")
public class CourseClientServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        CourseDAO dao = new CourseDAO();
        List<Course> courses = null; // chỉ lấy courses được publish
        try {
            courses = dao.getPublishedCourses();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        req.setAttribute("courseList", courses);
        req.getRequestDispatcher("/courses.jsp").forward(req, resp);
    }
}
