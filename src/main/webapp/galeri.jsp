<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="id" class="scroll-smooth">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Galeri - CineGO</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
        <style>
            .gallery-item {
                transition: all 0.3s ease;
            }

            .gallery-item:hover {
                transform: translateY(-8px);
            }

            .gallery-overlay {
                transition: opacity 0.3s ease;
            }

            .gallery-item:hover .gallery-overlay {
                opacity: 1;
            }
        </style>
    </head>

    <body class="bg-slate-950 text-white" x-data="galleryApp()">

        <!-- Include Navbar -->
        <jsp:include page="component/navbar.jsp" />

        <!-- Hero Section -->
        <section class="pt-32 pb-20 relative overflow-hidden">
            <div class="absolute inset-0 bg-gradient-to-b from-red-900/20 to-transparent"></div>
            <div class="container mx-auto px-4 lg:px-8 relative z-10">
                <div class="text-center max-w-4xl mx-auto">
                    <h1
                        class="text-5xl md:text-6xl font-bold mb-6 bg-gradient-to-r from-red-500 to-red-700 bg-clip-text text-transparent">
                        Galeri CineGO
                    </h1>
                    
                </div>
            </div>
        </section>

    
        <!-- Gallery Grid -->
        <section class="py-20">
            <div class="container mx-auto px-4 lg:px-8">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <template x-for="item in filteredGallery" :key="item.id">
                        <div class="gallery-item group cursor-pointer" @click="openLightbox(item)">
                            <div class="relative overflow-hidden rounded-2xl bg-slate-900 border border-slate-800">
                                <div class="aspect-[4/3] bg-gradient-to-br" :class="item.gradient">
                                    <div class="w-full h-full flex items-center justify-center">
                                        <i :class="item.icon" class="text-6xl opacity-50"></i>
                                    </div>
                                </div>
                                <div
                                    class="gallery-overlay absolute inset-0 bg-black/70 opacity-0 flex items-center justify-center">
                                    <div class="text-center p-6">
                                        <i class="fas fa-search-plus text-4xl mb-3 text-red-500"></i>
                                        <p class="text-lg font-semibold" x-text="item.title"></p>
                                    </div>
                                </div>
                                <div
                                    class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/80 to-transparent p-4">
                                    <h3 class="font-bold text-lg" x-text="item.title"></h3>
                                    <p class="text-sm text-gray-300" x-text="item.description"></p>
                                </div>
                            </div>
                        </div>
                    </template>
                </div>

                <!-- Empty State -->
                <div x-show="filteredGallery.length === 0" class="text-center py-20">
                    <i class="fas fa-images text-6xl text-gray-600 mb-4"></i>
                    <p class="text-xl text-gray-400">Tidak ada gambar dalam kategori ini</p>
                </div>
            </div>
        </section>

        <!-- Lightbox Modal -->
        <div x-show="lightboxOpen" x-transition @click="closeLightbox()"
            class="fixed inset-0 bg-black/95 z-50 flex items-center justify-center p-4" style="display: none;">
            <div class="relative max-w-3xl w-full" @click.stop>
                <button @click="closeLightbox()"
                    class="absolute -top-12 right-0 text-white hover:text-red-500 transition">
                    <i class="fas fa-times text-3xl"></i>
                </button>

                <template x-if="selectedItem">
                    <div class="bg-slate-900 rounded-2xl overflow-hidden">
                        <div class="aspect-video bg-gradient-to-br" :class="selectedItem.gradient">
                            <div class="w-full h-full flex items-center justify-center">
                                <i :class="selectedItem.icon" class="text-9xl opacity-50"></i>
                            </div>
                        </div>
                        <div class="p-6">
                            <h2 class="text-2xl font-bold mb-2" x-text="selectedItem.title"></h2>
                            <p class="text-gray-300 mb-4" x-text="selectedItem.description"></p>
                            <div class="flex items-center text-sm text-gray-400">
                                <i class="fas fa-tag mr-2"></i>
                                <span x-text="getCategoryName(selectedItem.category)"></span>
                            </div>
                        </div>
                    </div>
                </template>
            </div>
        </div>

        <!-- Footer -->
        <footer class="bg-slate-900 border-t border-slate-800 py-12">
            <div class="container mx-auto px-4 lg:px-8">
                <div class="flex flex-col md:flex-row justify-between items-center">
                    <div class="flex items-center space-x-2 mb-4 md:mb-0">
                        <div class="bg-gradient-to-br from-red-500 to-red-700 p-2 rounded-lg">
                            <i class="fas fa-film text-2xl"></i>
                        </div>
                        <span
                            class="text-2xl font-bold bg-gradient-to-r from-red-500 to-red-700 bg-clip-text text-transparent">
                            CineGO
                        </span>
                    </div>
                    <div class="text-gray-400">
                        <p>&copy; 2025 CineGO. All rights reserved.</p>
                    </div>
                </div>
            </div>
        </footer>

        <script>
            function galleryApp() {
                return {
                    currentFilter: 'all',
                    lightboxOpen: false,
                    selectedItem: null,
                    gallery: [
                        {
                            id: 1,
                            title: 'Studio Premium',
                            description: 'Ruang teater dengan teknologi audio visual terkini',
                            category: 'cinema',
                            gradient: 'from-purple-600 to-purple-900',
                            icon: 'fas fa-tv'
                        },
                        {
                            id: 2,
                            title: 'Lobby Modern',
                            description: 'Area tunggu yang nyaman dan elegan',
                            category: 'cinema',
                            gradient: 'from-blue-600 to-blue-900',
                            icon: 'fas fa-couch'
                        },
                        {
                            id: 3,
                            title: 'Concession Stand',
                            description: 'Beragam pilihan makanan dan minuman',
                            category: 'cinema',
                            gradient: 'from-yellow-600 to-yellow-900',
                            icon: 'fas fa-shopping-basket'
                        },
                        {
                            id: 4,
                            title: 'Film Action Terbaru',
                            description: 'Koleksi film action terpopuler',
                            category: 'movies',
                            gradient: 'from-red-600 to-red-900',
                            icon: 'fas fa-fire'
                        },
                        {
                            id: 5,
                            title: 'Film Drama',
                            description: 'Film drama yang menyentuh hati',
                            category: 'movies',
                            gradient: 'from-indigo-600 to-indigo-900',
                            icon: 'fas fa-heart'
                        },
                        {
                            id: 6,
                            title: 'Film Horor',
                            description: 'Pengalaman mendebarkan di layar lebar',
                            category: 'movies',
                            gradient: 'from-gray-700 to-gray-900',
                            icon: 'fas fa-ghost'
                        },
                        {
                            id: 7,
                            title: 'Premiere Night',
                            description: 'Malam premiere film blockbuster',
                            category: 'events',
                            gradient: 'from-pink-600 to-pink-900',
                            icon: 'fas fa-star'
                        },
                        {
                            id: 8,
                            title: 'Meet & Greet',
                            description: 'Bertemu langsung dengan bintang film',
                            category: 'events',
                            gradient: 'from-green-600 to-green-900',
                            icon: 'fas fa-users'
                        },
                        {
                            id: 9,
                            title: 'Film Festival',
                            description: 'Festival film tahunan CineGO',
                            category: 'events',
                            gradient: 'from-orange-600 to-orange-900',
                            icon: 'fas fa-trophy'
                        },
                        {
                            id: 10,
                            title: 'IMAX Theater',
                            description: 'Pengalaman sinema dengan teknologi IMAX',
                            category: 'cinema',
                            gradient: 'from-teal-600 to-teal-900',
                            icon: 'fas fa-film'
                        },
                        {
                            id: 11,
                            title: 'VIP Lounge',
                            description: 'Ruang eksklusif untuk pengalaman premium',
                            category: 'cinema',
                            gradient: 'from-amber-600 to-amber-900',
                            icon: 'fas fa-crown'
                        },
                        {
                            id: 12,
                            title: 'Film Komedi',
                            description: 'Tawa lepas bersama film komedi terbaik',
                            category: 'movies',
                            gradient: 'from-lime-600 to-lime-900',
                            icon: 'fas fa-laugh'
                        }
                    ],

                    get filteredGallery() {
                        if (this.currentFilter === 'all') {
                            return this.gallery;
                        }
                        return this.gallery.filter(item => item.category === this.currentFilter);
                    },

                    filterGallery(category) {
                        this.currentFilter = category;
                    },

                    openLightbox(item) {
                        this.selectedItem = item;
                        this.lightboxOpen = true;
                        document.body.style.overflow = 'hidden';
                    },

                    closeLightbox() {
                        this.lightboxOpen = false;
                        this.selectedItem = null;
                        document.body.style.overflow = 'auto';
                    },

                    getCategoryName(category) {
                        const categories = {
                            'cinema': 'Interior Bioskop',
                            'movies': 'Film',
                            'events': 'Event'
                        };
                        return categories[category] || category;
                    }
                }
            }
        </script>

    </body>

    </html>