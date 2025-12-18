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
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
        
        * {
            font-family: 'Inter', sans-serif;
        }
        
        body { 
            background: #f8f9fa;
        }
        
        .header-section {
            background: #ffffff;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .modern-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
        }
        
        .table-modern {
            border-spacing: 0 8px;
            border-collapse: separate;
        }
        
        .table-row-modern {
            background: #ffffff;
            transition: all 0.2s ease;
        }
        
        .table-row-modern:hover {
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            transform: translateY(-2px);
        }
        
        .btn-primary {
            background: #1f2937;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: #111827;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }
        
        .input-modern {
            transition: all 0.2s ease;
            border: 1px solid #e5e7eb;
        }
        
        .input-modern:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            outline: none;
        }
        
        .poster-frame {
            position: relative;
            overflow: hidden;
            border-radius: 8px;
            border: 1px solid #e5e7eb;
        }
        
        .poster-frame img {
            transition: transform 0.3s ease;
        }
        
        .poster-frame:hover img {
            transform: scale(1.05);
        }
        
        .badge-minimal {
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
        }
        
        .action-btn {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        
        .rating-box {
            background: #fef3c7;
            border: 1px solid #fcd34d;
            padding: 0.375rem 0.75rem;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
        }
        
        .scrollbar-minimal::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }
        
        .scrollbar-minimal::-webkit-scrollbar-track {
            background: #f3f4f6;
        }
        
        .scrollbar-minimal::-webkit-scrollbar-thumb {
            background: #d1d5db;
            border-radius: 3px;
        }
        
        .scrollbar-minimal::-webkit-scrollbar-thumb:hover {
            background: #9ca3af;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .fade-in {
            animation: fadeIn 0.3s ease;
        }
    </style>
</head>
<body>
    <div x-data="moviesAdmin()" class="flex h-screen overflow-hidden">
        <!-- Sidebar -->
        <jsp:include page="../component/admin/sidebar.jsp" />

        <!-- Main Content -->
        <div class="flex-1 overflow-auto scrollbar-minimal bg-gray-50">
            <!-- Header -->
            <div class="header-section sticky top-0 z-10">
                <div class="p-6">
                    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                        <div class="fade-in">
                            <h2 class="text-3xl font-bold text-gray-900 mb-1">Manajemen Film</h2>
                            <p class="text-gray-600 text-sm">Kelola semua film dalam sistem</p>
                        </div>
                        <button @click="openAddModal()" class="btn-primary text-white px-6 py-3 rounded-lg font-semibold flex items-center gap-2">
                            <i class="fas fa-plus"></i>
                            <span>Tambah Film</span>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Movies Grid -->
            <div class="p-6">
                <div class="modern-card rounded-lg overflow-hidden fade-in">
                    <!-- Search and Filter -->
                    <div class="p-4 bg-gray-50 border-b">
                        <div class="flex flex-col md:flex-row gap-3">
                            <div class="flex-1 relative">
                                <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 text-sm"></i>
                                <input type="text" x-model="searchQuery" @input="searchMovies()" 
                                       placeholder="Cari film..." 
                                       class="input-modern w-full pl-10 pr-4 py-2.5 rounded-lg text-sm">
                            </div>
                            <div class="relative">
                                <select x-model="filterCategory" @change="filterMovies()" 
                                        class="input-modern pl-4 pr-10 py-2.5 rounded-lg appearance-none bg-white text-sm min-w-[180px]">
                                    <option value="">Semua Kategori</option>
                                    <template x-for="category in categories" :key="category.categoryId">
                                        <option :value="category.categoryId" x-text="category.categoryName"></option>
                                    </template>
                                </select>
                                <i class="fas fa-chevron-down absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 text-xs pointer-events-none"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Table -->
                    <div class="overflow-x-auto scrollbar-minimal">
                        <table class="table-modern w-full">
                            <thead>
                                <tr class="bg-gray-50 border-b border-gray-200">
                                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase">Poster</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase">Judul</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase">Sutradara</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase">Durasi</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase">Rating</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase">Tahun</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase">Status</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <template x-if="loading">
                                    <tr>
                                        <td colspan="8" class="px-4 py-12 text-center">
                                            <div class="flex flex-col items-center gap-3">
                                                <div class="w-12 h-12 border-3 border-gray-200 border-t-gray-800 rounded-full animate-spin"></div>
                                                <p class="text-gray-600 text-sm">Memuat data...</p>
                                            </div>
                                        </td>
                                    </tr>
                                </template>
                                <template x-if="!loading && filteredMovies.length === 0">
                                    <tr>
                                        <td colspan="8" class="px-4 py-12 text-center">
                                            <div class="flex flex-col items-center gap-3">
                                                <div class="w-16 h-16 rounded-full bg-gray-100 flex items-center justify-center">
                                                    <i class="fas fa-film text-3xl text-gray-400"></i>
                                                </div>
                                                <div>
                                                    <p class="text-gray-700 font-medium mb-1">Tidak ada film ditemukan</p>
                                                    <p class="text-gray-500 text-sm">Coba ubah filter pencarian</p>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </template>
                                <template x-for="movie in filteredMovies" :key="movie.movieId">
                                    <tr class="table-row-modern border-b border-gray-100 last:border-0">
                                        <td class="px-4 py-3">
                                            <div class="poster-frame w-16 h-24">
                                                <img :src="movie.posterUrl" :alt="movie.title" 
                                                     class="w-full h-full object-cover">
                                            </div>
                                        </td>
                                        <td class="px-4 py-3">
                                            <div class="font-semibold text-gray-900 mb-1" x-text="movie.title"></div>
                                            <span class="badge-minimal inline-block"
                                                 :class="{
                                                     'bg-green-100 text-green-700': movie.rated === 'SU',
                                                     'bg-yellow-100 text-yellow-700': movie.rated === '13+',
                                                     'bg-orange-100 text-orange-700': movie.rated === '17+',
                                                     'bg-red-100 text-red-700': movie.rated === '21+'
                                                 }"
                                                 x-text="movie.rated">
                                            </span>
                                        </td>
                                        <td class="px-4 py-3">
                                            <span class="text-gray-700 text-sm" x-text="movie.director"></span>
                                        </td>
                                        <td class="px-4 py-3">
                                            <span class="text-gray-700 text-sm" x-text="movie.duration + ' min'"></span>
                                        </td>
                                        <td class="px-4 py-3">
                                            <div class="rating-box">
                                                <i class="fas fa-star text-yellow-600 text-sm"></i>
                                                <span class="text-gray-900 font-semibold text-sm" x-text="movie.rating"></span>
                                            </div>
                                        </td>
                                        <td class="px-4 py-3">
                                            <span class="text-gray-700 text-sm" x-text="movie.releaseYear"></span>
                                        </td>
                                        <td class="px-4 py-3">
                                            <div class="flex flex-wrap gap-1">
                                                <span x-show="movie.isNew" class="badge-minimal bg-green-50 text-green-700 border border-green-200">
                                                    Baru
                                                </span>
                                                <span x-show="movie.isFeatured" class="badge-minimal bg-blue-50 text-blue-700 border border-blue-200">
                                                    Unggulan
                                                </span>
                                            </div>
                                        </td>
                                        <td class="px-4 py-3">
                                            <div class="flex gap-1">
                                                <button @click="viewMovieDetail(movie)" 
                                                        class="action-btn bg-blue-50 text-blue-600 hover:bg-blue-100" 
                                                        title="Lihat Detail">
                                                    <i class="fas fa-eye text-sm"></i>
                                                </button>
                                                <button @click="openEditModal(movie)" 
                                                        class="action-btn bg-amber-50 text-amber-600 hover:bg-amber-100"
                                                        title="Edit">
                                                    <i class="fas fa-edit text-sm"></i>
                                                </button>
                                                <button @click="confirmDelete(movie)" 
                                                        class="action-btn bg-red-50 text-red-600 hover:bg-red-100"
                                                        title="Hapus">
                                                    <i class="fas fa-trash text-sm"></i>
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
