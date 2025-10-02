package com.tiengviet.services;

import com.tiengviet.DAO.QuestionDAO;
import com.tiengviet.entity.Question;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/questions")
public class QuestionServlet extends HttpServlet {
    private QuestionDAO dao = new QuestionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr == null) {
            resp.sendError(400, "Missing courseId");
            return;
        }

        int courseId = Integer.parseInt(courseIdStr);

        try {
            List<Question> questionList = dao.getQuestionsByCourse(courseId);
            req.setAttribute("courseId", courseId);
            req.setAttribute("questionList", questionList);

            // Nếu đang sửa câu hỏi
            String editIdStr = req.getParameter("editId");
            if (editIdStr != null) {
                int editId = Integer.parseInt(editIdStr);
                Question editQuestion = dao.getQuestionById(editId);
                req.setAttribute("editQuestion", editQuestion);
            }

            req.getRequestDispatcher("/admin/manage-questions.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Error loading questions", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        int courseId = Integer.parseInt(req.getParameter("courseId"));

        try {
            if ("add".equals(action)) {
                Question q = buildQuestionFromRequest(req, 0);
                dao.addQuestion(q);

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Question q = buildQuestionFromRequest(req, id);
                dao.updateQuestion(q);

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.softDeleteQuestion(id);
            }

            // Redirect lại về danh sách câu hỏi của course đó
            resp.sendRedirect("/admin/questions?courseId=" + courseId);

        } catch (SQLException e) {
            throw new ServletException("Error processing question", e);
        }
    }

    private Question buildQuestionFromRequest(HttpServletRequest req, int id) {
        Question q = new Question();
        q.setId(id);
        q.setCourseId(Integer.parseInt(req.getParameter("courseId")));
        q.setQuestionText(req.getParameter("questionText"));
        q.setType(req.getParameter("type"));
        q.setAudioUrl(req.getParameter("audioUrl"));
        q.setCorrectAnswer(req.getParameter("correctAnswer"));
        q.setImageUrl(req.getParameter("imageUrl"));
        q.setOptionA(req.getParameter("optionA"));
        q.setOptionB(req.getParameter("optionB"));
        q.setOptionC(req.getParameter("optionC"));
        q.setOptionD(req.getParameter("optionD"));
        q.setExplanation(req.getParameter("explanation"));
        q.setStatus("active");
        return q;
    }
}
