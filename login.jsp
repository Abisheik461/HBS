<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Login</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
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

        .form-container {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 50px 40px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.2);
            width: 400px;
            max-width: 90%;
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

        h2 {
            color: white;
            font-size: 2rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 15px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
            background: linear-gradient(45deg, #fff, #f0f0f0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .subtitle {
            color: rgba(255, 255, 255, 0.8);
            text-align: center;
            margin-bottom: 35px;
            font-weight: 300;
        }

        .form-group {
            position: relative;
            margin-bottom: 25px;
        }

        .form-group i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(255, 255, 255, 0.7);
            font-size: 1.1rem;
            z-index: 2;
        }

        input {
            width: 100%;
            padding: 18px 20px 18px 50px;
            background: rgba(255, 255, 255, 0.1);
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 50px;
            color: white;
            font-size: 1rem;
            outline: none;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            backdrop-filter: blur(10px);
        }

        input::placeholder {
            color: rgba(255, 255, 255, 0.7);
            font-weight: 300;
        }

        input:focus {
            border-color: rgba(255, 255, 255, 0.5);
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        button {
            width: 100%;
            background: linear-gradient(45deg, #ff6b6b, #ee5a24);
            color: white;
            padding: 18px;
            border: none;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.3);
            margin-top: 20px;
        }

        button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        button:hover::before {
            left: 100%;
        }

        button:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(255, 107, 107, 0.4);
        }

        button:active {
            transform: translateY(-1px);
        }

        /* Floating icons */
        .icon {
            position: absolute;
            color: rgba(255, 255, 255, 0.1);
            font-size: 2rem;
            animation: floatIcon 6s ease-in-out infinite;
        }

        .icon:nth-child(1) {
            top: 15%;
            left: 10%;
            animation-delay: 0s;
        }

        .icon:nth-child(2) {
            top: 70%;
            right: 15%;
            animation-delay: 2s;
        }

        .icon:nth-child(3) {
            bottom: 15%;
            left: 20%;
            animation-delay: 4s;
        }

        @keyframes floatIcon {
            0%, 100% { transform: translateY(0px) rotate(0deg); opacity: 0.1; }
            50% { transform: translateY(-15px) rotate(5deg); opacity: 0.3; }
        }

        .back-link {
            text-align: center;
            margin-top: 25px;
        }

        .back-link a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.3s ease;
        }

        .back-link a:hover {
            color: white;
        }

        @media (max-width: 600px) {
            .form-container {
                padding: 40px 30px;
                margin: 20px;
            }
            
            h2 {
                font-size: 1.8rem;
            }
            
            input, button {
                padding: 15px;
                font-size: 1rem;
            }
            
            input {
                padding-left: 45px;
            }
        }
    </style>
</head>
<body>
    <div class="icon">👤</div>
    <div class="icon">🔐</div>
    <div class="icon">💼</div>

    <div class="form-container">
        <h2>Staff Login</h2>
        <p class="subtitle">Access your staff dashboard</p>
        
        <form action="LoginServlet" method="post">
            <div class="form-group">
                <input type="email" name="email" placeholder="Staff Email" required />
            </div>
            
            <div class="form-group">
                <input type="password" name="password" placeholder="Password" required />
            </div>
            
            <button type="submit">Login</button>
        </form>
        
        <div class="back-link">
            <a href="index.jsp">← Back to Home</a>
        </div>
    </div>

</body>
</html>