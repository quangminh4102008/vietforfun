package com.tiengviet.services;
import com.tiengviet.DAO.ResourceDAO;
import com.tiengviet.entity.Resource; // Đảm bảo đường dẫn này đúng tới file model Resource.java

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
@WebServlet("/resources")
public class ResourceClientServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ResourceDAO resourceDAO;

    @Override
    public void init() {
        resourceDAO = new ResourceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");

        try {
            if (idParam != null && !idParam.isEmpty()) {
                // TRƯỜNG HỢP 1: CÓ ID -> Hiển thị trang chi tiết
                int id = Integer.parseInt(idParam);
                Resource resource = resourceDAO.getResourceById(id);

                if (resource != null) {
                    request.setAttribute("resource", resource);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("resource-detail.jsp");
                    dispatcher.forward(request, response);
                } else {
                    // Xử lý trường hợp không tìm thấy ID (ví dụ: chuyển đến trang lỗi)
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy tài nguyên bạn yêu cầu.");
                }

            } else {
                // TRƯỜNG HỢP 2: KHÔNG CÓ ID -> Hiển thị danh sách tài nguyên
                List<Resource> resourceList = resourceDAO.getAllVisibleResources();
                request.setAttribute("resourceList", resourceList);
                RequestDispatcher dispatcher = request.getRequestDispatcher("resources.jsp");
                dispatcher.forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tài nguyên không hợp lệ.");
        } catch (SQLException e) {
            throw new ServletException("Lỗi truy vấn cơ sở dữ liệu.", e);
        }
    }
}
