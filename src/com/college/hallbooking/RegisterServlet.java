package com.college.hallbooking;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;


public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String department = request.getParameter("department");
        String contact = request.getParameter("contact");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            // Load JDBC Driver and Connect
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://bvqquajoqrmlplsx6gws-mysql.services.clever-cloud.com:3306/bvqquajoqrmlplsx6gws?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                    "ut9u0nb9cnmpbzcb", "wRobtIadyKkhM2S97jzM");

            // Check if email already exists
            PreparedStatement check = con.prepareStatement("SELECT * FROM staff WHERE email = ?");
            check.setString(1, email);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                out.println("<h3 style='color:red'>Email already registered!</h3>");
            } else {
                PreparedStatement pst = con.prepareStatement(
                        "INSERT INTO staff (name, email, password, department, contact_number) VALUES (?, ?, ?, ?, ?)");
                pst.setString(1, name);
                pst.setString(2, email);
                pst.setString(3, password);
                pst.setString(4, department);
                pst.setString(5, contact);

                int row = pst.executeUpdate();

                if (row > 0) {
                    response.sendRedirect("login.jsp");
                } else {
                    out.println("<h3 style='color:red'>Registration failed. Try again.</h3>");
                }
            }

            con.close();
        } catch (Exception e) {
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
}
