<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Hall Booking System</title>
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
            padding: 40px 20px;
            text-align: center;
            position: relative;
            z-index: 1;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 15px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
            background: linear-gradient(45deg, #fff, #f0f0f0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: slideDown 0.8s ease-out;
        }

        .header p {
            font-size: 1.2rem;
            color: rgba(255, 255, 255, 0.9);
            font-weight: 300;
            animation: slideDown 0.8s ease-out 0.2s both;
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
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 30px;
            padding: 80px 20px;
            flex-wrap: wrap;
            position: relative;
            z-index: 1;
        }

        .card {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 50px 30px;
            text-align: center;
            width: 250px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.1);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            animation: slideUp 0.8s ease-out;
        }

        .card:nth-child(1) { animation-delay: 0.1s; }
        .card:nth-child(2) { animation-delay: 0.2s; }
        .card:nth-child(3) { animation-delay: 0.3s; }

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

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
            transition: left 0.5s;
        }

        .card:hover::before {
            left: 100%;
        }

        .card:hover {
            transform: translateY(-10px) scale(1.05);
            box-shadow: 0 35px 60px rgba(0, 0, 0, 0.2);
            border-color: rgba(255, 255, 255, 0.3);
        }

        .card a {
            text-decoration: none;
            color: white;
            font-weight: 600;
            font-size: 1.2rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 15px;
            transition: all 0.3s ease;
            position: relative;
            z-index: 2;
        }

        .card-icon {
            font-size: 3rem;
            margin-bottom: 10px;
            transition: transform 0.3s ease;
        }

        .card:hover .card-icon {
            transform: scale(1.2) rotate(5deg);
        }

        .card-text {
            font-size: 1.1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
        }

        /* Special styling for logout card */
        .card.logout {
            background: linear-gradient(45deg, rgba(255, 107, 107, 0.2), rgba(238, 90, 36, 0.2));
        }

        .card.logout:hover {
            background: linear-gradient(45deg, rgba(255, 107, 107, 0.3), rgba(238, 90, 36, 0.3));
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

        /* Responsive design */
        @media (max-width: 768px) {
            .header h1 {
                font-size: 2rem;
            }
            
            .header p {
                font-size: 1rem;
            }
            
            .container {
                gap: 20px;
                padding: 60px 20px;
            }
            
            .card {
                width: 200px;
                padding: 40px 25px;
            }
            
            .card-icon {
                font-size: 2.5rem;
            }
            
            .card-text {
                font-size: 1rem;
            }
        }

        @media (max-width: 480px) {
            .container {
                flex-direction: column;
                align-items: center;
            }
            
            .card {
                width: 280px;
                max-width: 90%;
            }
        }
    </style>
</head>
<body>
    <div class="icon">🏛️</div>
    <div class="icon">📊</div>
    <div class="icon">⚡</div>
    <div class="icon">🎯</div>
    <div class="icon">✨</div>

    <div class="header">
        <h1>Hall Booking Dashboard</h1>
        <p>Welcome back, <%= session.getAttribute("staff_name") != null ? session.getAttribute("staff_name") : "Staff" %>!</p>
    </div>

    <div class="container">
        <div class="card">
            <a href="bookHall.jsp">
                <div class="card-icon">📅</div>
                <div class="card-text">Book Hall</div>
            </a>
        </div>
        
        <div class="card">
            <a href="scheduledHalls.jsp">
                <div class="card-icon">📋</div>
                <div class="card-text">Scheduled Halls</div>
            </a>
        </div>
        
        <div class="card logout">
            <a href="logout.jsp">
                <div class="card-icon">🚪</div>
                <div class="card-text">Logout</div>
            </a>
        </div>
    </div>

</body>
</html>