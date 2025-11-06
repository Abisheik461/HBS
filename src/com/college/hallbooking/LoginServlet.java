package com.college.hallbooking;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            // Load JDBC Driver and Connect
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://mysql:3306/railway?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                    "root", "jFOMsIFGmTYlWtzKZmUmxuKUTJeJhtwm");

            PreparedStatement pst = con.prepareStatement(
                    "SELECT * FROM staff WHERE email = ? AND password = ?");
            pst.setString(1, email);
            pst.setString(2, password);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                // Login successful
                HttpSession session = request.getSession();
                session.setAttribute("staff_id", rs.getInt("staff_id"));
                session.setAttribute("staff_name", rs.getString("name"));
                response.sendRedirect("dashboard.jsp"); // Create this page
            } else {
                out.println("<h3 style='color:red'>Invalid email or password.</h3>");
            }

            con.close();
        } catch (Exception e) {
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
}
