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
    <title>Dashboard - AnjayNobar Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <style>
        body {
            background: #f8f9fa;
        }
        .card-hover {
            transition: all 0.3s ease;
        }
        .card-hover:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
        }
        .sidebar-link {
            transition: all 0.3s ease;
        }
        .sidebar-link:hover {
            transform: translateX(5px);
        }
        .stat-card {
            background: white;
            border: 1px solid #e5e7eb;
        }
    </style>
</head>
<body>
    <div x-data="dashboardAdmin()" class="flex h-screen overflow-hidden">
        <!-- Sidebar -->
        <jsp:include page="../component/admin/sidebar.jsp" />

        <!-- Main Content -->
        <div class="flex-1 overflow-auto">
            <!-- Header -->
            <div class="bg-white/80 backdrop-blur-sm shadow-sm border-b border-gray-200">
                <div class="p-8">
                    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                        <div>
                            <h2 class="text-3xl font-bold text-gray-900 mb-2">Selamat Datang, Admin!</h2>
                            <p class="text-gray-600">Ini adalah ringkasan aktivitas bioskop Anda hari ini</p>
                        </div>
                        <div class="text-sm text-gray-500">
                            <i class="fas fa-calendar-alt mr-2"></i>
                            <span x-text="new Date().toLocaleDateString('id-ID', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })"></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div class="p-8">
                <!-- Stats Cards -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <!-- Total Movies -->
                    <div class="card-hover stat-card rounded-xl p-6 shadow-sm">
                        <div class="flex items-center justify-between mb-4">
                            <div class="w-12 h-12 bg-gray-100 rounded-lg flex items-center justify-center">
                                <i class="fas fa-film text-2xl text-gray-700"></i>
                            </div>
                        </div>
                        <h3 class="text-3xl font-bold text-gray-900 mb-1" x-text="stats.totalMovies || 0">0</h3>
                        <p class="text-gray-600 text-sm">Total Film</p>
                    </div>

                    <!-- Total Theaters -->
                    <div class="card-hover stat-card rounded-xl p-6 shadow-sm">
                        <div class="flex items-center justify-between mb-4">
                            <div class="w-12 h-12 bg-gray-100 rounded-lg flex items-center justify-center">
                                <i class="fas fa-building text-2xl text-gray-700"></i>
                            </div>
                        </div>
                        <h3 class="text-3xl font-bold text-gray-900 mb-1" x-text="stats.totalTheaters || 0">0</h3>
                        <p class="text-gray-600 text-sm">Total Bioskop</p>
                    </div>

                    <!-- Total Categories -->
                    <div class="card-hover stat-card rounded-xl p-6 shadow-sm">
                        <div class="flex items-center justify-between mb-4">
                            <div class="w-12 h-12 bg-gray-100 rounded-lg flex items-center justify-center">
                                <i class="fas fa-tags text-2xl text-gray-700"></i>
                            </div>
                        </div>
                        <h3 class="text-3xl font-bold text-gray-900 mb-1" x-text="stats.totalCategories || 0">0</h3>
                        <p class="text-gray-600 text-sm">Total Kategori</p>
                    </div>

                    <!-- Total Schedules -->
                    <div class="card-hover stat-card rounded-xl p-6 shadow-sm">
                        <div class="flex items-center justify-between mb-4">
                            <div class="w-12 h-12 bg-gray-100 rounded-lg flex items-center justify-center">
                                <i class="fas fa-calendar-check text-2xl text-gray-700"></i>
                            </div>
                        </div>
                        <h3 class="text-3xl font-bold text-gray-900 mb-1" x-text="stats.totalSchedules || 0">0</h3>
                        <p class="text-gray-600 text-sm">Jadwal Aktiv</p>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <!-- Quick Actions Card -->
                    <div class="bg-white rounded-xl shadow-sm p-6 border border-gray-200">
                        <h3 class="text-xl font-bold text-gray-900 mb-4 flex items-center gap-2">
                            <i class="fas fa-bolt text-gray-700"></i>
                            Quick Actions
                        </h3>
                        <div class="grid grid-cols-2 gap-4">
                            <a href="admin/movies.jsp" class="card-hover flex flex-col items-center justify-center p-6 bg-gray-50 rounded-lg border border-gray-200 hover:border-gray-400 hover:bg-gray-100">
                                <i class="fas fa-plus-circle text-3xl text-gray-700 mb-2"></i>
                                <span class="text-sm font-semibold text-gray-900">Add Movie</span>
                            </a>
                            <a href="admin/theaters.jsp" class="card-hover flex flex-col items-center justify-center p-6 bg-gray-50 rounded-lg border border-gray-200 hover:border-gray-400 hover:bg-gray-100">
                                <i class="fas fa-plus-circle text-3xl text-gray-700 mb-2"></i>
                                <span class="text-sm font-semibold text-gray-900">Add Theater</span>
                            </a>
                            <a href="admin/categories.jsp" class="card-hover flex flex-col items-center justify-center p-6 bg-gray-50 rounded-lg border border-gray-200 hover:border-gray-400 hover:bg-gray-100">
                                <i class="fas fa-plus-circle text-3xl text-gray-700 mb-2"></i>
                                <span class="text-sm font-semibold text-gray-900">Add Category</span>
                            </a>
                            <a href="admin/movies.jsp" class="card-hover flex flex-col items-center justify-center p-6 bg-gray-50 rounded-lg border border-gray-200 hover:border-gray-400 hover:bg-gray-100">
                                <i class="fas fa-list text-3xl text-gray-700 mb-2"></i>
                                <span class="text-sm font-semibold text-gray-900">View All</span>
                            </a>
                        </div>
                    </div>

                    <!-- System Info -->
                    <div class="bg-white rounded-xl shadow-sm p-6 border border-gray-200">
                        <h3 class="text-xl font-bold text-gray-900 mb-4 flex items-center gap-2">
                            <i class="fas fa-info-circle text-gray-700"></i>
                            System Information
                        </h3>
                        <div class="space-y-3">
                            <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg border border-gray-100">
                                <span class="text-sm text-gray-600">Role</span>
                                <span class="text-sm font-semibold text-gray-900">Administrator</span>
                            </div>
                            <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg border border-gray-100">
                                <span class="text-sm text-gray-600">Status</span>
                                <span class="flex items-center gap-2 text-sm font-semibold text-gray-900">
                                    <span class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></span>
                                    Online
                                </span>
                            </div>
                            <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg border border-gray-100">
                                <span class="text-sm text-gray-600">Last Login</span>
                                <span class="text-sm font-semibold text-gray-900" x-text="new Date().toLocaleTimeString('id-ID')"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function dashboardAdmin() {
            return {
                stats: {
                    totalMovies: 0,
                    totalTheaters: 0,
                    totalCategories: 0,
                    totalSchedules: 0
                },

                async init() {
                    await this.loadStats();
                },

                async loadStats() {
                    try {
                        // Load movies count
                        const moviesResponse = await fetch('api/movies');
                        if (moviesResponse.ok) {
                            const movies = await moviesResponse.json();
                            this.stats.totalMovies = Array.isArray(movies) ? movies.length : 0;
                        }

                        // Load theaters count
                        const theatersResponse = await fetch('api/theaters');
                        if (theatersResponse.ok) {
                            const theaters = await theatersResponse.json();
                            this.stats.totalTheaters = Array.isArray(theaters) ? theaters.length : 0;
                        }

                        // Load categories count
                        const categoriesResponse = await fetch('api/categories');
                        if (categoriesResponse.ok) {
                            const categories = await categoriesResponse.json();
                            this.stats.totalCategories = Array.isArray(categories) ? categories.length : 0;
                        }

                        // Load schedules count (only future schedules)
                        const schedulesResponse = await fetch('api/schedules');
                        if (schedulesResponse.ok) {
                            const schedules = await schedulesResponse.json();
                            if (Array.isArray(schedules)) {
                                // Filter only future schedules
                                const now = new Date();
                                const futureSchedules = schedules.filter(schedule => {
                                    const scheduleDate = new Date(schedule.showDate + ' ' + schedule.showTime);
                                    return scheduleDate > now;
                                });
                                this.stats.totalSchedules = futureSchedules.length;
                            } else {
                                this.stats.totalSchedules = 0;
                            }
                        }
                    } catch (error) {
                        console.error('Error loading stats:', error);
                    }
                },

                logout() {
                    if (confirm('Are you sure you want to logout?')) {
                        window.location.href = 'api/auth?action=logout';
                    }
                }
            }
        }
    </script>
</body>
</html>
