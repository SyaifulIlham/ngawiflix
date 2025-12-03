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
    <title>Theaters Management - CinemaX Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-100">
    <div x-data="theatersAdmin()" class="flex h-screen">
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
                    <a href="../admin.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-gray-700 transition">
                        <i class="fas fa-home w-5"></i>
                        <span>Dashboard</span>
                    </a>
                    <a href="movies.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-gray-700 transition">
                        <i class="fas fa-film w-5"></i>
                        <span>Movies</span>
                    </a>
                    <a href="theaters.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg bg-red-600 transition">
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
                    <h2 class="text-2xl font-bold text-gray-800">Theaters Management</h2>
                    <p class="text-gray-600">Manage all theaters in the system</p>
                </div>
                <button @click="openAddModal()" class="bg-red-600 hover:bg-red-700 text-white px-6 py-3 rounded-lg flex items-center gap-2 transition">
                    <i class="fas fa-plus"></i>
                    <span>Add Theater</span>
                </button>
            </div>

            <!-- Theaters Table -->
            <div class="p-6">
                <div class="bg-white rounded-lg shadow-md overflow-hidden">
                    <!-- Search -->
                    <div class="p-4 border-b">
                        <input type="text" x-model="searchQuery" @input="searchTheaters()" 
                               placeholder="Search theaters..." 
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent">
                    </div>

                    <!-- Table -->
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">ID</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Theater Name</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Location</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Total Seats</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Created At</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200">
                                <template x-if="loading">
                                    <tr>
                                        <td colspan="6" class="px-6 py-12 text-center text-gray-500">
                                            <i class="fas fa-spinner fa-spin text-3xl mb-2"></i>
                                            <p>Loading theaters...</p>
                                        </td>
                                    </tr>
                                </template>
                                <template x-if="!loading && filteredTheaters.length === 0">
                                    <tr>
                                        <td colspan="6" class="px-6 py-12 text-center text-gray-500">
                                            <i class="fas fa-building text-4xl mb-2"></i>
                                            <p>No theaters found</p>
                                        </td>
                                    </tr>
                                </template>
                                <template x-for="theater in filteredTheaters" :key="theater.theaterId">
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-6 py-4 text-sm text-gray-900" x-text="theater.theaterId"></td>
                                        <td class="px-6 py-4">
                                            <div class="font-medium text-gray-900" x-text="theater.theaterName"></div>
                                        </td>
                                        <td class="px-6 py-4 text-sm text-gray-900" x-text="theater.location"></td>
                                        <td class="px-6 py-4 text-sm text-gray-900" x-text="theater.totalSeats"></td>
                                        <td class="px-6 py-4 text-sm text-gray-500" x-text="formatDate(theater.createdAt)"></td>
                                        <td class="px-6 py-4">
                                            <div class="flex gap-2">
                                                <button @click="openEditModal(theater)" 
                                                        class="text-blue-600 hover:text-blue-800">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button @click="confirmDelete(theater)" 
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

        <!-- Add/Edit Modal -->
        <div x-show="showModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50" 
             style="display: none;">
            <div class="bg-white rounded-lg shadow-xl w-full max-w-md m-4">
                <div class="p-6 border-b flex justify-between items-center">
                    <h3 class="text-xl font-bold" x-text="isEditMode ? 'Edit Theater' : 'Add New Theater'"></h3>
                    <button @click="closeModal()" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                
                <form @submit.prevent="saveTheater()" class="p-6">
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Theater Name *</label>
                            <input type="text" x-model="formData.theaterName" required
                                   placeholder="e.g., Theater 1, IMAX Theater"
                                   class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Location *</label>
                            <input type="text" x-model="formData.location" required
                                   placeholder="e.g., Lantai 2, Lantai 3"
                                   class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Total Seats *</label>
                            <input type="number" x-model="formData.totalSeats" required min="1"
                                   placeholder="e.g., 80, 100, 120"
                                   class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                        </div>
                    </div>
                    
                    <div class="mt-6 flex justify-end gap-3 border-t pt-4">
                        <button type="button" @click="closeModal()" 
                                class="px-6 py-2 border rounded-lg hover:bg-gray-50">
                            Cancel
                        </button>
                        <button type="submit" 
                                class="px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">
                            <span x-text="isEditMode ? 'Update Theater' : 'Add Theater'"></span>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div x-show="showDeleteModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50" 
             style="display: none;">
            <div class="bg-white rounded-lg shadow-xl p-6 max-w-md">
                <div class="text-center">
                    <i class="fas fa-exclamation-triangle text-red-500 text-5xl mb-4"></i>
                    <h3 class="text-xl font-bold mb-2">Delete Theater?</h3>
                    <p class="text-gray-600 mb-6">
                        Are you sure you want to delete "<span x-text="theaterToDelete?.theaterName"></span>"? 
                        This action cannot be undone and will also delete all associated schedules.
                    </p>
                    <div class="flex gap-3 justify-center">
                        <button @click="showDeleteModal = false" 
                                class="px-6 py-2 border rounded-lg hover:bg-gray-50">
                            Cancel
                        </button>
                        <button @click="deleteTheater()" 
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
             class="fixed top-4 right-4 z-50 max-w-sm w-full"
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
        function theatersAdmin() {
            return {
                theaters: [],
                filteredTheaters: [],
                loading: false,
                showModal: false,
                showDeleteModal: false,
                isEditMode: false,
                searchQuery: '',
                theaterToDelete: null,
                toast: {
                    show: false,
                    message: '',
                    type: 'success'
                },
                formData: {
                    theaterId: null,
                    theaterName: '',
                    location: '',
                    totalSeats: 80
                },

                init() {
                    this.loadTheaters();
                },

                async loadTheaters() {
                    try {
                        this.loading = true;
                        const response = await fetch('../api/theaters');
                        this.theaters = await response.json();
                        this.filteredTheaters = this.theaters;
                    } catch (error) {
                        console.error('Error loading theaters:', error);
                        this.showToast('error', 'Gagal memuat data theaters');
                    } finally {
                        this.loading = false;
                    }
                },

                searchTheaters() {
                    if (!this.searchQuery) {
                        this.filteredTheaters = this.theaters;
                        return;
                    }
                    
                    const query = this.searchQuery.toLowerCase();
                    this.filteredTheaters = this.theaters.filter(theater => 
                        theater.theaterName.toLowerCase().includes(query) ||
                        theater.location.toLowerCase().includes(query)
                    );
                },

                openAddModal() {
                    this.isEditMode = false;
                    this.resetForm();
                    this.showModal = true;
                },

                openEditModal(theater) {
                    this.isEditMode = true;
                    this.formData = {
                        theaterId: theater.theaterId,
                        theaterName: theater.theaterName,
                        location: theater.location,
                        totalSeats: theater.totalSeats
                    };
                    this.showModal = true;
                },

                closeModal() {
                    this.showModal = false;
                    this.resetForm();
                },

                resetForm() {
                    this.formData = {
                        theaterId: null,
                        theaterName: '',
                        location: '',
                        totalSeats: 80
                    };
                },

                async saveTheater() {
                    try {
                        const url = this.isEditMode 
                            ? `../api/theaters?id=` + this.formData.theaterId
                            : '../api/theaters';
                        
                        const method = this.isEditMode ? 'PUT' : 'POST';

                        const response = await fetch(url, {
                            method: method,
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify(this.formData)
                        });

                        const result = await response.json();

                        if (result.success) {
                            this.showToast('success', this.isEditMode ? 'Theater berhasil diperbarui' : 'Theater berhasil ditambahkan');
                            this.closeModal();
                            this.loadTheaters();
                        } else {
                            this.showToast('error', result.error || 'Gagal menyimpan theater');
                        }
                    } catch (error) {
                        console.error('Error saving theater:', error);
                        this.showToast('error', 'Gagal menyimpan theater');
                    }
                },

                confirmDelete(theater) {
                    this.theaterToDelete = theater;
                    this.showDeleteModal = true;
                },

                async deleteTheater() {
                    try {
                        const response = await fetch(`../api/theaters?id=` + this.theaterToDelete.theaterId, {
                            method: 'DELETE'
                        });

                        const result = await response.json();

                        if (result.success) {
                            this.showToast('success', 'Theater berhasil dihapus');
                            this.showDeleteModal = false;
                            this.theaterToDelete = null;
                            this.loadTheaters();
                        } else {
                            this.showToast('error', result.error || 'Gagal menghapus theater');
                        }
                    } catch (error) {
                        console.error('Error deleting theater:', error);
                        this.showToast('error', 'Gagal menghapus theater');
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

