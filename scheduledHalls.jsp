<%@ page import="java.sql.*, java.util.*, jakarta.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Scheduled Halls - Hall Booking System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        /* Animated background elements */
        body::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="0.5"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>');
            animation: float 20s ease-in-out infinite;
            pointer-events: none;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(1deg); }
        }

        .header {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            padding: 30px 20px;
            text-align: center;
            position: relative;
            z-index: 1;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .header h2 {
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
            background: linear-gradient(45deg, #fff, #f0f0f0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: slideDown 0.8s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .container {
            max-width: 1100px;
            margin: 40px auto;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 40px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.1);
            position: relative;
            z-index: 1;
            animation: slideUp 0.8s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .table-container {
            overflow-x: auto;
            border-radius: 15px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
            background: transparent;
        }

        th {
            background: linear-gradient(45deg, rgba(102, 126, 234, 0.3), rgba(118, 75, 162, 0.3));
            backdrop-filter: blur(20px);
            color: white;
            padding: 20px 15px;
            text-align: center;
            font-weight: 600;
            font-size: 1.1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
            border-bottom: 2px solid rgba(255, 255, 255, 0.2);
            position: sticky;
            top: 0;
            z-index: 10;
        }

        td {
            padding: 18px 15px;
            text-align: center;
            color: white;
            font-weight: 500;
            font-size: 1rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
        }

        tr {
            transition: all 0.3s ease;
            position: relative;
        }

        tbody tr:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: scale(1.02);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        tbody tr:nth-child(even) {
            background: rgba(255, 255, 255, 0.05);
        }

        tbody tr:nth-child(odd) {
            background: rgba(255, 255, 255, 0.02);
        }

        .no-bookings {
            text-align: center;
            padding: 60px 20px;
            color: rgba(255, 255, 255, 0.8);
            font-size: 1.2rem;
            font-weight: 500;
        }

        .no-bookings-icon {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.6;
        }

        .error-message {
            background: rgba(220, 53, 69, 0.2);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(220, 53, 69, 0.3);
            color: #ff6b6b;
            padding: 20px;
            border-radius: 12px;
            margin: 20px 0;
            font-weight: 500;
            text-align: center;
            font-size: 1.1rem;
        }

        .back-button {
            position: fixed;
            top: 20px;
            left: 20px;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            padding: 12px 20px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            z-index: 1000;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .back-button:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }

        /* Floating icons */
        .icon {
            position: absolute;
            color: rgba(255, 255, 255, 0.1);
            font-size: 2rem;
            animation: floatIcon 6s ease-in-out infinite;
        }

        .icon:nth-child(1) {
            top: 20%;
            left: 5%;
            animation-delay: 0s;
        }

        .icon:nth-child(2) {
            top: 30%;
            right: 8%;
            animation-delay: 2s;
        }

        .icon:nth-child(3) {
            bottom: 25%;
            left: 8%;
            animation-delay: 4s;
        }

        .icon:nth-child(4) {
            bottom: 15%;
            right: 15%;
            animation-delay: 1s;
        }

        .icon:nth-child(5) {
            top: 60%;
            left: 50%;
            animation-delay: 3s;
        }

        @keyframes floatIcon {
            0%, 100% { transform: translateY(0px) rotate(0deg); opacity: 0.1; }
            50% { transform: translateY(-15px) rotate(5deg); opacity: 0.3; }
        }

        /* Period badges */
        .period-badge {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }

        .department-badge {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .hall-name {
            font-weight: 600;
            color: #fff;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
        }

        .booking-date {
            font-weight: 600;
            color: rgba(255, 255, 255, 0.9);
        }

        .purpose-text {
            font-style: italic;
            color: rgba(255, 255, 255, 0.8);
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .header h2 {
                font-size: 1.8rem;
            }
            
            .container {
                margin: 20px;
                padding: 25px;
            }
            
            th, td {
                padding: 12px 8px;
                font-size: 0.9rem;
            }
            
            .table-container {
                border-radius: 10px;
            }
            
            .purpose-text {
                max-width: 150px;
            }
        }

        @media (max-width: 480px) {
            .container {
                margin: 10px;
                padding: 20px;
            }
            
            th, td {
                padding: 10px 6px;
                font-size: 0.8rem;
            }
            
            .period-badge, .department-badge {
                padding: 4px 8px;
                font-size: 0.8rem;
            }
            
            .purpose-text {
                max-width: 100px;
            }
        }
    </style>
</head>
<body>
    <div class="icon">📋</div>
    <div class="icon">🏛️</div>
    <div class="icon">📅</div>
    <div class="icon">⚡</div>
    <div class="icon">✨</div>

    <a href="dashboard.jsp" class="back-button">
        ← Back to Dashboard
    </a>

    <div class="header">
        <h2>Your Scheduled Hall Bookings</h2>
    </div>

    <div class="container">
        <%
            Integer staffId = (Integer) session.getAttribute("staff_id");

            if (staffId != null) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://centerbeam.proxy.rlwy.net:14300/railway?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root","jFOMsIFGmTYlWtzKZmUmxuKUTJeJhtwm");

                    String query = "SELECT h.hall_name, h.department, b.booking_date, b.period, b.purpose " +
                                   "FROM bookings b JOIN halls h ON b.hall_id = h.hall_id " +
                                   "WHERE b.staff_id = ? ORDER BY b.booking_date DESC, b.period ASC";
                    PreparedStatement ps = con.prepareStatement(query);
                    ps.setInt(1, staffId);
                    ResultSet rs = ps.executeQuery();

                    boolean hasBookings = false;
        %>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Hall Name</th>
                        <th>Department</th>
                        <th>Date</th>
                        <th>Period</th>
                        <th>Purpose</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        while (rs.next()) {
                            hasBookings = true;
                    %>
                    <tr>
                        <td><span class="hall-name"><%= rs.getString("hall_name") %></span></td>
                        <td><span class="department-badge"><%= rs.getString("department") %></span></td>
                        <td><span class="booking-date"><%= rs.getDate("booking_date") %></span></td>
                        <td><span class="period-badge">Period <%= rs.getInt("period") %></span></td>
                        <td><span class="purpose-text" title="<%= rs.getString("purpose") %>"><%= rs.getString("purpose") %></span></td>
                    </tr>
                    <%
                        }
                        
                        if (!hasBookings) {
                    %>
                    <tr>
                        <td colspan="5">
                            <div class="no-bookings">
                                <div class="no-bookings-icon">📅</div>
                                <div>No hall bookings found</div>
                                <div style="font-size: 1rem; margin-top: 10px; opacity: 0.7;">
                                    Start by booking a hall from the dashboard
                                </div>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>

        <%
                } catch (Exception e) {
                    out.println("<div class='error-message'>⚠️ Error loading bookings: " + e.getMessage() + "</div>");
                }
            } else {
                out.println("<div class='error-message'>🔒 You are not logged in. Please log in to view your bookings.</div>");
            }
        %>

    </div>

</body>
</html>