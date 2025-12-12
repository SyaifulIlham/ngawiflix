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
    <title>Movies Management - AnjayNobar Admin</title>
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
    <div x-data="moviesAdmin()" class="flex h-screen overflow-hidden">
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
                        <span class="font-semibold">Film</span>
                    </a>
                    <a href="theaters.jsp" class="sidebar-link flex items-center gap-3 px-4 py-3.5 rounded-xl hover:bg-slate-700/50">
                        <i class="fas fa-building w-5 text-lg"></i>
                        <span class="font-medium">Bioskop</span>
                    </a>
                    <a href="categories.jsp" class="sidebar-link flex items-center gap-3 px-4 py-3.5 rounded-xl hover:bg-slate-700/50">
                        <i class="fas fa-tags w-5 text-lg"></i>
                        <span class="font-medium">Kategori</span>
                    </a>
                </nav>
                
                <div class="mt-auto pt-6 border-t border-slate-700 space-y-2">
                    <a href="../index.jsp" class="sidebar-link flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-slate-700/50 text-gray-300">
                        <i class="fas fa-arrow-left w-5"></i>
                        <span class="font-medium">Kembali ke Beranda</span>
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
                    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                        <div>
                            <h2 class="text-3xl font-bold text-gray-900 mb-2">Manajemen Film</h2>
                            <p class="text-gray-600">Kelola semua film dalam sistem</p>
                        </div>
                        <button @click="openAddModal()" class="bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800 text-white px-6 py-3 rounded-xl font-semibold shadow-lg hover:shadow-xl transition-all flex items-center gap-2">
                            <i class="fas fa-plus"></i>
                            <span>Tambah Film</span>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Movies Table -->
            <div class="p-6">
                <div class="bg-white rounded-lg shadow-md overflow-hidden">
                    <!-- Search and Filter -->
                    <div class="p-4 border-b flex gap-4">
                        <div class="flex-1">
                            <input type="text" x-model="searchQuery" @input="searchMovies()" 
                                   placeholder="Search movies..." 
                                   class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent">
                        </div>
                        <select x-model="filterCategory" @change="filterMovies()" 
                                class="px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                            <option value="">Semua Kategori</option>
                            <template x-for="category in categories" :key="category.categoryId">
                                <option :value="category.categoryId" x-text="category.categoryName"></option>
                            </template>
                        </select>
                    </div>

                    <!-- Table -->
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Poster</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Judul</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Sutradara</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Durasi</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Rating</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tahun</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Aksi</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200">
                                <template x-if="loading">
                                    <tr>
                                        <td colspan="8" class="px-6 py-12 text-center text-gray-500">
                                            <i class="fas fa-spinner fa-spin text-3xl mb-2"></i>
                                            <p>Loading movies...</p>
                                        </td>
                                    </tr>
                                </template>
                                <template x-if="!loading && filteredMovies.length === 0">
                                    <tr>
                                        <td colspan="8" class="px-6 py-12 text-center text-gray-500">
                                            <i class="fas fa-film text-4xl mb-2"></i>
                                            <p>Tidak ada film ditemukan</p>
                                        </td>
                                    </tr>
                                </template>
                                <template x-for="movie in filteredMovies" :key="movie.movieId">
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-6 py-4">
                                            <img :src="movie.posterUrl" :alt="movie.title" 
                                                 class="w-16 h-24 object-cover rounded">
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="font-medium text-gray-900" x-text="movie.title"></div>
                                            <div class="text-sm text-gray-500" x-text="movie.rated"></div>
                                        </td>
                                        <td class="px-6 py-4 text-sm text-gray-900" x-text="movie.director"></td>
                                        <td class="px-6 py-4 text-sm text-gray-900" x-text="movie.duration + ' min'"></td>
                                        <td class="px-6 py-4">
                                            <div class="flex items-center gap-1">
                                                <i class="fas fa-star text-yellow-500"></i>
                                                <span class="text-sm font-medium" x-text="movie.rating"></span>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 text-sm text-gray-900" x-text="movie.releaseYear"></td>
                                        <td class="px-6 py-4">
                                            <span x-show="movie.isNew" class="px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">
                                                Baru
                                            </span>
                                            <span x-show="movie.isFeatured" class="px-2 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800 ml-1">
                                                Unggulan
                                            </span>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="flex gap-2">
                                                <button @click="viewMovieDetail(movie)" 
                                                        class="text-green-600 hover:text-green-800" 
                                                        title="View Details & Manage Schedules">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button @click="openEditModal(movie)" 
                                                        class="text-blue-600 hover:text-blue-800">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button @click="confirmDelete(movie)" 
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
            <div class="bg-white rounded-lg shadow-xl w-full max-w-4xl max-h-[90vh] overflow-y-auto m-4">
                <div class="p-6 border-b flex justify-between items-center sticky top-0 bg-white">
                    <h3 class="text-xl font-bold" x-text="isEditMode ? 'Edit Movie' : 'Add New Movie'"></h3>
                    <button @click="closeModal()" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                
                <form @submit.prevent="saveMovie()" class="p-6">
                    <div class="grid grid-cols-2 gap-6">
                        <!-- Left Column -->
                        <div class="space-y-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Judul *</label>
                                <input type="text" x-model="formData.title" required
                                       class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                            </div>
                            
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Sutradara *</label>
                                <input type="text" x-model="formData.director" required
                                       class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                            </div>
                            
                            <div class="grid grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Durasi (menit) *</label>
                                    <input type="number" x-model="formData.duration" required min="1"
                                           class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Rating *</label>
                                    <input type="number" x-model="formData.rating" required min="0" max="10" step="0.1"
                                           class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                                </div>
                            </div>
                            
                            <div class="grid grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Rated *</label>
                                    <select x-model="formData.rated" required
                                            class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                                        <option value="">Select Rating</option>
                                        <option value="SU">SU</option>
                                        <option value="13+">13+</option>
                                        <option value="17+">17+</option>
                                        <option value="21+">21+</option>
                                    </select>
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Tahun Rilis *</label>
                                    <input type="number" x-model="formData.releaseYear" required min="1900" max="2100"
                                           class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                                </div>
                            </div>
                            
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Deskripsi *</label>
                                <textarea x-model="formData.description" required rows="4"
                                          class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500"></textarea>
                            </div>
                        </div>
                        
                        <!-- Right Column -->
                        <div class="space-y-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Poster URL *</label>
                                <input type="url" x-model="formData.posterUrl" required
                                       class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                                <img x-show="formData.posterUrl" :src="formData.posterUrl" 
                                     class="mt-2 w-32 h-48 object-cover rounded">
                            </div>
                            
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Backdrop URL *</label>
                                <input type="url" x-model="formData.backdropUrl" required
                                       class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                                <img x-show="formData.backdropUrl" :src="formData.backdropUrl" 
                                     class="mt-2 w-full h-24 object-cover rounded">
                            </div>
                            
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Trailer URL</label>
                                <input type="url" x-model="formData.trailerUrl"
                                       @input="updateTrailerPreview()"
                                       placeholder="https://youtube.com/watch?v=... or https://youtu.be/..."
                                       class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-red-500">
                                <p class="text-xs text-gray-500 mt-1">URL YouTube atau video untuk trailer film</p>
                                
                                <!-- Trailer Preview -->
                                <div x-show="formData.trailerUrl && trailerEmbedUrl" class="mt-3">
                                    <p class="text-xs font-medium text-gray-700 mb-2">Preview:</p>
                                    <div class="relative w-full h-48 rounded-lg border overflow-hidden bg-gray-100">
                                        <iframe :key="trailerEmbedUrl"
                                                :src="trailerEmbedUrl" 
                                                class="w-full h-full"
                                                frameborder="0" 
                                                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
                                                allowfullscreen
                                                loading="lazy"
                                                referrerpolicy="strict-origin-when-cross-origin"
                                                title="Movie Trailer Preview">
                                        </iframe>
                                    </div>
                                    <p x-show="formData.trailerUrl && !trailerEmbedUrl" class="text-xs text-red-500 mt-1">
                                        Format URL tidak valid. Gunakan format: https://youtube.com/watch?v=... atau https://youtu.be/...
                                    </p>
                                    <div x-show="formData.trailerUrl && trailerEmbedUrl" class="mt-2">
                                        <a :href="formData.trailerUrl" target="_blank" 
                                           class="text-xs text-blue-600 hover:text-blue-800 flex items-center gap-1">
                                            <i class="fas fa-external-link-alt"></i>
                                            <span>Buka trailer di YouTube (jika preview tidak muncul)</span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                            
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Kategori</label>
                                <div class="space-y-2 max-h-40 overflow-y-auto border rounded-lg p-3">
                                    <template x-for="category in categories" :key="category.categoryId">
                                        <label class="flex items-center gap-2">
                                            <input type="checkbox" 
                                                   :value="parseInt(category.categoryId)" 
                                                   x-model="formData.categories"
                                                   class="rounded text-red-600 focus:ring-red-500">
                                            <span class="capitalize" x-text="category.categoryName"></span>
                                        </label>
                                    </template>
                                </div>
                            </div>
                            
                            <div class="flex gap-4">
                                <label class="flex items-center gap-2">
                                    <input type="checkbox" x-model="formData.isNew"
                                           class="rounded text-red-600 focus:ring-red-500">
                                    <span class="text-sm font-medium text-gray-700">Tandai Sebagai Terbaru</span>
                                </label>
                                <label class="flex items-center gap-2">
                                    <input type="checkbox" x-model="formData.isFeatured"
                                           class="rounded text-red-600 focus:ring-red-500">
                                    <span class="text-sm font-medium text-gray-700">Tandai sebagai Unggulan</span>
                                </label>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mt-6 flex justify-end gap-3 border-t pt-4">
                        <button type="button" @click="closeModal()" 
                                class="px-6 py-2 border rounded-lg hover:bg-gray-50">
                            Batal
                        </button>
                        <button type="submit" 
                                class="px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">
                            <span x-text="isEditMode ? 'Update Movie' : 'Add Movie'"></span>
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
                    <h3 class="text-xl font-bold mb-2">Hapus Film?</h3>
                    <p class="text-gray-600 mb-6">
                        Apa Anda yakin ingin menghapus "<span x-text="movieToDelete?.title"></span>"? 
                        Tindakan ini tidak dapat dibatalkan.
                    </p>
                    <div class="flex gap-3 justify-center">
                        <button @click="showDeleteModal = false" 
                                class="px-6 py-2 border rounded-lg hover:bg-gray-50">
                            Batal
                        </button>
                        <button @click="deleteMovie()" 
                                class="px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">
                            Hapus
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
        function moviesAdmin() {
            return {
                movies: [],
                filteredMovies: [],
                categories: [],
                loading: false,
                showModal: false,
                showDeleteModal: false,
                isEditMode: false,
                searchQuery: '',
                filterCategory: '',
                movieToDelete: null,
                trailerEmbedUrl: '',
                toast: {
                    show: false,
                    message: '',
                    type: 'success'
                },
                formData: {
                    movieId: null,
                    title: '',
                    director: '',
                    duration: '',
                    rating: '',
                    rated: '',
                    releaseYear: new Date().getFullYear(),
                    description: '',
                    posterUrl: '',
                    backdropUrl: '',
                    trailerUrl: '',
                    isNew: false,
                    isFeatured: false,
                    categories: []
                },

                init() {
                    this.loadMovies();
                    this.loadCategories();
                },

                async loadMovies() {
                    try {
                        this.loading = true;
                        const response = await fetch('../api/movies');
                        this.movies = await response.json();
                        this.filteredMovies = this.movies;
                    } catch (error) {
                        console.error('Error loading movies:', error);
                        this.showToast('error', 'Gagal memuat data movies');
                    } finally {
                        this.loading = false;
                    }
                },

                async loadCategories() {
                    try {
                        const response = await fetch('../api/categories');
                        this.categories = await response.json();
                    } catch (error) {
                        console.error('Error loading categories:', error);
                    }
                },

                searchMovies() {
                    this.filterMovies();
                },

                filterMovies() {
                    let filtered = this.movies;

                    // Filter by search query
                    if (this.searchQuery) {
                        filtered = filtered.filter(movie => 
                            movie.title.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                            movie.director.toLowerCase().includes(this.searchQuery.toLowerCase())
                        );
                    }

                    // Filter by category
                    if (this.filterCategory) {
                        filtered = filtered.filter(movie => 
                            movie.categories && movie.categories.includes(parseInt(this.filterCategory))
                        );
                    }

                    this.filteredMovies = filtered;
                },

                openAddModal() {
                    this.isEditMode = false;
                    this.resetForm();
                    this.showModal = true;
                },

                openEditModal(movie) {
                    console.log('Opening edit modal for movie:', movie);
                    console.log('Movie categories:', movie.categories);
                    
                    this.isEditMode = true;
                    
                    // Ensure categories is an array of integers
                    let categoryIds = [];
                    if (movie.categories && Array.isArray(movie.categories)) {
                        categoryIds = movie.categories.map(cat => {
                            // If it's already a number, use it; otherwise parse it
                            return typeof cat === 'number' ? cat : parseInt(cat);
                        }).filter(id => !isNaN(id));
                    }
                    
                    console.log('Processed category IDs:', categoryIds);
                    
                    this.formData = {
                        movieId: movie.movieId,
                        title: movie.title,
                        director: movie.director,
                        duration: movie.duration,
                        rating: movie.rating,
                        rated: movie.rated,
                        releaseYear: movie.releaseYear,
                        description: movie.description,
                        posterUrl: movie.posterUrl,
                        backdropUrl: movie.backdropUrl,
                        trailerUrl: movie.trailerUrl || '',
                        isNew: movie.isNew || false,
                        isFeatured: movie.isFeatured || false,
                        categories: categoryIds
                    };
                    
                    this.showModal = true;
                    // Use $nextTick to ensure modal is rendered before updating preview
                    this.$nextTick(() => {
                        this.updateTrailerPreview();
                    });
                },

                closeModal() {
                    this.showModal = false;
                    this.resetForm();
                },

                updateTrailerPreview() {
                    if (!this.formData.trailerUrl) {
                        this.trailerEmbedUrl = '';
                        return;
                    }
                    
                    const url = this.formData.trailerUrl.trim();
                    let videoId = '';
                    
                    console.log('Preview URL:', url);
                    
                    // Extract YouTube video ID from various formats
                    // Try multiple patterns to handle all YouTube URL formats
                    
                    // Pattern 1: youtube.com/watch?v=VIDEO_ID or youtube.com/watch?vi=VIDEO_ID
                    let match = url.match(/(?:youtube\.com\/watch\?)(?:.*&)?v=([a-zA-Z0-9_-]{11})/);
                    if (match && match[1]) {
                        videoId = match[1];
                    }
                    
                    // Pattern 2: youtu.be/VIDEO_ID
                    if (!videoId) {
                        match = url.match(/youtu\.be\/([a-zA-Z0-9_-]{11})/);
                        if (match && match[1]) {
                            videoId = match[1];
                        }
                    }
                    
                    // Pattern 3: youtube.com/embed/VIDEO_ID
                    if (!videoId) {
                        match = url.match(/youtube\.com\/embed\/([a-zA-Z0-9_-]{11})/);
                        if (match && match[1]) {
                            videoId = match[1];
                        }
                    }
                    
                    // Pattern 4: youtube.com/v/VIDEO_ID
                    if (!videoId) {
                        match = url.match(/youtube\.com\/v\/([a-zA-Z0-9_-]{11})/);
                        if (match && match[1]) {
                            videoId = match[1];
                        }
                    }
                    
                    // Pattern 5: Direct video ID (11 characters)
                    if (!videoId) {
                        match = url.match(/^([a-zA-Z0-9_-]{11})$/);
                        if (match && match[1]) {
                            videoId = match[1];
                        }
                    }
                    
                    // Clean and validate video ID
                    if (videoId) {
                        videoId = videoId.trim();
                        // Ensure it contains only valid characters and is exactly 11 characters
                        if (!/^[a-zA-Z0-9_-]{11}$/.test(videoId)) {
                            console.warn('Invalid video ID format:', videoId);
                            videoId = '';
                        }
                    }
                    
                    console.log('Extracted video ID:', videoId);
                    
                    if (videoId && videoId.length === 11) {
                        // Use YouTube embed URL with proper parameters
                        // Remove origin parameter as it might cause issues
                        this.trailerEmbedUrl = `https://www.youtube.com/embed/${videoId}?rel=0&modestbranding=1&playsinline=1`;
                        console.log('Embed URL:', this.trailerEmbedUrl);
                    } else {
                        this.trailerEmbedUrl = '';
                        console.warn('Invalid YouTube URL format or video ID. URL:', url);
                    }
                },

                resetForm() {
                    this.formData = {
                        movieId: null,
                        title: '',
                        director: '',
                        duration: '',
                        rating: '',
                        rated: '',
                        releaseYear: new Date().getFullYear(),
                        description: '',
                        posterUrl: '',
                        backdropUrl: '',
                        trailerUrl: '',
                        isNew: false,
                        isFeatured: false,
                        categories: []
                    };
                    this.trailerEmbedUrl = '';
                },

                async saveMovie() {
                    try {
                        console.log('Saving movie with data:', this.formData);
                        console.log('Categories to save:', this.formData.categories);
                        
                        const url = this.isEditMode 
                            ? `../api/movies?id=` + this.formData.movieId
                            : '../api/movies';
                        
                        const method = this.isEditMode ? 'PUT' : 'POST';

                        const response = await fetch(url, {
                            method: method,
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify(this.formData)
                        });

                        if (!response.ok) {
                            const errorText = await response.text();
                            console.error('Server response:', errorText);
                            throw new Error('Failed to save movie');
                        }

                        const result = await response.json();
                        console.log('Save result:', result);

                        this.showToast('success', this.isEditMode ? 'Movie berhasil diperbarui' : 'Movie berhasil ditambahkan');
                        this.closeModal();
                        this.loadMovies();
                    } catch (error) {
                        console.error('Error saving movie:', error);
                        this.showToast('error', 'Gagal menyimpan movie');
                    }
                },

                confirmDelete(movie) {
                    this.movieToDelete = movie;
                    this.showDeleteModal = true;
                },

                async deleteMovie() {
                    try {
                        const response = await fetch(`../api/movies?id=` + this.movieToDelete.movieId, {
                            method: 'DELETE'
                        });

                        if (!response.ok) {
                            throw new Error('Failed to delete movie');
                        }

                        this.showToast('success', 'Movie berhasil dihapus');
                        this.showDeleteModal = false;
                        this.movieToDelete = null;
                        this.loadMovies();
                    } catch (error) {
                        console.error('Error deleting movie:', error);
                        this.showToast('error', 'Gagal menghapus movie');
                    }
                },

                viewMovieDetail(movie) {
                    window.location.href = "movie-detail.jsp?movieId=" + movie.movieId;
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
