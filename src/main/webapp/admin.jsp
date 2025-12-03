<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in and is admin
    session = request.getSession(false);
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    String userRole = (String) session.getAttribute("role");
    if (!"admin".equals(userRole)) {
        response.sendRedirect("../index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movies Management - CinemaX Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-100">
    <div x-data="moviesAdmin()" class="flex h-screen">
        <!-- Sidebar -->
        <div class="w-64 bg-gradient-to-b from-gray-900 to-gray-800 text-white">
            <div class="p-6">
                <div class="flex items-center gap-3 mb-8">
                    <i class="fas fa-film text-red-500 text-2xl"></i>
                    <div>
                        <h1 class="text-xl font-bold">CinemaX</h1>
                        <p class="text-sm text-gray-400">Admin Panel</p>
                    </div>
                </div>
                
                <nav class="space-y-2">
                    <a href="../admin.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg bg-red-600 transition">
                        <i class="fas fa-home w-5"></i>
                        <span>Dashboard</span>
                    </a>
                    <a href="admin/movies.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-gray-700 transition">
                        <i class="fas fa-film w-5"></i>
                        <span>Movies</span>
                    </a>
                    <a href="admin/theaters.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-gray-700 transition">
                        <i class="fas fa-building w-5"></i>
                        <span>Theaters</span>
                    </a>
                    <a href="categories.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-gray-700 transition">
                        <i class="fas fa-tags w-5"></i>
                        <span>Categories</span>
                    </a>
                </nav>
                
                <div class="mt-auto pt-6 border-t border-gray-700">
                    <a href="../index.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-gray-700 transition">
                        <i class="fas fa-arrow-left w-5"></i>
                        <span>Back to Home</span>
                    </a>
                    <button @click="logout()" class="w-full flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-red-600 transition">
                        <i class="fas fa-sign-out-alt w-5"></i>
                        <span>Logout</span>
                    </button>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="flex-1 overflow-auto">
            <!-- Header -->
            <div class="bg-white shadow-md p-6 flex justify-between items-center">
                <div>
                    <h2 class="text-2xl font-bold text-gray-800">Movies Management</h2>
                    <p class="text-gray-600">Manage all movies in the system</p>
                </div>
                <button @click="openAddModal()" class="bg-red-600 hover:bg-red-700 text-white px-6 py-3 rounded-lg flex items-center gap-2 transition">
                    <i class="fas fa-plus"></i>
                    <span>Add Movie</span>
                </button>
            </div>
            <h1>Selamat Datang Admin</h1>
        </div>
    </div>
</body>
</html>
