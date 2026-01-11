package com.cinemax.controller;

import com.cinemax.dao.UserDAO;
import com.cinemax.model.User;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/auth")
public class AuthController extends HttpServlet {

    private UserDAO userDAO;
    private Gson gson;

    @Override
    public void init() {
        userDAO = new UserDAO();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");

        System.out.println("AuthServlet - POST request received");
        System.out.println("Action: " + action);

        if (action == null) {
            action = "login"; // default action
        }

        Map<String, Object> result = new HashMap<>();

        try {
            switch (action) {
                case "login":
                    handleLogin(request, response, result);
                    break;
                case "register":
                    handleRegister(request, response, result);
                    break;
                case "logout":
                    handleLogout(request, response, result);
                    break;
                case "check":
                    handleCheckSession(request, response, result);
                    break;
                case "update":
                    handleUpdate(request, response, result);
                    break;
                case "changePassword":
                    handleChangePassword(request, response, result);
                    break;
                default:
                    result.put("success", false);
                    result.put("error", "Invalid action");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            e.printStackTrace();
        }

        String jsonResponse = gson.toJson(result);
        System.out.println("Response: " + jsonResponse);
        out.print(jsonResponse);
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("logout".equals(action)) {
            // Handle logout via GET request and redirect to index
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        Map<String, Object> result = new HashMap<>();

        if ("check".equals(action)) {
            handleCheckSession(request, response, result);
        } else {
            result.put("success", false);
            result.put("error", "Invalid action");
        }

        out.print(gson.toJson(result));
        out.flush();
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response, Map<String, Object> result) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("Login attempt - Username: " + username);

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            result.put("success", false);
            result.put("error", "Username dan password harus diisi");
            return;
        }

        User user = userDAO.login(username.trim(), password);

        System.out.println("Login result - User found: " + (user != null));

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setMaxInactiveInterval(3600); // 1 hour

            result.put("success", true);
            result.put("message", "Login berhasil");

            Map<String, Object> userData = new HashMap<>();
            userData.put("userId", user.getUserId());
            userData.put("username", user.getUsername());
            userData.put("email", user.getEmail());
            userData.put("fullName", user.getFullName());
            userData.put("phone", user.getPhone());
            userData.put("role", user.getRole());

            result.put("user", userData);
        } else {
            result.put("success", false);
            result.put("error", "Username/email atau password salah");
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response, Map<String, Object> result) {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");

        // Validation
        if (username == null || username.trim().isEmpty()) {
            result.put("success", false);
            result.put("error", "Username harus diisi");
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            result.put("success", false);
            result.put("error", "Email harus diisi");
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            result.put("success", false);
            result.put("error", "Password harus diisi");
            return;
        }

        if (password.length() < 6) {
            result.put("success", false);
            result.put("error", "Password minimal 6 karakter");
            return;
        }

        // Check if username exists
        if (userDAO.usernameExists(username.trim())) {
            result.put("success", false);
            result.put("error", "Username sudah digunakan");
            return;
        }

        // Check if email exists
        if (userDAO.emailExists(email.trim())) {
            result.put("success", false);
            result.put("error", "Email sudah terdaftar");
            return;
        }

        // Create new user
        User user = new User();
        user.setUsername(username.trim());
        user.setEmail(email.trim());
        user.setPassword(password); // In production, hash this password!
        user.setFullName(fullName != null ? fullName.trim() : "");
        user.setPhone(phone != null ? phone.trim() : "");
        user.setRole("user"); // Default role

        if (userDAO.register(user)) {
            // Auto login after registration
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setMaxInactiveInterval(3600);

            result.put("success", true);
            result.put("message", "Registrasi berhasil");

            Map<String, Object> userData = new HashMap<>();
            userData.put("userId", user.getUserId());
            userData.put("username", user.getUsername());
            userData.put("email", user.getEmail());
            userData.put("fullName", user.getFullName());
            userData.put("phone", user.getPhone());
            userData.put("role", user.getRole());

            result.put("user", userData);
        } else {
            result.put("success", false);
            result.put("error", "Registrasi gagal, silakan coba lagi");
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response, Map<String, Object> result) {
        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate();
        }

        result.put("success", true);
        result.put("message", "Logout berhasil");
    }

    private void handleCheckSession(HttpServletRequest request, HttpServletResponse response,
            Map<String, Object> result) {
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");

            result.put("success", true);
            result.put("loggedIn", true);

            Map<String, Object> userData = new HashMap<>();
            userData.put("userId", user.getUserId());
            userData.put("username", user.getUsername());
            userData.put("email", user.getEmail());
            userData.put("fullName", user.getFullName());
            userData.put("phone", user.getPhone());
            userData.put("role", user.getRole());

            result.put("user", userData);
        } else {
            result.put("success", true);
            result.put("loggedIn", false);
            result.put("user", null);
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, Map<String, Object> result) {
        String userIdStr = request.getParameter("userId");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");

        System.out.println("Update request - userId: " + userIdStr);

        // Validation
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            result.put("success", false);
            result.put("error", "User ID tidak valid");
            return;
        }

        if (username == null || username.trim().isEmpty()) {
            result.put("success", false);
            result.put("error", "Username harus diisi");
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            result.put("success", false);
            result.put("error", "Email harus diisi");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);

            // Check if username is taken by another user
            if (userDAO.usernameExistsExcept(username.trim(), userId)) {
                result.put("success", false);
                result.put("error", "Username sudah digunakan oleh user lain");
                return;
            }

            // Check if email is taken by another user
            if (userDAO.emailExistsExcept(email.trim(), userId)) {
                result.put("success", false);
                result.put("error", "Email sudah terdaftar oleh user lain");
                return;
            }

            // Create user object with updated data
            User user = new User();
            user.setUserId(userId);
            user.setUsername(username.trim());
            user.setEmail(email.trim());
            user.setFullName(fullName != null ? fullName.trim() : "");
            user.setPhone(phone != null ? phone.trim() : "");

            // Update in database
            if (userDAO.updateUser(user)) {
                // Update session
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.setAttribute("user", user);
                    session.setAttribute("username", user.getUsername());
                }

                result.put("success", true);
                result.put("message", "Profile berhasil diperbarui");

                Map<String, Object> userData = new HashMap<>();
                userData.put("userId", user.getUserId());
                userData.put("username", user.getUsername());
                userData.put("email", user.getEmail());
                userData.put("fullName", user.getFullName());
                userData.put("phone", user.getPhone());

                result.put("user", userData);
            } else {
                result.put("success", false);
                result.put("error", "Gagal memperbarui profile");
            }
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("error", "User ID tidak valid");
        }
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response,
            Map<String, Object> result) {
        String userIdStr = request.getParameter("userId");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");

        System.out.println("Change password request - userId: " + userIdStr);

        // Validation
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            result.put("success", false);
            result.put("error", "User ID tidak valid");
            return;
        }

        if (oldPassword == null || oldPassword.trim().isEmpty()) {
            result.put("success", false);
            result.put("error", "Password lama harus diisi");
            return;
        }

        if (newPassword == null || newPassword.trim().isEmpty()) {
            result.put("success", false);
            result.put("error", "Password baru harus diisi");
            return;
        }

        if (newPassword.length() < 6) {
            result.put("success", false);
            result.put("error", "Password baru minimal 6 karakter");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);

            // Verify old password
            if (!userDAO.verifyPassword(userId, oldPassword)) {
                result.put("success", false);
                result.put("error", "Password lama tidak sesuai");
                return;
            }

            // Update password
            if (userDAO.updatePassword(userId, newPassword)) {
                result.put("success", true);
                result.put("message", "Password berhasil diubah");
            } else {
                result.put("success", false);
                result.put("error", "Gagal mengubah password");
            }
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("error", "User ID tidak valid");
        }
    }
}
