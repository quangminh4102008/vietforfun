package com.tiengviet.services;

import com.tiengviet.DAO.CourseDAO; // Cần import CourseDAO
import com.tiengviet.DAO.QuestionDAO;
import com.tiengviet.entity.Course; // Cần import Course entity
import com.tiengviet.entity.Question;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections; // Để xáo trộn câu hỏi
import java.util.List;

// Đổi tên lớp thành QuizServlet (một chữ z) để khớp với @WebServlet
// Hoặc giữ QuizzServlet và đổi @WebServlet("/quizz")
// Tôi khuyến nghị sử dụng /quiz và QuizServlet để thống nhất
@WebServlet("/quiz")
public class QuizServlet extends HttpServlet { // Đã đổi tên lớp từ QuizzServlet sang QuizServlet
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseIdParam = request.getParameter("courseId");

        // === 1. Xử lý lỗi: Kiểm tra tham số courseId có hợp lệ không ===
        if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Course ID is missing. Please select a course to start the quiz.");
            request.getRequestDispatcher("/quiz.jsp").forward(request, response);
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdParam);

            CourseDAO courseDAO = new CourseDAO();
            QuestionDAO questionDAO = new QuestionDAO();

            // === 2. Lấy thông tin khóa học (COURSE OBJECT) ===
            Course course = courseDAO.getCourseById(courseId);
            if (course == null) {
                request.setAttribute("errorMessage", "The requested course could not be found. Please check the Course ID.");
                request.getRequestDispatcher("/quiz.jsp").forward(request, response);
                return;
            }

            // === 3. Lấy danh sách câu hỏi ===
            List<Question> questions = questionDAO.getQuestionsByCourse(courseId);
            System.out.println("--- KIỂM TRA DỮ LIỆU CÂU HỎI CHO COURSE ID: " + courseId + " ---");
            for (Question q : questions) {
                System.out.println(
                        "ID: " + q.getId() +
                                " | Text: '" + q.getQuestionText() +
                                "' | Type: '" + q.getType() + "'" // <-- DÒNG QUAN TRỌNG NHẤT
                );
            }
            System.out.println("----------------------------------------------------");
            for (Question q : questions) {
                System.out.println("Q: " + q.getQuestionText() + " | correct: " + q.getCorrectAnswer());
            }
            // Fix lỗi correctAnswer bị null gây hiện "false" trong JS
            for (Question q : questions) {
                if (q.getCorrectAnswer() == null) {
                    q.setCorrectAnswer("");
                }
            }


            // Optional: Xáo trộn câu hỏi để mỗi lần làm bài có thứ tự khác nhau
            if (questions != null && !questions.isEmpty()) {
                Collections.shuffle(questions);
            } else {
                // Nếu không có câu hỏi nào cho khóa học này
                request.setAttribute("errorMessage", "This course currently has no questions available. Please try another course or check back later.");
                request.getRequestDispatcher("/quiz.jsp").forward(request, response);
                return;
            }

            // === 4. Đặt các đối tượng vào request để JSP có thể truy cập ===
            request.setAttribute("course", course); // Gửi đối tượng Course
            request.setAttribute("questions", questions); // Gửi danh sách câu hỏi

            // === 5. Chuyển tiếp tới JSP ===
            request.getRequestDispatcher("/quiz.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // Lỗi khi courseId không phải là số
            e.printStackTrace(); // Log lỗi cho nhà phát triển
            request.setAttribute("errorMessage", "Invalid Course ID format. Please use a valid number.");
            request.getRequestDispatcher("/quiz.jsp").forward(request, response);
        } catch (SQLException e) {
            // Lỗi khi truy vấn cơ sở dữ liệu
            e.printStackTrace(); // Log lỗi cho nhà phát triển
            request.setAttribute("errorMessage", "A database error occurred while trying to load the quiz. Please try again later.");
            request.getRequestDispatcher("/quiz.jsp").forward(request, response);
        }
        // IOException không cần catch riêng vì nó là superclass của ServletException
        // và đã được khai báo trong chữ ký phương thức doGet

    }

}