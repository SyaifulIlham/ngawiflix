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
    
    String movieIdParam = request.getParameter("movieId");
    if (movieIdParam == null || movieIdParam.trim().isEmpty()) {
        response.sendRedirect("movies.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Detail - AnjayNobar Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <style>
        body { background: #f8f9fa; }
        .sidebar-link { transition: all 0.3s ease; }
        .sidebar-link:hover { transform: translateX(5px); }
    </style>
</head>
<body>
    <div x-data="movieDetailAdmin()" class="flex h-screen overflow-hidden">
        <!-- Sidebar -->
        <div class="w-72 bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 text-white shadow-2xl">
            <div class="p-6 h-full flex flex-col">
                <div class="mb-8 pb-6 border-b border-slate-700">
                    <div class="flex items-center gap-3 mb-2">
                        <div class="w-12 h-12 bg-gradient-to-br from-red-500 to-red-700 rounded-xl flex items-center justify-center shadow-lg">
                            <i class="fas fa-film text-white text-xl"></i>
                        </div>
                        <div>
                            <h1 class="text-2xl font-bold bg-gradient-to-r from-white to-gray-300 bg-clip-text text-transparent">AnjayNobar</h1>
                            <p class="text-xs text-gray-400 font-medium">Admin Dashboard</p>
                        </div>
                    </div>
                </div>
                
                <nav class="space-y-1 flex-1">
                    <a href="../admin.jsp" class="sidebar-link flex items-center gap-3 px-4 py-3.5 rounded-xl hover:bg-slate-700/50">
                        <i class="fas fa-home w-5 text-lg"></i>
                        <span class="font-medium">Dashboard</span>
                    </a>
                    <a href="movies.jsp" class="sidebar-link flex items-center gap-3 px-4 py-3.5 rounded-xl bg-gradient-to-r from-red-600 to-red-700 shadow-lg">
                        <i class="fas fa-film w-5 text-lg"></i>
                        <span class="font-semibold">Movies</span>
                    </a>
                    <a href="theaters.jsp" class="sidebar-link flex items-center gap-3 px-4 py-3.5 rounded-xl hover:bg-slate-700/50">
                        <i class="fas fa-building w-5 text-lg"></i>
                        <span class="font-medium">Theaters</span>
                    </a>
                    <a href="categories.jsp" class="sidebar-link flex items-center gap-3 px-4 py-3.5 rounded-xl hover:bg-slate-700/50">
                        <i class="fas fa-tags w-5 text-lg"></i>
                        <span class="font-medium">Categories</span>
                    </a>
                </nav>
                
                <div class="mt-auto pt-6 border-t border-slate-700 space-y-2">
                    <a href="../index.jsp" class="sidebar-link flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-slate-700/50 text-gray-300">
                        <i class="fas fa-arrow-left w-5"></i>
                        <span class="font-medium">Back to Home</span>
                    </a>
                    <button @click="logout()" class="w-full sidebar-link flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-red-600/90 text-gray-300 hover:text-white">
                        <i class="fas fa-sign-out-alt w-5"></i>
                        <span class="font-medium">Logout</span>
                    </button>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="flex-1 overflow-auto">
            <!-- Header -->
            <div class="bg-white/80 backdrop-blur-sm shadow-sm border-b border-gray-200">
                <div class="p-8">
                    <div class="flex items-center gap-4">
                        <button @click="goBack()" class="w-10 h-10 rounded-lg hover:bg-gray-100 flex items-center justify-center transition-colors">
                            <i class="fas fa-arrow-left text-xl text-gray-600"></i>
                        </button>
                        <div>
                            <h2 class="text-3xl font-bold text-gray-900" x-text="movie?.title || 'Loading...'"></h2>
                            <p class="text-gray-600">Movie Details & Schedule Management</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Movie Info -->
            <div x-show="movie" class="p-6">
                <div class="bg-white rounded-lg shadow-md p-6 mb-6">
                    <div class="flex gap-6">
                        <img :src="movie?.posterUrl" :alt="movie?.title" 
                             class="w-48 h-72 object-cover rounded-lg">
                        <div class="flex-1">
                            <h3 class="text-2xl font-bold mb-4" x-text="movie?.title"></h3>
                            <div class="grid grid-cols-2 gap-4 mb-4">
                                <div>
                                    <span class="text-gray-600">Director:</span>
                                    <span class="ml-2 font-medium" x-text="movie?.director"></span>
                                </div>
                                <div>
                                    <span class="text-gray-600">Duration:</span>
                                    <span class="ml-2 font-medium" x-text="movie?.duration + ' min'"></span>
                                </div>
                                <div>
                                    <span class="text-gray-600">Rating:</span>
                                    <span class="ml-2 font-medium" x-text="movie?.rating"></span>
                                </div>
                                <div>
                                    <span class="text-gray-600">Rated:</span>
                                    <span class="ml-2 font-medium" x-text="movie?.rated"></span>
                                </div>
                                <div>
                                    <span class="text-gray-600">Release Year:</span>
                                    <span class="ml-2 font-medium" x-text="movie?.releaseYear"></span>
                                </div>
                            </div>
                            <div class="mb-4">
                                <span class="text-gray-600">Description:</span>
                                <p class="mt-2 text-gray-800" x-text="movie?.description"></p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Schedules Section -->
                <div class="bg-white rounded-lg shadow-md p-6">
                    <div class="flex justify-between items-center mb-6">
                        <h3 class="text-xl font-bold text-gray-800">Schedules</h3>
                        <button @click="openAddScheduleModal()" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg flex items-center gap-2 transition">
                            <i class="fas fa-plus"></i>
                            <span>Add Schedule</span>
                        </button>
                    </div>

                    <!-- Search -->
                    <div class="mb-4">
                        <input type="text" x-model="searchQuery" @input="searchSchedules()" 
                               placeholder="Search schedules..." 
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent">
                    </div>

                    <!-- Schedules Table -->
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Theater</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Time</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Price</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Available Seats</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200">
                                <template x-if="loading">
                                    <tr>
                                        <td colspan="6" class="px-6 py-12 text-center text-gray-500">
                                            <i class="fas fa-spinner fa-spin text-3xl mb-2"></i>
                                            <p>Loading schedules...</p>
                                        </td>
                                    </tr>
                                </template>
                                <template x-if="!loading && filteredSchedules.length === 0">
                                    <tr>
                                        <td colspan="6" class="px-6 py-12 text-center text-gray-500">
                                            <i class="fas fa-calendar text-4xl mb-2"></i>
                                            <p>No schedules found</p>
                                        </td>
                                    </tr>
                                </template>
                                <template x-for="schedule in filteredSchedules" :key="schedule.scheduleId">
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-6 py-4">
                                            <div class="font-medium text-gray-900" x-text="schedule.theaterName"></div>
                                            <div class="text-xs text-gray-500" x-text="schedule.location"></div>
                                        </td>
                                        <td class="px-6 py-4 text-sm text-gray-900" x-text="formatDate(schedule.showDate)"></td>
                                        <td class="px-6 py-4 text-sm text-gray-900" x-text="formatTime(schedule.showTime)"></td>
                                        <td class="px-6 py-4 text-sm text-gray-900" x-text="formatPrice(schedule.price)"></td>
                                        <td class="px-6 py-4">
                                            <span class="px-2 py-1 text-xs font-semibold rounded-full"
                                                  :class="schedule.availableSeats > 10 ? 'bg-green-100 text-green-800' : 
                                                          schedule.availableSeats > 0 ? 'bg-yellow-100 text-yellow-800' : 
                                                          'bg-red-100 text-red-800'"
                                                  x-text="schedule.availableSeats + ' / ' + schedule.totalSeats">
                                            </span>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="flex gap-2">
                                                <button @click="openEditScheduleModal(schedule)" 
                                                        class="text-blue-600 hover:text-blue-800">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button @click="confirmDeleteSchedule(schedule)" 
                                                        class="text-red-600 hover:text-red-800">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </template>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add/Edit Schedule Modal -->
        <div x-show="showScheduleModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50" 
             style="display: none;">
            <div class="bg-white rounded-lg shadow-xl w-full max-w-md m-4">
                <div class="p-6 border-b flex justify-between items-center">
                    <h3 class="text-xl font-bold" x-text="isEditScheduleMode ? 'Edit Schedule' : 'Add New Schedule'"></h3>
                    <button @click="closeScheduleModal()" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                
                <form @submit.prevent="saveSchedule()" class="p-6">
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Theater *</label>
                            <select x-model="scheduleFormData.theaterId" required
                                    class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                                <option value="">Select Theater</option>
                                <template x-for="theater in theaters" :key="theater.theaterId">
                                    <option :value="theater.theaterId" x-text="theater.theaterName + ' - ' + theater.location"></option>
                                </template>
                            </select>
                        </div>
                        
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Show Date *</label>
                                <input type="date" x-model="scheduleFormData.showDate" required
                                       :min="getTodayDate()"
                                       class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Show Time *</label>
                                <input type="time" x-model="scheduleFormData.showTime" required
                                       class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                            </div>
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Price (Rp) *</label>
                            <input type="number" x-model="scheduleFormData.price" required min="0" step="1000"
                                   placeholder="e.g., 50000"
                                   class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                        </div>
                    </div>
                    
                    <div class="mt-6 flex justify-end gap-3 border-t pt-4">
                        <button type="button" @click="closeScheduleModal()" 
                                class="px-6 py-2 border rounded-lg hover:bg-gray-50">
                            Cancel
                        </button>
                        <button type="submit" 
                                class="px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">
                            <span x-text="isEditScheduleMode ? 'Update Schedule' : 'Add Schedule'"></span>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div x-show="showDeleteScheduleModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50" 
             style="display: none;">
            <div class="bg-white rounded-lg shadow-xl p-6 max-w-md">
                <div class="text-center">
                    <i class="fas fa-exclamation-triangle text-red-500 text-5xl mb-4"></i>
                    <h3 class="text-xl font-bold mb-2">Delete Schedule?</h3>
                    <p class="text-gray-600 mb-6">
                        Are you sure you want to delete this schedule? 
                        This action cannot be undone and will also delete all associated seats and bookings.
                    </p>
                    <div class="flex gap-3 justify-center">
                        <button @click="showDeleteScheduleModal = false" 
                                class="px-6 py-2 border rounded-lg hover:bg-gray-50">
                            Cancel
                        </button>
                        <button @click="deleteSchedule()" 
                                class="px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">
                            Delete
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Toast Notification -->
        <div x-show="toast.show" 
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0 transform translate-x-full"
             x-transition:enter-end="opacity-100 transform translate-x-0"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100 transform translate-x-0"
             x-transition:leave-end="opacity-0 transform translate-x-full"
             class="fixed bottom-4 right-4 z-50 max-w-sm w-full"
             style="display: none;">
            <div class="rounded-lg shadow-lg p-4 flex items-center gap-3"
                 :class="{
                     'bg-green-500': toast.type === 'success',
                     'bg-red-500': toast.type === 'error',
                     'bg-blue-500': toast.type === 'info',
                     'bg-yellow-500': toast.type === 'warning'
                 }">
                <i class="fas text-white text-xl"
                   :class="{
                       'fa-check-circle': toast.type === 'success',
                       'fa-exclamation-circle': toast.type === 'error',
                       'fa-info-circle': toast.type === 'info',
                       'fa-exclamation-triangle': toast.type === 'warning'
                   }"></i>
                <p class="text-white font-medium flex-1" x-text="toast.message"></p>
                <button @click="toast.show = false" class="text-white hover:text-gray-200">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
    </div>

    <script>
        function movieDetailAdmin() {
            return {
                movie: null,
                schedules: [],
                filteredSchedules: [],
                theaters: [],
                loading: false,
                showScheduleModal: false,
                showDeleteScheduleModal: false,
                isEditScheduleMode: false,
                searchQuery: '',
                scheduleToDelete: null,
                toast: {
                    show: false,
                    message: '',
                    type: 'success'
                },
                movieId: parseInt('<%= movieIdParam %>'),
                scheduleFormData: {
                    scheduleId: null,
                    theaterId: '',
                    showDate: '',
                    showTime: '',
                    price: ''
                },

                init() {
                    this.loadMovie();
                    this.loadSchedules();
                    this.loadTheaters();
                },

                async loadMovie() {
                    try {
                        const response = await fetch(`../api/movies?id=` + this.movieId);
                        this.movie = await response.json();
                    } catch (error) {
                        console.error('Error loading movie:', error);
                        this.showToast('error', 'Gagal memuat data movie');
                    }
                },

                async loadSchedules() {
                    try {
                        this.loading = true;
                        // Add includeAll=true for admin to see all schedules including past ones
                        const response = await fetch(`../api/schedules?movieId=` + this.movieId + `&includeAll=true`);
                        this.schedules = await response.json();
                        this.filteredSchedules = this.schedules;
                    } catch (error) {
                        console.error('Error loading schedules:', error);
                        this.showToast('error', 'Gagal memuat data jadwal');
                    } finally {
                        this.loading = false;
                    }
                },

                async loadTheaters() {
                    try {
                        const response = await fetch('../api/theaters');
                        this.theaters = await response.json();
                    } catch (error) {
                        console.error('Error loading theaters:', error);
                    }
                },

                searchSchedules() {
                    if (!this.searchQuery) {
                        this.filteredSchedules = this.schedules;
                        return;
                    }
                    
                    const query = this.searchQuery.toLowerCase();
                    this.filteredSchedules = this.schedules.filter(schedule => 
                        (schedule.theaterName && schedule.theaterName.toLowerCase().includes(query)) ||
                        (schedule.location && schedule.location.toLowerCase().includes(query))
                    );
                },

                openAddScheduleModal() {
                    this.isEditScheduleMode = false;
                    this.resetScheduleForm();
                    this.showScheduleModal = true;
                },

                openEditScheduleModal(schedule) {
                    this.isEditScheduleMode = true;
                    this.scheduleFormData = {
                        scheduleId: schedule.scheduleId,
                        theaterId: schedule.theaterId,
                        showDate: this.formatDateForInput(schedule.showDate),
                        showTime: this.formatTimeForInput(schedule.showTime),
                        price: schedule.price
                    };
                    this.showScheduleModal = true;
                },

                closeScheduleModal() {
                    this.showScheduleModal = false;
                    this.resetScheduleForm();
                },

                resetScheduleForm() {
                    this.scheduleFormData = {
                        scheduleId: null,
                        theaterId: '',
                        showDate: '',
                        showTime: '',
                        price: ''
                    };
                },

                async saveSchedule() {
                    try {
                        const url = this.isEditScheduleMode 
                            ? `../api/schedules?id=` + this.scheduleFormData.scheduleId
                            : '../api/schedules';
                        
                        const method = this.isEditScheduleMode ? 'PUT' : 'POST';

                        const scheduleData = {
                            movieId: this.movieId,
                            theaterId: parseInt(this.scheduleFormData.theaterId),
                            showDate: this.scheduleFormData.showDate,
                            showTime: this.scheduleFormData.showTime,
                            price: parseFloat(this.scheduleFormData.price)
                        };

                        const response = await fetch(url, {
                            method: method,
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify(scheduleData)
                        });

                        const responseText = await response.text();
                        let result;
                        
                        try {
                            result = JSON.parse(responseText);
                        } catch (parseError) {
                            console.error('Error parsing response:', parseError);
                            console.error('Response text:', responseText);
                            alert('Server error: Invalid response format. Please check console for details.');
                            return;
                        }

                        if (result.success) {
                            this.showToast('success', this.isEditScheduleMode ? 'Jadwal berhasil diperbarui' : 'Jadwal berhasil ditambahkan');
                            this.closeScheduleModal();
                            this.loadSchedules();
                        } else {
                            this.showToast('error', result.error || 'Gagal menyimpan jadwal');
                        }
                    } catch (error) {
                        console.error('Error saving schedule:', error);
                        this.showToast('error', 'Gagal menyimpan jadwal: ' + error.message);
                    }
                },

                confirmDeleteSchedule(schedule) {
                    this.scheduleToDelete = schedule;
                    this.showDeleteScheduleModal = true;
                },

                async deleteSchedule() {
                    try {
                        const response = await fetch(`../api/schedules?id=` + this.scheduleToDelete.scheduleId, {
                            method: 'DELETE'
                        });

                        const result = await response.json();

                        if (result.success) {
                            this.showToast('success', 'Jadwal berhasil dihapus');
                            this.showDeleteScheduleModal = false;
                            this.scheduleToDelete = null;
                            this.loadSchedules();
                        } else {
                            this.showToast('error', result.error || 'Gagal menghapus jadwal');
                        }
                    } catch (error) {
                        console.error('Error deleting schedule:', error);
                        this.showToast('error', 'Gagal menghapus jadwal');
                    }
                },

                formatDate(dateString) {
                    if (!dateString) return '-';
                    const date = new Date(dateString);
                    return date.toLocaleDateString('id-ID', {
                        year: 'numeric',
                        month: 'short',
                        day: 'numeric'
                    });
                },

                formatDateForInput(dateString) {
                    if (!dateString) return '';
                    const date = new Date(dateString);
                    return date.toISOString().split('T')[0];
                },

                formatTime(timeString) {
                    if (!timeString) return '-';
                    const time = timeString.split(':');
                    return time[0] + ':' + time[1];
                },

                formatTimeForInput(timeString) {
                    if (!timeString) return '';
                    return timeString.substring(0, 5); // HH:mm format
                },

                formatPrice(price) {
                    if (!price) return 'Rp 0';
                    return 'Rp ' + parseFloat(price).toLocaleString('id-ID');
                },

                getTodayDate() {
                    const today = new Date();
                    return today.toISOString().split('T')[0];
                },

                goBack() {
                    window.location.href = 'movies.jsp';
                },

                showToast(type, message) {
                    this.toast.type = type;
                    this.toast.message = message;
                    this.toast.show = true;
                    setTimeout(() => {
                        this.toast.show = false;
                    }, 3000);
                },

                logout() {
                    if (confirm('Are you sure you want to logout?')) {
                        window.location.href = '../api/auth?action=logout';
                    }
                }
            }
        }
    </script>
</body>
</html>

