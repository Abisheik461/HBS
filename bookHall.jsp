<%@ page import="java.sql.*, java.util.*, jakarta.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Book Hall</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #7F7FD5, #86A8E7, #91EAE4);
            padding: 50px 20px;
            margin: 0;
        }
        .container {
            max-width: 950px;
            margin: auto;
            background: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }
        h2 {
            text-align: center;
            color: #4B4B4B;
            font-size: 28px;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            font-weight: bold;
            display: block;
            margin-bottom: 6px;
        }
        input, select {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        input[type="submit"] {
            background: #6C63FF;
            color: white;
            font-weight: bold;
            border: none;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        input[type="submit"]:hover {
            background: #594edd;
        }
        .periods {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        .period-button {
            padding: 20px 10px;
            border-radius: 15px;
            font-weight: bold;
            color: white;
            border: none;
            cursor: pointer;
            transition: transform 0.2s ease;
            font-size: 16px;
        }
        .period-button:hover {
            transform: scale(1.05);
        }
        .available {
            background-color: #4CAF50;
        }
        .booked {
            background-color: #F44336;
        }
        .own-booked {
            background-color: #2E7D32;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Book a Hall</h2>

    <form method="post">
        <div class="form-group">
            <label>Select Date:</label>
            <input type="date" name="booking_date" required value="<%= request.getParameter("booking_date") != null ? request.getParameter("booking_date") : "" %>">
        </div>

        <div class="form-group">
            <label>Department:</label>
            <select name="department" required>
                <option value="">-- Select Department --</option>
                <% String selDept = request.getParameter("department"); %>
                <option <%= "CSE".equals(selDept) ? "selected" : "" %>>CSE</option>
                <option <%= "IT".equals(selDept) ? "selected" : "" %>>IT</option>
                <option <%= "AIDS".equals(selDept) ? "selected" : "" %>>AIDS</option>
                <option <%= "ECE".equals(selDept) ? "selected" : "" %>>ECE</option>
                <option <%= "EEE".equals(selDept) ? "selected" : "" %>>EEE</option>
                <option <%= "CIVIL".equals(selDept) ? "selected" : "" %>>CIVIL</option>
                <option <%= "MECH".equals(selDept) ? "selected" : "" %>>MECH</option>
                <option <%= "S&H".equals(selDept) ? "selected" : "" %>>S&H</option>
            </select>
        </div>

        <div class="form-group">
            <label>Hall Name:</label>
            <select name="hall_name" required>
                <option value="">-- Select Hall --</option>
                <% String selHall = request.getParameter("hall_name"); %>
                <option <%= "Seminar Hall".equals(selHall) ? "selected" : "" %>>Seminar Hall</option>
                <option <%= "Lecture Hall 1".equals(selHall) ? "selected" : "" %>>Lecture Hall 1</option>
                <option <%= "Lecture Hall 2".equals(selHall) ? "selected" : "" %>>Lecture Hall 2</option>
                <option <%= "Lab 1".equals(selHall) ? "selected" : "" %>>Lab 1</option>
                <option <%= "Lab 2".equals(selHall) ? "selected" : "" %>>Lab 2</option>
            </select>
        </div>

        <div class="form-group">
            <label>Purpose:</label>
            <input type="text" name="purpose" placeholder="Enter purpose" value="<%= request.getParameter("purpose") != null ? request.getParameter("purpose") : "" %>">
        </div>

        <input type="submit" value="Check Availability">
    </form>

<!-- rest of the logic stays same -->


<%
    Integer staffId = (Integer) session.getAttribute("staff_id");
    String bookingDate = request.getParameter("booking_date");
    String dept = request.getParameter("department");
    String hallName = request.getParameter("hall_name");
%>
    <h5><%=bookingDate+" "+dept+" "+hallName%></h5>
    
    <%

    if (bookingDate != null && dept != null && hallName != null && staffId != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://bvqquajoqrmlplsx6gws-mysql.services.clever-cloud.com:3306/bvqquajoqrmlplsx6gws?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "ut9u0nb9cnmpbzcb", "wRobtIadyKkhM2S97jzM");

            int deptIndex = -1;
            if ("CSE".equals(dept)) deptIndex = 0;
            else if ("IT".equals(dept)) deptIndex = 1;
            else if ("AIDS".equals(dept)) deptIndex = 2;
            else if ("EEE".equals(dept)) deptIndex = 3;
            else if ("ECE".equals(dept)) deptIndex = 4;
            else if ("CIVIL".equals(dept)) deptIndex = 5;
            else if ("MECH".equals(dept)) deptIndex = 6;
            else if ("S&H".equals(dept)) deptIndex = 7;

            int hallOffset = -1;
            if ("Seminar Hall".equals(hallName)) hallOffset = 0;
            else if ("Lecture Hall 1".equals(hallName)) hallOffset = 1;
            else if ("Lecture Hall 2".equals(hallName)) hallOffset = 2;
            else if ("Lab 1".equals(hallName)) hallOffset = 3;
            else if ("Lab 2".equals(hallName)) hallOffset = 4;

            int hallId = (deptIndex * 10) + 1 + hallOffset;

            String selectedPeriod = request.getParameter("selected_period");
            if (selectedPeriod != null) {
                int period = Integer.parseInt(selectedPeriod);
                PreparedStatement checkStmt = con.prepareStatement("SELECT * FROM bookings WHERE hall_id = ? AND booking_date = ? AND period = ?");
                checkStmt.setInt(1, hallId);
                checkStmt.setString(2, bookingDate);
                checkStmt.setInt(3, period);
                ResultSet checkRs = checkStmt.executeQuery();

                if (checkRs.next()) {
                    int bookedBy = checkRs.getInt("staff_id");
                    if (bookedBy == staffId) {
                        PreparedStatement cancelStmt = con.prepareStatement("DELETE FROM bookings WHERE hall_id = ? AND booking_date = ? AND period = ? AND staff_id = ?");
                        cancelStmt.setInt(1, hallId);
                        cancelStmt.setString(2, bookingDate);
                        cancelStmt.setInt(3, period);
                        cancelStmt.setInt(4, staffId);
                        cancelStmt.executeUpdate();
                    }
                } else {
                    String purpose = request.getParameter("purpose");
                    PreparedStatement insertStmt = con.prepareStatement("INSERT INTO bookings (staff_id, hall_id, purpose, booking_date, period) VALUES (?, ?, ?, ?, ?)");
                    insertStmt.setInt(1, staffId);
                    insertStmt.setInt(2, hallId);
                    insertStmt.setString(3, purpose);
                    insertStmt.setString(4, bookingDate);
                    insertStmt.setInt(5, period);
                    insertStmt.executeUpdate();
                }
                response.sendRedirect("bookHall.jsp?booking_date=" + bookingDate + "&department=" + dept + "&hall_name=" + hallName + "&purpose=" + request.getParameter("purpose"));
                return;
            }

            PreparedStatement ps = con.prepareStatement("SELECT b.period, b.staff_id, s.name FROM bookings b JOIN staff s ON b.staff_id = s.staff_id WHERE b.hall_id = ? AND b.booking_date = ?");
            ps.setInt(1, hallId);
            ps.setString(2, bookingDate);
            ResultSet rs = ps.executeQuery();

            Map<Integer, String> bookingMap = new HashMap<>();
            Map<Integer, Integer> staffMap = new HashMap<>();
            while (rs.next()) {
                int period = rs.getInt("period");
                bookingMap.put(period, rs.getString("name"));
                staffMap.put(period, rs.getInt("staff_id"));
            }
%>
        <form method="post">
            <input type="hidden" name="booking_date" value="<%= bookingDate %>">
            <input type="hidden" name="department" value="<%= dept %>">
            <input type="hidden" name="hall_name" value="<%= hallName %>">
            <input type="hidden" name="purpose" value="<%= request.getParameter("purpose") %>">
            <div class="periods">
                <%
                    for (int i = 1; i <= 8; i++) {
                        String cls = "available";
                        boolean canClick = true;
                        String tooltip = "Available";
                        if (staffMap.containsKey(i)) {
                            if (staffMap.get(i) == staffId) {
                                cls = "own-booked";
                                tooltip = "Booked by You";
                            } else {
                                cls = "booked";
                                canClick = false;
                                tooltip = "Booked by: " + bookingMap.get(i);
                            }
                        }
                %>
                    <button class="period-button <%= cls %>" type="submit" name="selected_period" value="<%= i %>" title="<%= tooltip %>" <%= canClick ? "" : "disabled" %>>Period <%= i %></button>
                <%
                    }
                %>
            </div>
        </form>
<%
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        }
    }
%>

</div>

</body>
</html>
