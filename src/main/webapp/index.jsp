<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="id" class="scroll-smooth">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CineGO - Pesan Tiket Bioskop Online</title>

        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>

        <!-- Alpine.js -->
        <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
            rel="stylesheet">

        <style>
            body {
                font-family: 'Inter', sans-serif;
            }

            [x-cloak] {
                display: none !important;
            }

            .gradient-overlay {
                background: linear-gradient(to bottom, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 0.8) 100%);
            }

            .hero-gradient {
                background: linear-gradient(to right, rgba(0, 0, 0, 0.9) 0%, rgba(0, 0, 0, 0.3) 50%, rgba(0, 0, 0, 0.9) 100%);
            }

            .movie-card {
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            .movie-card:hover {
                transform: translateY(-8px) scale(1.02);
            }

            .shimmer {
                background: linear-gradient(90deg, #1f2937 25%, #374151 50%, #1f2937 75%);
                background-size: 200% 100%;
                animation: shimmer 2s infinite;
            }

            @keyframes shimmer {
                0% {
                    background-position: 200% 0;
                }

                100% {
                    background-position: -200% 0;
                }
            }

            .star-rating {
                color: #fbbf24;
            }

            .btn-primary {
                background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
                transition: all 0.3s;
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(239, 68, 68, 0.4);
            }

            .modal-backdrop {
                backdrop-filter: blur(8px);
                background: rgba(0, 0, 0, 0.8);
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .fade-in-up {
                animation: fadeInUp 0.6s ease-out;
            }

            .seat {
                transition: all 0.2s;
            }

            .seat.available:hover {
                transform: scale(1.1);
                background-color: #fbbf24;
            }

            .seat.selected {
                background-color: #ef4444;
            }

            .seat.occupied {
                background-color: #4b5563;
                cursor: not-allowed;
            }
        </style>

        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            primary: '#ef4444',
                            dark: '#0f172a',
                        }
                    }
                }
            }
        </script>
    </head>

    <body class="bg-slate-950 text-white" x-data="cinemaApp()">

        <!-- Navigation Bar -->
        <jsp:include page="component/navbar.jsp" />

        <!-- Hero Section with Carousel -->
        <section id="home" class="relative h-screen overflow-hidden">
            <div class="absolute inset-0" x-data="{ currentSlide: 0, autoplay: null }" x-init="
            autoplay = setInterval(() => {
                currentSlide = (currentSlide + 1) % heroMovies.length;
            }, 5000);
        " @click.away="clearInterval(autoplay)">
                <template x-for="(movie, index) in heroMovies" :key="index">
                    <div x-show="currentSlide === index" x-transition:enter="transition ease-out duration-700"
                        x-transition:enter-start="opacity-0 transform scale-105"
                        x-transition:enter-end="opacity-100 transform scale-100"
                        x-transition:leave="transition ease-in duration-300" x-transition:leave-start="opacity-100"
                        x-transition:leave-end="opacity-0" class="absolute inset-0">
                        <img :src="movie.backdrop" :alt="movie.title" class="w-full h-full object-cover">
                        <div class="absolute inset-0 hero-gradient"></div>
                        <div class="absolute inset-0 gradient-overlay"></div>
                    </div>
                </template>

                <!-- Hero Content -->
                <div class="relative h-full flex items-center">
                    <div class="container mx-auto px-4 lg:px-8">
                        <div class="max-w-2xl fade-in-up">
                            <template x-for="(movie, index) in heroMovies" :key="index">
                                <div x-show="currentSlide === index" x-transition>
                                    <div
                                        class="inline-block px-4 py-1 bg-red-600/80 rounded-full text-sm font-semibold mb-4">
                                        <i class="fas fa-fire mr-1"></i> Sedang Trending
                                    </div>
                                    <h1 class="text-5xl md:text-7xl font-bold mb-4" x-text="movie.title"></h1>
                                    <div class="flex items-center space-x-4 mb-6">
                                        <div class="flex items-center">
                                            <i class="fas fa-star star-rating mr-1"></i>
                                            <span x-text="movie.rating" class="font-semibold"></span>
                                        </div>
                                        <span class="text-gray-300" x-text="movie.year"></span>
                                        <span class="px-3 py-1 border border-gray-500 rounded text-sm"
                                            x-text="movie.rated"></span>
                                        <span class="text-gray-300" x-text="movie.duration"></span>
                                    </div>
                                    <p class="text-lg text-gray-300 mb-8" x-text="movie.description"></p>
                                    <div class="flex flex-wrap gap-4">
                                        <button @click="selectMovie(movie)"
                                            class="px-8 py-4 btn-primary rounded-lg font-semibold text-lg shadow-xl">
                                            <i class="fas fa-ticket-alt mr-2"></i> Pesan Sekarang
                                        </button>
                                        <button @click="openTrailer(movie)"
                                            class="px-8 py-4 bg-white/20 backdrop-blur-sm rounded-lg font-semibold text-lg hover:bg-white/30 transition">
                                            <i class="fas fa-play mr-2"></i> Tonton Trailer
                                        </button>
                                        <button
                                            class="px-4 py-4 bg-white/10 backdrop-blur-sm rounded-lg hover:bg-white/20 transition">
                                            <i class="fas fa-info-circle"></i>
                                        </button>
                                    </div>
                                </div>
                            </template>
                        </div>
                    </div>
                </div>

                <!-- Carousel Controls -->
                <div class="absolute bottom-8 left-0 right-0">
                    <div class="container mx-auto px-4 lg:px-8">
                        <div class="flex items-center justify-between">
                            <div class="flex space-x-2">
                                <template x-for="(movie, index) in heroMovies" :key="index">
                                    <button @click="currentSlide = index"
                                        class="h-1 rounded-full transition-all duration-300"
                                        :class="currentSlide === index ? 'w-12 bg-red-500' : 'w-8 bg-white/50'">
                                    </button>
                                </template>
                            </div>
                            <div class="hidden md:flex space-x-2">
                                <button
                                    @click="currentSlide = (currentSlide - 1 + heroMovies.length) % heroMovies.length"
                                    class="w-12 h-12 bg-white/20 backdrop-blur-sm rounded-full hover:bg-white/30 transition">
                                    <i class="fas fa-chevron-left"></i>
                                </button>
                                <button @click="currentSlide = (currentSlide + 1) % heroMovies.length"
                                    class="w-12 h-12 bg-white/20 backdrop-blur-sm rounded-full hover:bg-white/30 transition">
                                    <i class="fas fa-chevron-right"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Category Filter -->
        <section class="py-8 bg-slate-900/50 sticky top-20 z-40 backdrop-blur-md">
            <div class="container mx-auto px-4 lg:px-8">
                <div class="flex flex-wrap gap-3 justify-center">
                    <button @click="selectedCategory = 'all'; filterMovies()"
                        class="px-6 py-2 rounded-full font-semibold transition"
                        :class="selectedCategory === 'all' ? 'bg-red-600' : 'bg-slate-800 hover:bg-slate-700'">
                        Semua
                    </button>
                    <template x-for="category in categories" :key="category.categoryId">
                        <button @click="selectedCategory = category.categoryName; filterMovies()"
                            class="px-6 py-2 rounded-full font-semibold transition capitalize"
                            :class="selectedCategory === category.categoryName ? 'bg-red-600' : 'bg-slate-800 hover:bg-slate-700'"
                            x-text="category.categoryName">
                        </button>
                    </template>
                </div>
            </div>
        </section>

        <!-- Movies Grid -->
        <section id="movies" class="py-16 bg-gradient-to-b from-slate-950 to-slate-900">
            <div class="container mx-auto px-4 lg:px-8">
                <div class="flex items-center justify-between mb-8">
                    <h2 class="text-3xl md:text-4xl font-bold">
                        <i class="fas fa-film text-red-500 mr-3"></i>
                        Film Sedang Tayang
                    </h2>
                    <button class="text-red-500 hover:text-red-400 transition">
                        Lihat Semua <i class="fas fa-arrow-right ml-2"></i>
                    </button>
                </div>

                <!-- Loading Indicator -->
                <div x-show="loading" class="text-center py-20">
                    <div class="inline-block animate-spin rounded-full h-16 w-16 border-t-2 border-b-2 border-red-500">
                    </div>
                    <p class="mt-4 text-gray-400">Memuat data...</p>
                </div>

                <!-- Movie Grid -->
                <div x-show="!loading" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-6">
                    <template x-for="movie in filteredMovies" :key="movie.id">
                        <div @click="selectMovie(movie)"
                            class="movie-card bg-slate-800 rounded-xl overflow-hidden shadow-xl cursor-pointer group">
                            <div class="relative overflow-hidden aspect-[2/3]">
                                <img :src="movie.poster" :alt="movie.title"
                                    class="w-full h-full object-cover group-hover:scale-110 transition duration-500">
                                <div
                                    class="absolute inset-0 bg-gradient-to-t from-black/90 via-black/20 to-transparent opacity-0 group-hover:opacity-100 transition duration-300">
                                    <div class="absolute bottom-0 left-0 right-0 p-4">
                                        <button class="w-full btn-primary py-2 rounded-lg font-semibold">
                                            <i class="fas fa-ticket-alt mr-2"></i> Pesan Tiket
                                        </button>
                                    </div>
                                </div>
                                <div class="absolute top-3 right-3 bg-black/80 backdrop-blur-sm px-3 py-1 rounded-full">
                                    <i class="fas fa-star star-rating text-sm mr-1"></i>
                                    <span class="font-semibold" x-text="movie.rating"></span>
                                </div>
                                <div class="absolute top-3 left-3 px-3 py-1 bg-red-600 rounded-full text-xs font-bold"
                                    x-show="movie.isNew">
                                    NEW
                                </div>
                            </div>
                            <div class="p-4">
                                <h3 class="font-bold text-lg mb-2 line-clamp-1" x-text="movie.title"></h3>
                                <div class="flex items-center justify-between text-sm text-gray-400">
                                    <span x-text="movie.genre[0]"></span>
                                    <span x-text="movie.year"></span>
                                </div>
                            </div>
                        </div>
                    </template>
                </div>

                <!-- No Results -->
                <div x-show="!loading && filteredMovies.length === 0" class="text-center py-20">
                    <i class="fas fa-film text-6xl text-gray-600 mb-4"></i>
                    <p class="text-xl text-gray-400">Tidak ada film yang ditemukan</p>
                </div>
            </div>
        </section>

        <!-- Promo Section -->
        <section id="promo" class="py-16 bg-slate-950">
            <div class="container mx-auto px-4 lg:px-8">
                <h2 class="text-3xl md:text-4xl font-bold mb-8">
                    <i class="fas fa-tags text-red-500 mr-3"></i>
                    Promo Spesial
                </h2>
                <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <div
                        class="bg-gradient-to-br from-red-600 to-red-800 rounded-xl p-8 relative overflow-hidden group hover:scale-105 transition">
                        <div class="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -mr-16 -mt-16"></div>
                        <i class="fas fa-percent text-5xl mb-4 opacity-50"></i>
                        <h3 class="text-2xl font-bold mb-2">Diskon 50%</h3>
                        <p class="text-red-100 mb-4">Untuk member baru! Buruan daftar sekarang.</p>
                        <button
                            class="px-6 py-2 bg-white text-red-600 rounded-lg font-semibold hover:bg-gray-100 transition">
                            Klaim Sekarang
                        </button>
                    </div>

                    <div
                        class="bg-gradient-to-br from-purple-600 to-purple-800 rounded-xl p-8 relative overflow-hidden group hover:scale-105 transition">
                        <div class="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -mr-16 -mt-16"></div>
                        <i class="fas fa-gift text-5xl mb-4 opacity-50"></i>
                        <h3 class="text-2xl font-bold mb-2">Buy 2 Get 1</h3>
                        <p class="text-purple-100 mb-4">Ajak teman nonton lebih hemat!</p>
                        <button
                            class="px-6 py-2 bg-white text-purple-600 rounded-lg font-semibold hover:bg-gray-100 transition">
                            Info Lengkap
                        </button>
                    </div>

                    <div
                        class="bg-gradient-to-br from-blue-600 to-blue-800 rounded-xl p-8 relative overflow-hidden group hover:scale-105 transition">
                        <div class="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -mr-16 -mt-16"></div>
                        <i class="fas fa-crown text-5xl mb-4 opacity-50"></i>
                        <h3 class="text-2xl font-bold mb-2">VIP Membership</h3>
                        <p class="text-blue-100 mb-4">Nikmati berbagai keuntungan eksklusif!</p>
                        <button
                            class="px-6 py-2 bg-white text-blue-600 rounded-lg font-semibold hover:bg-gray-100 transition">
                            Bergabung
                        </button>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="bg-slate-950 border-t border-slate-800 py-12">
            <div class="container mx-auto px-4 lg:px-8">
                <div class="grid md:grid-cols-4 gap-8 mb-8">
                    <div>
                        <div class="flex items-center space-x-2 mb-4">
                            <div class="bg-gradient-to-br from-red-500 to-red-700 p-2 rounded-lg">
                                <i class="fas fa-film text-xl"></i>
                            </div>
                            <span class="text-xl font-bold">CinemaX</span>
                        </div>
                        <p class="text-gray-400">Pengalaman menonton film terbaik dengan teknologi terkini.</p>
                    </div>
                    <div>
                        <h4 class="font-bold mb-4">Perusahaan</h4>
                        <ul class="space-y-2 text-gray-400">
                            <li><a href="#" class="hover:text-red-500 transition">Tentang Kami</a></li>
                            <li><a href="#" class="hover:text-red-500 transition">Karir</a></li>
                            <li><a href="#" class="hover:text-red-500 transition">Blog</a></li>
                        </ul>
                    </div>
                    <div>
                        <h4 class="font-bold mb-4">Bantuan</h4>
                        <ul class="space-y-2 text-gray-400">
                            <li><a href="#" class="hover:text-red-500 transition">FAQ</a></li>
                            <li><a href="#" class="hover:text-red-500 transition">Kebijakan Privasi</a></li>
                            <li><a href="#" class="hover:text-red-500 transition">Syarat & Ketentuan</a></li>
                        </ul>
                    </div>
                    <div>
                        <h4 class="font-bold mb-4">Ikuti Kami</h4>
                        <div class="flex space-x-4">
                            <a href="#"
                                class="w-10 h-10 bg-slate-800 rounded-full flex items-center justify-center hover:bg-red-600 transition">
                                <i class="fab fa-facebook-f"></i>
                            </a>
                            <a href="#"
                                class="w-10 h-10 bg-slate-800 rounded-full flex items-center justify-center hover:bg-red-600 transition">
                                <i class="fab fa-instagram"></i>
                            </a>
                            <a href="#"
                                class="w-10 h-10 bg-slate-800 rounded-full flex items-center justify-center hover:bg-red-600 transition">
                                <i class="fab fa-twitter"></i>
                            </a>
                            <a href="#"
                                class="w-10 h-10 bg-slate-800 rounded-full flex items-center justify-center hover:bg-red-600 transition">
                                <i class="fab fa-youtube"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="border-t border-slate-800 pt-8 text-center text-gray-400">
                    <p>&copy; 2025 CinemaX. All rights reserved.</p>
                </div>
            </div>
        </footer>

        <!-- Movie Detail Modal -->
        <div x-show="selectedMovie" x-cloak @click.self="selectedMovie = null"
            class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-backdrop"
            x-transition:enter="transition ease-out duration-300" x-transition:enter-start="opacity-0"
            x-transition:enter-end="opacity-100" x-transition:leave="transition ease-in duration-200"
            x-transition:leave-start="opacity-100" x-transition:leave-end="opacity-0">

            <div class="bg-slate-900 rounded-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto shadow-2xl"
                x-show="selectedMovie" @click.stop x-transition:enter="transition ease-out duration-300"
                x-transition:enter-start="opacity-0 transform scale-95"
                x-transition:enter-end="opacity-100 transform scale-100">

                <template x-if="selectedMovie">
                    <div>
                        <!-- Movie Backdrop -->
                        <div class="relative h-96">
                            <img :src="selectedMovie.backdrop" class="w-full h-full object-cover">
                            <div
                                class="absolute inset-0 bg-gradient-to-t from-slate-900 via-slate-900/50 to-transparent">
                            </div>
                            <button @click="selectedMovie = null"
                                class="absolute top-4 right-4 w-10 h-10 bg-black/50 backdrop-blur-sm rounded-full hover:bg-black/70 transition">
                                <i class="fas fa-times"></i>
                            </button>
                            <div class="absolute bottom-8 left-8 right-8">
                                <h2 class="text-4xl font-bold mb-4" x-text="selectedMovie.title"></h2>
                                <div class="flex flex-wrap items-center gap-4">
                                    <div class="flex items-center">
                                        <i class="fas fa-star star-rating mr-1"></i>
                                        <span class="font-semibold" x-text="selectedMovie.rating"></span>
                                    </div>
                                    <span x-text="selectedMovie.year"></span>
                                    <span class="px-3 py-1 border border-gray-500 rounded"
                                        x-text="selectedMovie.rated"></span>
                                    <span x-text="selectedMovie.duration"></span>
                                </div>
                            </div>
                        </div>

                        <!-- Movie Details -->
                        <div class="p-8">
                            <div class="mb-6">
                                <h3 class="text-xl font-bold mb-2">Sinopsis</h3>
                                <p class="text-gray-300" x-text="selectedMovie.description"></p>
                            </div>

                            <div class="grid md:grid-cols-2 gap-6 mb-6">
                                <div>
                                    <h4 class="font-bold mb-2">Genre</h4>
                                    <div class="flex flex-wrap gap-2">
                                        <template x-for="genre in selectedMovie.genre" :key="genre">
                                            <span class="px-3 py-1 bg-slate-800 rounded-full text-sm"
                                                x-text="genre"></span>
                                        </template>
                                    </div>
                                </div>
                                <div>
                                    <h4 class="font-bold mb-2">Sutradara</h4>
                                    <p class="text-gray-300" x-text="selectedMovie.director"></p>
                                </div>
                            </div>

                            <!-- Schedule Selection -->
                            <div class="mb-6">
                                <h3 class="text-xl font-bold mb-4">
                                    Pilih Jadwal
                                    <span class="text-sm text-gray-400" x-show="schedules.length > 0"
                                        x-text="`(${schedules.length} jadwal tersedia)`"></span>
                                </h3>

                                <div x-show="schedules.length === 0" class="text-center text-gray-400 py-8">
                                    Tidak ada jadwal tersedia untuk film ini
                                </div>

                                <!-- Step-by-step schedule selection -->
                                <div x-show="schedules.length > 0" class="space-y-4">
                                    <!-- Step 1: Select Theater/Cinema -->
                                    <div>
                                        <label class="block text-sm font-semibold mb-2">
                                            <i class="fas fa-building text-red-500 mr-2"></i>
                                            1. Pilih Bioskop
                                        </label>
                                        <select
                                            @change="selectedTheater = $event.target.value; selectedDate = ''; selectedTime = ''; selectedScheduleId = null; updateAvailableDates(); showSeatSelection = false; selectedSeats = []; selectedSeatIds = [];"
                                            class="w-full px-4 py-3 bg-slate-800 border-2 border-slate-700 rounded-xl text-white focus:outline-none focus:border-red-500 transition">
                                            <option value="">-- Pilih Bioskop --</option>
                                            <template x-for="theater in getUniqueTheaters()" :key="theater">
                                                <option :value="theater" x-text="theater"></option>
                                            </template>
                                        </select>
                                    </div>

                                    <!-- Step 2: Select Date -->
                                    <div x-show="selectedTheater" x-transition>
                                        <label class="block text-sm font-semibold mb-2">
                                            <i class="fas fa-calendar text-red-500 mr-2"></i>
                                            2. Pilih Tanggal
                                        </label>
                                        <select
                                            @change="selectedDate = $event.target.value; selectedTime = ''; selectedScheduleId = null; updateAvailableTimes(); showSeatSelection = false; selectedSeats = []; selectedSeatIds = [];"
                                            class="w-full px-4 py-3 bg-slate-800 border-2 border-slate-700 rounded-xl text-white focus:outline-none focus:border-red-500 transition">
                                            <option value="">-- Pilih Tanggal --</option>
                                            <template x-for="date in availableDates" :key="date">
                                                <option :value="date" x-text="formatDate(date)"></option>
                                            </template>
                                        </select>
                                    </div>

                                    <!-- Step 3: Select Time -->
                                    <div x-show="selectedDate" x-transition>
                                        <label class="block text-sm font-semibold mb-2">
                                            <i class="fas fa-clock text-red-500 mr-2"></i>
                                            3. Pilih Jam Tayang
                                        </label>
                                        <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
                                            <template x-for="timeSlot in availableTimes" :key="timeSlot.scheduleId">
                                                <button
                                                    @click="selectedTime = timeSlot.showTime; selectedScheduleId = timeSlot.scheduleId; currentPrice = timeSlot.price; showSeatSelection = false; selectedSeats = []; selectedSeatIds = [];"
                                                    class="p-4 rounded-xl border-2 transition-all" :class="selectedScheduleId === timeSlot.scheduleId 
                                                        ? 'border-red-500 bg-red-500/10' 
                                                        : 'border-slate-700 bg-slate-800 hover:border-slate-600'">
                                                    <div class="text-center">
                                                        <div class="text-xl font-bold mb-1"
                                                            x-text="timeSlot.showTime.substring(0,5)"></div>
                                                        <div class="text-sm text-red-500"
                                                            x-text="formatPrice(timeSlot.price)"></div>
                                                    </div>
                                                </button>
                                            </template>
                                        </div>
                                    </div>

                                    <!-- Selected Schedule Summary -->
                                    <div x-show="selectedScheduleId" x-transition
                                        class="p-4 bg-slate-800 rounded-xl border-2 border-red-500/30">
                                        <h4 class="font-semibold mb-3 text-red-500">
                                            <i class="fas fa-check-circle mr-2"></i>
                                            Jadwal yang Dipilih
                                        </h4>
                                        <div class="grid md:grid-cols-3 gap-3 text-sm">
                                            <div>
                                                <div class="text-gray-400 mb-1">Bioskop</div>
                                                <div class="font-semibold" x-text="selectedTheater"></div>
                                            </div>
                                            <div>
                                                <div class="text-gray-400 mb-1">Tanggal</div>
                                                <div class="font-semibold" x-text="formatDate(selectedDate)"></div>
                                            </div>
                                            <div>
                                                <div class="text-gray-400 mb-1">Jam & Harga</div>
                                                <div class="font-semibold">
                                                    <span
                                                        x-text="selectedTime ? selectedTime.substring(0,5) : ''"></span>
                                                    <span class="text-red-500 ml-2"
                                                        x-text="formatPrice(currentPrice)"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Seat Selection -->
                            <div class="mb-6" x-show="showSeatSelection">
                                <h3 class="text-xl font-bold mb-4">Pilih Kursi</h3>

                                <!-- Screen -->
                                <div class="mb-8">
                                    <div
                                        class="h-2 bg-gradient-to-r from-transparent via-gray-400 to-transparent rounded-full mb-2">
                                    </div>
                                    <p class="text-center text-sm text-gray-400">Layar</p>
                                </div>

                                <!-- Seats Grid -->
                                <div class="max-w-2xl mx-auto mb-6">
                                    <template x-for="row in seats" :key="row.row">
                                        <div class="flex items-center justify-center mb-3">
                                            <span class="w-8 text-center font-bold text-gray-500"
                                                x-text="row.row"></span>
                                            <div class="flex gap-2">
                                                <template x-for="seat in row.seats" :key="seat.number">
                                                    <button @click="toggleSeat(row.row, seat.number)"
                                                        :disabled="seat.status === 'occupied'"
                                                        class="seat w-8 h-8 rounded-t-lg" :class="{
                                                            'available bg-green-600 hover:bg-yellow-500': seat.status === 'available',
                                                            'selected': seat.status === 'selected',
                                                            'occupied': seat.status === 'occupied'
                                                        }">
                                                    </button>
                                                </template>
                                            </div>
                                        </div>
                                    </template>
                                </div>

                                <!-- Legend -->
                                <div class="flex justify-center gap-6 mb-6">
                                    <div class="flex items-center gap-2">
                                        <div class="w-6 h-6 bg-green-600 rounded-t-lg"></div>
                                        <span class="text-sm">Tersedia</span>
                                    </div>
                                    <div class="flex items-center gap-2">
                                        <div class="w-6 h-6 bg-red-600 rounded-t-lg"></div>
                                        <span class="text-sm">Dipilih</span>
                                    </div>
                                    <div class="flex items-center gap-2">
                                        <div class="w-6 h-6 bg-gray-600 rounded-t-lg"></div>
                                        <span class="text-sm">Terisi</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Booking Summary -->
                            <div class="bg-slate-800 rounded-xl p-6 mb-6" x-show="selectedSeats.length > 0">
                                <h3 class="text-xl font-bold mb-4">Ringkasan Pesanan</h3>
                                <div class="space-y-3">
                                    <div class="flex justify-between">
                                        <span class="text-gray-400">Kursi yang dipilih:</span>
                                        <span class="font-semibold"
                                            x-text="selectedSeats.length > 0 ? selectedSeats.join(', ') : '-'"></span>
                                    </div>
                                    <div class="flex justify-between">
                                        <span class="text-gray-400">Jumlah Tiket:</span>
                                        <span class="font-semibold" x-text="selectedSeats.length"></span>
                                    </div>
                                    <div class="flex justify-between">
                                        <span class="text-gray-400">Harga per Tiket:</span>
                                        <span class="font-semibold" x-text="formatPrice(currentPrice)"></span>
                                    </div>
                                    <div class="border-t border-slate-700 pt-3 flex justify-between text-xl">
                                        <span class="font-bold">Total:</span>
                                        <span class="font-bold text-red-500"
                                            x-text="formatPrice(getTotalPrice())"></span>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="flex gap-4">
                                <button @click="loadSeats()"
                                    class="flex-1 px-8 py-4 btn-primary rounded-xl font-semibold text-lg"
                                    x-show="!showSeatSelection" :disabled="loading">
                                    <i class="fas fa-ticket-alt mr-2"></i>
                                    <span x-text="loading ? 'Loading...' : 'Pilih Kursi'"></span>
                                </button>
                                <button @click="bookTickets()"
                                    class="flex-1 px-8 py-4 btn-primary rounded-xl font-semibold text-lg"
                                    x-show="showSeatSelection && selectedSeats.length > 0" :disabled="loading">
                                    <i class="fas fa-check mr-2"></i>
                                    <span x-text="loading ? 'Processing...' : 'Konfirmasi Pesanan'"></span>
                                </button>
                                <button @click="openTrailer(selectedMovie)"
                                    class="px-8 py-4 bg-slate-800 rounded-xl font-semibold hover:bg-slate-700 transition">
                                    <i class="fas fa-play mr-2"></i> Trailer
                                </button>
                            </div>
                        </div>
                    </div>
                </template>
            </div>
        </div>

        <!-- Trailer Modal -->
        <div x-show="showTrailer" x-cloak @click.self="closeTrailer()"
            class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-backdrop" x-transition>
            <div class="bg-slate-900 rounded-2xl max-w-5xl w-full p-6" @click.stop
                x-transition:enter="transition ease-out duration-300"
                x-transition:enter-start="opacity-0 transform scale-95"
                x-transition:enter-end="opacity-100 transform scale-100">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold" x-text="selectedMovie?.title + ' - Trailer'"></h3>
                    <button @click="closeTrailer()"
                        class="w-10 h-10 bg-slate-800 rounded-full hover:bg-slate-700 transition">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="aspect-video bg-slate-800 rounded-xl overflow-hidden">
                    <template x-if="trailerEmbedUrl">
                        <div class="w-full h-full relative">
                            <iframe :src="trailerEmbedUrl" class="w-full h-full" frameborder="0"
                                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                                allowfullscreen @error="console.error('YouTube iframe error')">
                            </iframe>
                            <div x-show="false" class="absolute inset-0 bg-slate-800 flex items-center justify-center">
                                <div class="text-center">
                                    <i class="fas fa-exclamation-triangle text-red-500 text-4xl mb-4"></i>
                                    <p class="text-white mb-2">Video tidak dapat dimuat</p>
                                    <p class="text-sm text-gray-400">Video mungkin dibatasi untuk ditonton di website
                                        lain</p>
                                    <a :href="selectedMovie?.trailerUrl" target="_blank"
                                        class="mt-4 inline-block px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">
                                        <i class="fab fa-youtube mr-2"></i>Tonton di YouTube
                                    </a>
                                </div>
                            </div>
                        </div>
                    </template>
                    <template x-if="!trailerEmbedUrl">
                        <div class="w-full h-full flex items-center justify-center">
                            <div class="text-center">
                                <i class="fas fa-film text-6xl text-gray-600 mb-4"></i>
                                <p class="text-gray-400">Trailer tidak tersedia</p>
                            </div>
                        </div>
                    </template>
                </div>

                <!-- Alternative: Open in YouTube button -->
                <div x-show="trailerEmbedUrl" class="mt-4 text-center">
                    <p class="text-sm text-gray-400 mb-2">Video tidak muncul?</p>
                    <a :href="selectedMovie?.trailerUrl" target="_blank"
                        class="inline-flex items-center gap-2 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition">
                        <i class="fab fa-youtube"></i>
                        <span>Tonton di YouTube</span>
                        <i class="fas fa-external-link-alt text-sm"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- Payment QR Code Modal -->
        <div x-show="showPaymentModal" x-cloak
            class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-backdrop" x-transition>
            <div class="bg-slate-900 rounded-2xl max-w-md w-full p-8 text-center"
                x-transition:enter="transition ease-out duration-300"
                x-transition:enter-start="opacity-0 transform scale-95"
                x-transition:enter-end="opacity-100 transform scale-100">

                <!-- Pending State - Show QR Code -->
                <div x-show="paymentStatus === 'pending'">
                    <h3 class="text-2xl font-bold mb-6">Scan QR Code untuk Pembayaran</h3>

                    <!-- QR Code Placeholder -->
                    <div class="bg-white rounded-xl p-6 mb-6 mx-auto w-64 h-64 flex items-center justify-center">
                        <div class="text-center">
                            <i class="fas fa-qrcode text-slate-800 text-9xl mb-2"></i>
                            <p class="text-slate-600 text-xs">QR Code Pembayaran</p>
                        </div>
                    </div>

                    <!-- Payment Details -->
                    <div class="bg-slate-800 rounded-lg p-4 mb-6">
                        <div class="flex justify-between mb-2">
                            <span class="text-gray-400">Total Pembayaran:</span>
                            <span class="font-bold text-red-500 text-xl" x-text="formatPrice(getTotalPrice())"></span>
                        </div>
                        <div class="flex justify-between mb-2">
                            <span class="text-gray-400">Kursi:</span>
                            <span class="font-semibold" x-text="selectedSeats.join(', ')"></span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-400">Jumlah Tiket:</span>
                            <span class="font-semibold" x-text="selectedSeats.length + ' tiket'"></span>
                        </div>
                    </div>

                    <!-- Countdown Timer -->
                    <div class="mb-4">
                        <div class="flex items-center justify-center gap-2 text-gray-400">
                            <i class="fas fa-clock"></i>
                            <span>Memproses pembayaran dalam <span class="text-red-500 font-bold"
                                    x-text="paymentCountdown"></span> detik...</span>
                        </div>
                    </div>

                    <p class="text-sm text-gray-500">Scan QR Code dengan aplikasi pembayaran Anda</p>
                </div>

                <!-- Processing State -->
                <div x-show="paymentStatus === 'processing'" class="py-8">
                    <div
                        class="w-20 h-20 border-4 border-red-500 border-t-transparent rounded-full animate-spin mx-auto mb-6">
                    </div>
                    <h3 class="text-2xl font-bold mb-2">Memproses Pembayaran...</h3>
                    <p class="text-gray-400">Mohon tunggu sebentar</p>
                </div>

                <!-- Success State -->
                <div x-show="paymentStatus === 'success'" class="py-4">
                    <div class="w-20 h-20 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-check text-4xl"></i>
                    </div>
                    <h3 class="text-2xl font-bold mb-2">Pembayaran Berhasil!</h3>
                    <p class="text-gray-400">Pesanan Anda sedang diproses...</p>
                </div>
            </div>
        </div>

        <!-- Success Modal -->
        <div x-show="showSuccess" x-cloak @click.self="showSuccess = false"
            class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-backdrop" x-transition>
            <div class="bg-slate-900 rounded-2xl max-w-md w-full p-8 text-center"
                x-transition:enter="transition ease-out duration-300"
                x-transition:enter-start="opacity-0 transform scale-95"
                x-transition:enter-end="opacity-100 transform scale-100">
                <div class="w-20 h-20 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-4">
                    <i class="fas fa-check text-4xl"></i>
                </div>
                <h3 class="text-2xl font-bold mb-2">Pemesanan Berhasil!</h3>
                <div class="bg-slate-800 rounded-lg p-4 mb-4">
                    <p class="text-sm text-gray-400 mb-1">Kode Booking Anda:</p>
                    <p class="text-2xl font-bold text-red-500" x-text="bookingCode"></p>
                </div>
                <p class="text-gray-400 mb-2">Kursi: <span class="font-semibold"
                        x-text="selectedSeats.join(', ')"></span></p>
                <p class="text-gray-400 mb-6">Total: <span class="font-semibold text-red-500"
                        x-text="formatPrice(getTotalPrice())"></span></p>
                <p class="text-sm text-gray-500 mb-6">Silakan simpan kode booking Anda. Detail lengkap telah dikirim ke
                    email Anda.</p>
                <button @click="showSuccess = false; selectedMovie = null; resetBooking()"
                    class="px-8 py-3 btn-primary rounded-lg font-semibold w-full">
                    Selesai
                </button>
            </div>
        </div>

        <!-- Toast Notification -->
        <div x-show="toast.show" x-cloak x-transition:enter="transition ease-out duration-300"
            x-transition:enter-start="opacity-0 transform translate-x-full"
            x-transition:enter-end="opacity-100 transform translate-x-0"
            x-transition:leave="transition ease-in duration-200"
            x-transition:leave-start="opacity-100 transform translate-x-0"
            x-transition:leave-end="opacity-0 transform translate-x-full"
            class="fixed bottom-4 right-4 z-50 max-w-sm w-full">
            <div class="rounded-lg shadow-lg p-4 flex items-center gap-3" :class="{
                 'bg-green-500': toast.type === 'success',
                 'bg-red-500': toast.type === 'error',
                 'bg-blue-500': toast.type === 'info',
                 'bg-yellow-500': toast.type === 'warning'
             }">
                <i class="fas text-white text-xl" :class="{
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

        <!-- Login/Register Modal -->
        <div x-show="showLoginModal" x-cloak @click.self="showLoginModal = false"
            class="fixed inset-0 z-50 flex items-center justify-center p-4 modal-backdrop" x-transition>
            <div class="bg-slate-900 rounded-2xl max-w-md w-full overflow-hidden shadow-2xl" @click.stop
                x-transition:enter="transition ease-out duration-300"
                x-transition:enter-start="opacity-0 transform scale-95"
                x-transition:enter-end="opacity-100 transform scale-100">

                <!-- Header -->
                <div class="bg-gradient-to-r from-red-600 to-red-700 px-6 py-4 flex justify-between items-center">
                    <h3 class="text-2xl font-bold" x-text="loginMode === 'login' ? 'Masuk' : 'Daftar Akun'"></h3>
                    <button @click="showLoginModal = false"
                        class="w-8 h-8 bg-white/20 rounded-full hover:bg-white/30 transition">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Login Form -->
                <div x-show="loginMode === 'login'" class="p-6" x-data="{ 
                formData: { username: '', password: '' },
                async submitLogin() {
                    if (!this.formData.username || !this.formData.password) {
                        alert('Username dan password harus diisi');
                        return;
                    }
                    await login(this.formData);
                }
            }">
                    <form @submit.prevent="submitLogin()">
                        <div class="mb-4">
                            <label class="block text-sm font-semibold mb-2">Username atau Email</label>
                            <div class="relative">
                                <i class="fas fa-user absolute left-3 top-3 text-gray-400"></i>
                                <input type="text" x-model="formData.username"
                                    placeholder="Masukkan username atau email"
                                    class="w-full pl-10 pr-4 py-3 bg-slate-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 text-white">
                            </div>
                        </div>

                        <div class="mb-6">
                            <label class="block text-sm font-semibold mb-2">Password</label>
                            <div class="relative">
                                <i class="fas fa-lock absolute left-3 top-3 text-gray-400"></i>
                                <input type="password" x-model="formData.password" placeholder="Masukkan password"
                                    class="w-full pl-10 pr-4 py-3 bg-slate-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 text-white">
                            </div>
                        </div>

                        <button type="submit" :disabled="loading"
                            class="w-full py-3 btn-primary rounded-lg font-semibold text-lg">
                            <i class="fas fa-sign-in-alt mr-2"></i>
                            <span x-text="loading ? 'Memproses...' : 'Masuk'"></span>
                        </button>
                    </form>

                    <div class="mt-6 text-center">
                        <p class="text-gray-400">Belum punya akun?
                            <button @click="loginMode = 'register'"
                                class="text-red-500 hover:text-red-400 font-semibold">
                                Daftar Sekarang
                            </button>
                        </p>
                    </div>
                </div>

                <!-- Register Form -->
                <div x-show="loginMode === 'register'" class="p-6" x-data="{ 
                formData: { username: '', email: '', password: '', confirmPassword: '', fullName: '', phone: '' },
                async submitRegister() {
                    if (!this.formData.username || !this.formData.email || !this.formData.password) {
                        alert('Username, email, dan password harus diisi');
                        return;
                    }
                    if (this.formData.password !== this.formData.confirmPassword) {
                        alert('Password dan konfirmasi password tidak sama');
                        return;
                    }
                    if (this.formData.password.length < 6) {
                        alert('Password minimal 6 karakter');
                        return;
                    }
                    await register(this.formData);
                }
            }">
                    <form @submit.prevent="submitRegister()">
                        <div class="grid md:grid-cols-2 gap-4 mb-4">
                            <div>
                                <label class="block text-sm font-semibold mb-2">Username *</label>
                                <input type="text" x-model="formData.username" placeholder="Username"
                                    class="w-full px-4 py-2 bg-slate-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 text-white">
                            </div>

                            <div>
                                <label class="block text-sm font-semibold mb-2">Nama Lengkap</label>
                                <input type="text" x-model="formData.fullName" placeholder="Nama lengkap"
                                    class="w-full px-4 py-2 bg-slate-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 text-white">
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="block text-sm font-semibold mb-2">Email *</label>
                            <input type="email" x-model="formData.email" placeholder="email@example.com"
                                class="w-full px-4 py-2 bg-slate-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 text-white">
                        </div>

                        <div class="mb-4">
                            <label class="block text-sm font-semibold mb-2">No. Telepon</label>
                            <input type="tel" x-model="formData.phone" placeholder="08123456789"
                                class="w-full px-4 py-2 bg-slate-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 text-white">
                        </div>

                        <div class="grid md:grid-cols-2 gap-4 mb-6">
                            <div>
                                <label class="block text-sm font-semibold mb-2">Password *</label>
                                <input type="password" x-model="formData.password" placeholder="Min. 6 karakter"
                                    class="w-full px-4 py-2 bg-slate-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 text-white">
                            </div>

                            <div>
                                <label class="block text-sm font-semibold mb-2">Konfirmasi *</label>
                                <input type="password" x-model="formData.confirmPassword" placeholder="Ulangi password"
                                    class="w-full px-4 py-2 bg-slate-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 text-white">
                            </div>
                        </div>

                        <button type="submit" :disabled="loading"
                            class="w-full py-3 btn-primary rounded-lg font-semibold text-lg">
                            <i class="fas fa-user-plus mr-2"></i>
                            <span x-text="loading ? 'Memproses...' : 'Daftar'"></span>
                        </button>
                    </form>

                    <div class="mt-6 text-center">
                        <p class="text-gray-400">Sudah punya akun?
                            <button @click="loginMode = 'login'" class="text-red-500 hover:text-red-400 font-semibold">
                                Masuk Sekarang
                            </button>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function cinemaApp() {
                return {
                    mobileMenu: false,
                    showSearch: false,
                    searchQuery: '',
                    selectedCategory: 'all',
                    selectedMovie: null,
                    selectedMovieId: null, // Track selected movie ID for validation
                    showSeatSelection: false,
                    showTrailer: false,
                    trailerEmbedUrl: '',
                    showSuccess: false,
                    showLoginModal: false,
                    showPaymentModal: false,
                    loginMode: 'login', // 'login' or 'register'
                    paymentStatus: 'pending', // 'pending', 'processing', 'success'
                    paymentCountdown: 10,
                    selectedSeats: [],
                    selectedSeatIds: [],
                    selectedScheduleId: null,
                    currentPrice: 50000,
                    loading: false,
                    bookingCode: '',
                    customerName: '',
                    customerEmail: '',
                    customerPhone: '',

                    // Auth
                    currentUser: null,

                    // Toast notification
                    toast: {
                        show: false,
                        message: '',
                        type: 'success' // 'success', 'error', 'info', 'warning'
                    },

                    // Step-by-step schedule selection
                    selectedTheater: '',
                    selectedDate: '',
                    selectedTime: '',
                    availableDates: [],
                    availableTimes: [],

                    categories: [],
                    heroMovies: [],
                    movies: [],
                    filteredMovies: [],
                    seats: [],
                    schedules: [],

                    // Initialize app - Load data from API
                    async init() {
                        await this.checkSession();
                        await this.loadCategories();
                        await this.loadMovies();
                        await this.loadFeaturedMovies();

                        // Check if redirected from logout
                        const urlParams = new URLSearchParams(window.location.search);
                        if (urlParams.get('logout') === 'success') {
                            this.showToast('success', 'Logout berhasil! Sampai jumpa lagi');
                            // Remove parameter from URL
                            window.history.replaceState({}, document.title, window.location.pathname);
                        }
                    },

                    // Load categories from database
                    async loadCategories() {
                        try {
                            const response = await fetch('api/categories');
                            this.categories = await response.json();
                        } catch (error) {
                            console.error('Error loading categories:', error);
                        }
                    },

                    // Load all movies from database
                    async loadMovies() {
                        try {
                            this.loading = true;
                            const response = await fetch('api/movies');
                            const movies = await response.json();

                            // Transform data to match frontend format
                            this.movies = movies.map(movie => this.transformMovie(movie));
                            this.filteredMovies = this.movies;
                        } catch (error) {
                            console.error('Error loading movies:', error);
                        } finally {
                            this.loading = false;
                        }
                    },

                    // Load featured movies for hero section
                    async loadFeaturedMovies() {
                        try {
                            const response = await fetch('api/movies?action=featured');
                            const movies = await response.json();
                            this.heroMovies = movies.map(movie => this.transformMovie(movie));
                        } catch (error) {
                            console.error('Error loading featured movies:', error);
                        }
                    },

                    // Transform movie data from database to frontend format
                    transformMovie(movie) {
                        return {
                            id: movie.movieId,
                            title: movie.title,
                            rating: movie.rating,
                            year: movie.releaseYear,
                            rated: movie.rated,
                            duration: this.formatDuration(movie.duration),
                            description: movie.description,
                            poster: movie.posterUrl,
                            backdrop: movie.backdropUrl,
                            trailerUrl: movie.trailerUrl,
                            genre: movie.genres || [],
                            director: movie.director,
                            isNew: movie.new
                        };
                    },

                    // Format duration from minutes to "Xh Ym"
                    formatDuration(minutes) {
                        const hours = Math.floor(minutes / 60);
                        const mins = minutes % 60;
                        return `${hours}h ${mins}m`;
                    },

                    // Filter movies by category and search
                    async filterMovies() {
                        try {
                            this.loading = true;

                            // Start with all movies
                            let filtered = [...this.movies];

                            // Filter by category if not 'all'
                            if (this.selectedCategory !== 'all') {
                                filtered = filtered.filter(movie => {
                                    if (movie.genre && Array.isArray(movie.genre)) {
                                        return movie.genre.some(g =>
                                            g.toLowerCase() === this.selectedCategory.toLowerCase()
                                        );
                                    }
                                    return false;
                                });
                            }

                            // Filter by search query
                            if (this.searchQuery && this.searchQuery.trim() !== '') {
                                const query = this.searchQuery.toLowerCase().trim();
                                filtered = filtered.filter(movie => {
                                    const titleMatch = movie.title.toLowerCase().includes(query);
                                    const directorMatch = movie.director && movie.director.toLowerCase().includes(query);
                                    const genreMatch = movie.genre && movie.genre.some(g =>
                                        g.toLowerCase().includes(query)
                                    );
                                    return titleMatch || directorMatch || genreMatch;
                                });
                            }

                            this.filteredMovies = filtered;
                        } catch (error) {
                            console.error('Error filtering movies:', error);
                        } finally {
                            this.loading = false;
                        }
                    },

                    // Select movie and load schedules
                    async selectMovie(movie) {
                        console.log('selectMovie called with:', movie);
                        console.log('movie.id:', movie.id);

                        if (!movie || !movie.id) {
                            console.error('Invalid movie object or missing id:', movie);
                            alert('Error: Movie data tidak valid');
                            return;
                        }

                        this.selectedMovie = movie;
                        this.selectedMovieId = movie.id; // Store movie ID for validation
                        this.showSeatSelection = false;
                        this.selectedSeats = [];
                        this.selectedSeatIds = [];

                        // Reset step-by-step selection
                        this.selectedTheater = '';
                        this.selectedDate = '';
                        this.selectedTime = '';
                        this.availableDates = [];
                        this.availableTimes = [];
                        this.selectedScheduleId = null;

                        // Reset schedules immediately to prevent showing old data
                        this.schedules = [];

                        console.log('=== SELECTED MOVIE ===');
                        console.log('Movie ID:', movie.id);
                        console.log('Movie Title:', movie.title);

                        // Load schedules for this movie
                        await this.loadSchedules(movie.id);
                    },

                    // Get unique theaters from schedules
                    getUniqueTheaters() {
                        const theaters = [...new Set(this.schedules.map(s => s.theaterName))];
                        return theaters.sort();
                    },

                    // Update available dates based on selected theater
                    updateAvailableDates() {
                        if (!this.selectedTheater) {
                            this.availableDates = [];
                            return;
                        }

                        const today = new Date();
                        today.setHours(0, 0, 0, 0); // Set to start of day for comparison

                        const dates = [...new Set(
                            this.schedules
                                .filter(s => {
                                    if (s.theaterName !== this.selectedTheater) return false;

                                    // Filter out past dates
                                    const scheduleDate = new Date(s.showDate);
                                    scheduleDate.setHours(0, 0, 0, 0);

                                    return scheduleDate >= today;
                                })
                                .map(s => s.showDate)
                        )];

                        this.availableDates = dates.sort();
                    },

                    // Update available times based on selected theater and date
                    updateAvailableTimes() {
                        if (!this.selectedTheater || !this.selectedDate) {
                            this.availableTimes = [];
                            return;
                        }

                        const now = new Date();
                        const selectedDateObj = new Date(this.selectedDate);
                        selectedDateObj.setHours(0, 0, 0, 0);
                        const today = new Date();
                        today.setHours(0, 0, 0, 0);

                        // Check if selected date is today
                        const isToday = selectedDateObj.getTime() === today.getTime();

                        this.availableTimes = this.schedules
                            .filter(s => {
                                if (s.theaterName !== this.selectedTheater || s.showDate !== this.selectedDate) {
                                    return false;
                                }

                                // If selected date is today, filter out past times
                                if (isToday) {
                                    const scheduleTime = s.showTime.split(':');
                                    const scheduleDateTime = new Date();
                                    scheduleDateTime.setHours(parseInt(scheduleTime[0]), parseInt(scheduleTime[1]), 0, 0);

                                    return scheduleDateTime > now;
                                }

                                // If selected date is in the future, show all times
                                return true;
                            })
                            .sort((a, b) => a.showTime.localeCompare(b.showTime));
                    },

                    // Format date to Indonesian format
                    formatDate(dateString) {
                        if (!dateString) return '';
                        const date = new Date(dateString);
                        return date.toLocaleDateString('id-ID', {
                            weekday: 'long',
                            year: 'numeric',
                            month: 'long',
                            day: 'numeric'
                        });
                    },

                    // Load schedules for a movie
                    async loadSchedules(movieId) {
                        try {
                            // Convert to number to avoid proxy issues
                            const numericMovieId = Number(movieId);

                            console.log('Loading schedules for movieId:', numericMovieId);
                            console.log('movieId type:', typeof numericMovieId);

                            if (!numericMovieId || isNaN(numericMovieId)) {
                                console.error('movieId is invalid:', movieId);
                                this.schedules = [];
                                this.selectedScheduleId = null;
                                return;
                            }

                            const url = `api/schedules?movieId=${numericMovieId}`;
                            console.log('Fetching URL:', url);
                            console.log('URL includes movieId:', url.includes('movieId='));
                            console.log('Numeric value being used:', numericMovieId);

                            // Alternative URL construction to avoid template issues
                            const apiUrl = 'api/schedules?movieId=' + String(numericMovieId);
                            console.log('Alternative URL:', apiUrl);

                            const response = await fetch(apiUrl);

                            if (!response.ok) {
                                console.error('API response error:', response.status);
                                this.schedules = [];
                                this.selectedScheduleId = null;
                                return;
                            }

                            this.schedules = await response.json();
                            console.log('=== SCHEDULES LOADED ===');
                            console.log('For Movie ID:', numericMovieId);
                            console.log('Total schedules:', this.schedules.length);

                            // Verify all schedules belong to correct movie
                            if (this.schedules.length > 0) {
                                const wrongSchedules = this.schedules.filter(s => s.movieId !== numericMovieId);
                                if (wrongSchedules.length > 0) {
                                    console.error('❌ VALIDATION ERROR: Found schedules from wrong movie!');
                                    console.error('Expected movieId:', numericMovieId);
                                    console.error('Wrong schedules:', wrongSchedules);
                                    alert('Error: Jadwal yang dimuat tidak sesuai dengan film!');
                                    this.schedules = [];
                                    return;
                                }
                                console.log('✅ All schedules belong to movie ID:', numericMovieId);
                            } else {
                                console.warn('No schedules available for movieId:', numericMovieId);
                                this.selectedScheduleId = null;
                            }

                            // Reset selected schedule - user must choose manually
                            this.selectedScheduleId = null;
                            this.currentPrice = 0;
                        } catch (error) {
                            console.error('Error loading schedules:', error);
                            this.schedules = [];
                        }
                    },

                    // Load seats for selected schedule
                    async loadSeats() {
                        if (!this.selectedScheduleId) {
                            alert('Silakan pilih jadwal terlebih dahulu');
                            return;
                        }

                        try {
                            this.loading = true;
                            const response = await fetch(`api/seats?scheduleId=` + this.selectedScheduleId);
                            this.seats = await response.json();
                            this.showSeatSelection = true;
                        } catch (error) {
                            console.error('Error loading seats:', error);
                            alert('Gagal memuat data kursi');
                        } finally {
                            this.loading = false;
                        }
                    },

                    // Toggle seat selection
                    toggleSeat(row, seatNumber) {
                        console.log('toggleSeat called with row:', row, 'seatNumber:', seatNumber);

                        const rowIndex = this.seats.findIndex(r => r.row === row);
                        if (rowIndex === -1) {
                            console.error('Row not found:', row);
                            return;
                        }

                        const seat = this.seats[rowIndex].seats.find(s => s.number === seatNumber);
                        if (!seat) {
                            console.error('Seat not found:', seatNumber, 'in row', row);
                            console.log('Available seats in row:', this.seats[rowIndex].seats);
                            return;
                        }

                        if (seat.status === 'occupied') return;

                        const seatCode = row + seatNumber;
                        console.log('Generated seatCode:', seatCode, 'from row:', row, 'seatNumber:', seatNumber);
                        console.log('Type of row:', typeof row, 'Type of seatNumber:', typeof seatNumber);

                        if (seat.status === 'available') {
                            seat.status = 'selected';
                            this.selectedSeats.push(seatCode);
                            this.selectedSeatIds.push(seat.seatId);
                            console.log('Seat selected:', seatCode, 'Total selected:', this.selectedSeats);
                        } else if (seat.status === 'selected') {
                            seat.status = 'available';
                            this.selectedSeats = this.selectedSeats.filter(s => s !== seatCode);
                            this.selectedSeatIds = this.selectedSeatIds.filter(id => id !== seat.seatId);
                            console.log('Seat deselected:', seatCode, 'Total selected:', this.selectedSeats);
                        }
                    },

                    // Book tickets - show payment modal
                    async bookTickets() {
                        // Check if user is logged in
                        if (!this.currentUser) {
                            this.showLoginModal = true;
                            return;
                        }

                        if (this.selectedSeatIds.length === 0) {
                            alert('Silakan pilih kursi terlebih dahulu');
                            return;
                        }

                        // Show payment modal
                        this.showPaymentModal = true;
                        this.paymentStatus = 'pending';
                        this.paymentCountdown = 10;

                        // Start countdown
                        this.startPaymentCountdown();
                    },

                    // Start payment countdown
                    startPaymentCountdown() {
                        const interval = setInterval(() => {
                            this.paymentCountdown--;

                            if (this.paymentCountdown === 5) {
                                this.paymentStatus = 'processing';
                            }

                            if (this.paymentCountdown <= 0) {
                                clearInterval(interval);
                                this.processPayment();
                            }
                        }, 1000);
                    },

                    // Process payment and save to database
                    async processPayment() {
                        try {
                            // CRITICAL VALIDATION: Ensure schedule matches selected movie
                            if (this.selectedMovieId && this.selectedScheduleId) {
                                const selectedSchedule = this.schedules.find(s => s.scheduleId === this.selectedScheduleId);
                                if (selectedSchedule) {
                                    if (selectedSchedule.movieId !== this.selectedMovieId) {
                                        console.error('❌ CRITICAL: Schedule does not match selected movie!');
                                        console.error('Selected Movie ID:', this.selectedMovieId);
                                        console.error('Selected Movie:', this.selectedMovie.title);
                                        console.error('Schedule Movie ID:', selectedSchedule.movieId);
                                        console.error('Schedule Movie:', selectedSchedule.movieTitle);
                                        alert('Error: Jadwal tidak sesuai dengan film yang dipilih!\nFilm: ' + this.selectedMovie.title + '\nJadwal untuk: ' + selectedSchedule.movieTitle);
                                        return;
                                    }
                                    console.log('✅ Validation passed: Schedule matches movie');
                                    console.log('Movie:', this.selectedMovie.title, '(ID:', this.selectedMovieId + ')');
                                    console.log('Schedule:', selectedSchedule.movieTitle, '(ID:', selectedSchedule.movieId + ')');
                                }
                            }

                            this.loading = true;
                            this.paymentStatus = 'processing';

                            const bookingData = {
                                userId: this.currentUser.userId,
                                scheduleId: this.selectedScheduleId,
                                customerName: this.currentUser.fullName || this.currentUser.username,
                                customerEmail: this.currentUser.email,
                                customerPhone: this.currentUser.phone || '',
                                seatIds: this.selectedSeatIds
                            };

                            console.log('Sending booking data:', bookingData);

                            const response = await fetch('api/bookings', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json'
                                },
                                body: JSON.stringify(bookingData)
                            });

                            console.log('Response status:', response.status);
                            const result = await response.json();
                            console.log('Response data:', result);

                            if (result.success) {
                                this.paymentStatus = 'success';
                                this.bookingCode = result.bookingCode;

                                // Wait a bit then show success modal
                                setTimeout(() => {
                                    this.showPaymentModal = false;
                                    this.showSuccess = true;
                                }, 2000);
                            } else {
                                this.paymentStatus = 'pending';
                                alert('Booking gagal: ' + (result.error || 'Unknown error'));
                                this.showPaymentModal = false;
                            }
                        } catch (error) {
                            console.error('Error booking tickets:', error);
                            this.paymentStatus = 'pending';
                            alert('Terjadi kesalahan saat booking. Silakan coba lagi.');
                            this.showPaymentModal = false;
                        } finally {
                            this.loading = false;
                        }
                    },

                    // Reset booking state
                    resetBooking() {
                        this.showSeatSelection = false;
                        this.selectedSeats = [];
                        this.selectedSeatIds = [];
                        this.customerName = '';
                        this.customerEmail = '';
                        this.customerPhone = '';
                        this.bookingCode = '';
                        this.seats = [];
                    },

                    // Get total price
                    getTotalPrice() {
                        return this.selectedSeats.length * this.currentPrice;
                    },

                    // Format price to Indonesian Rupiah
                    formatPrice(price) {
                        return 'Rp ' + price.toLocaleString('id-ID');
                    },

                    // Open trailer modal
                    openTrailer(movie) {
                        console.log('Opening trailer for:', movie.title);
                        console.log('Trailer URL:', movie.trailerUrl);

                        if (!movie.trailerUrl || movie.trailerUrl.trim() === '') {
                            alert('Trailer tidak tersedia untuk film ini');
                            return;
                        }

                        this.selectedMovie = movie;
                        this.trailerEmbedUrl = this.getYouTubeEmbedUrl(movie.trailerUrl);

                        console.log('Embed URL:', this.trailerEmbedUrl);

                        if (!this.trailerEmbedUrl) {
                            alert('Format URL trailer tidak valid. Gunakan link YouTube.');
                            return;
                        }

                        this.showTrailer = true;
                    },

                    // Close trailer modal
                    closeTrailer() {
                        this.showTrailer = false;
                        this.trailerEmbedUrl = '';
                    },

                    // Convert YouTube URL to embed URL
                    getYouTubeEmbedUrl(url) {
                        if (!url) return '';

                        console.log('Converting URL:', url);
                        let videoId = '';

                        // Extract YouTube video ID from various formats
                        if (url.includes('youtube.com/watch?v=')) {
                            videoId = url.split('v=')[1]?.split('&')[0];
                        } else if (url.includes('youtu.be/')) {
                            videoId = url.split('youtu.be/')[1]?.split('?')[0];
                        } else if (url.includes('youtube.com/embed/')) {
                            videoId = url.split('embed/')[1]?.split('?')[0];
                        }

                        console.log('Extracted video ID:', videoId);

                        if (videoId) {
                            // Add parameters for better embed experience
                            return `https://www.youtube.com/embed/${videoId}?autoplay=1&rel=0&modestbranding=1`;
                        }

                        return '';
                    },

                    // ==================== AUTH FUNCTIONS ====================

                    // Check session - auto login if session exists
                    async checkSession() {
                        try {
                            const response = await fetch('api/auth?action=check');
                            const result = await response.json();

                            if (result.success && result.loggedIn) {
                                this.currentUser = result.user;
                                // Save to sessionStorage for profile page
                                sessionStorage.setItem('currentUser', JSON.stringify(result.user));
                            }
                        } catch (error) {
                            console.error('Error checking session:', error);
                        }
                    },

                    // Login
                    async login(formData) {
                        try {
                            this.loading = true;

                            const params = new URLSearchParams({
                                action: 'login',
                                username: formData.username,
                                password: formData.password
                            });

                            const response = await fetch('api/auth', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                },
                                body: params
                            });

                            const result = await response.json();

                            if (result.success) {
                                this.currentUser = result.user;
                                // Save to sessionStorage for profile page
                                sessionStorage.setItem('currentUser', JSON.stringify(result.user));
                                this.showLoginModal = false;
                                this.showToast('success', 'Login berhasil! Selamat datang ' + (result.user.fullName || result.user.username));
                            } else {
                                this.showToast('error', result.error || 'Login gagal');
                            }

                            return result.success;
                        } catch (error) {
                            console.error('Error logging in:', error);
                            alert('Terjadi kesalahan saat login');
                            return false;
                        } finally {
                            this.loading = false;
                        }
                    },

                    // Register
                    async register(formData) {
                        try {
                            this.loading = true;

                            const params = new URLSearchParams({
                                action: 'register',
                                username: formData.username,
                                email: formData.email,
                                password: formData.password,
                                fullName: formData.fullName,
                                phone: formData.phone
                            });

                            const response = await fetch('api/auth', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                },
                                body: params
                            });

                            const result = await response.json();

                            if (result.success) {
                                this.currentUser = result.user;
                                // Save to sessionStorage for profile page
                                sessionStorage.setItem('currentUser', JSON.stringify(result.user));
                                this.showLoginModal = false;
                                this.showToast('success', 'Registrasi berhasil! Selamat datang ' + (result.user.fullName || result.user.username));
                            } else {
                                this.showToast('error', result.error || 'Registrasi gagal');
                            }

                            return result.success;
                        } catch (error) {
                            console.error('Error registering:', error);
                            this.showToast('error', 'Terjadi kesalahan saat registrasi');
                            return false;
                        } finally {
                            this.loading = false;
                        }
                    },

                    // Logout
                    async logout() {

                        try {
                            const response = await fetch('api/auth?action=logout', {
                                method: 'POST'
                            });

                            const result = await response.json();

                            if (result.success) {
                                this.currentUser = null;
                                // Remove from sessionStorage
                                sessionStorage.removeItem('currentUser');
                                this.showToast('success', 'Logout berhasil');

                                // Reset any active booking
                                this.resetBooking();
                                this.selectedMovie = null;
                            }
                        } catch (error) {
                            console.error('Error logging out:', error);
                            this.showToast('error', 'Terjadi kesalahan saat logout');
                        }
                    },

                    // Toast notification
                    showToast(type, message) {
                        this.toast.type = type;
                        this.toast.message = message;
                        this.toast.show = true;

                        // Auto hide after 3 seconds
                        setTimeout(() => {
                            this.toast.show = false;
                        }, 3000);
                    }
                }
            }
        </script>
    </body>

    </html>