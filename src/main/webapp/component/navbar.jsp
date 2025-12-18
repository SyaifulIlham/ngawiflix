<nav class="fixed top-0 left-0 right-0 z-50 transition-all duration-300"
         :class="scrolled ? 'bg-slate-950/95 backdrop-blur-md shadow-lg' : 'bg-transparent'"
         x-data="{ scrolled: false }"
         @scroll.window="scrolled = window.pageYOffset > 50">
        <div class="container mx-auto px-4 lg:px-8">
            <div class="flex items-center justify-between h-20">
                <!-- Logo -->
                <div class="flex items-center space-x-2">
                    <div class="bg-gradient-to-br from-red-500 to-red-700 p-2 rounded-lg">
                        <i class="fas fa-film text-2xl"></i>
                    </div>
                    <span class="text-2xl font-bold bg-gradient-to-r from-red-500 to-red-700 bg-clip-text text-transparent">
                        AnjayNobar
                    </span>
                </div>
                
                <!-- Desktop Menu -->
                <div class="hidden md:flex items-center space-x-8">
                    <a href="#home" class="hover:text-red-500 transition">Beranda</a>
                    <a href="#movies" class="hover:text-red-500 transition">Film</a>
                    <a href="#schedule" class="hover:text-red-500 transition">Jadwal</a>
                    <a href="#promo" class="hover:text-red-500 transition">Promo</a>
                </div>
                
                <!-- Right Menu -->
                <div class="flex items-center space-x-4">
                    <button @click="showSearch = !showSearch" class="hover:text-red-500 transition">
                        <i class="fas fa-search text-xl"></i>
                    </button>
                    
                    <!-- User Menu - Show when logged in -->
                    <div x-show="currentUser" class="hidden md:block relative" x-data="{ userMenu: false }">
                        <button @click="userMenu = !userMenu" 
                                class="flex items-center space-x-2 px-4 py-2 bg-slate-800 rounded-lg hover:bg-slate-700 transition">
                            <i class="fas fa-user-circle text-xl"></i>
                            <span x-text="currentUser?.fullName || currentUser?.username"></span>
                            <i class="fas fa-chevron-down text-xs"></i>
                        </button>
                        
                        <!-- Dropdown Menu -->
                        <div x-show="userMenu" 
                             @click.away="userMenu = false"
                             x-transition
                             class="absolute right-0 mt-2 w-48 bg-slate-800 rounded-lg shadow-xl py-2 z-50">
                            <div class="px-4 py-2 border-b border-slate-700">
                                <p class="text-sm text-gray-400">Login sebagai</p>
                                <p class="font-semibold" x-text="currentUser?.username"></p>
                                <p class="text-xs text-red-500 uppercase" x-text="currentUser?.role"></p>
                            </div>
                            
                            <!-- Admin Menu -->
                            <template x-if="currentUser?.role === 'admin'">
                                <div class="border-b border-slate-700">
                                    <a href="admin/movies.jsp" 
                                       class="block px-4 py-2 hover:bg-slate-700 transition">
                                        <i class="fas fa-cog mr-2"></i> Panel Admin
                                    </a>
                                </div>
                            </template>
                            
                            <a href="my-tickets.jsp"
                               class="block px-4 py-2 hover:bg-slate-700 transition">
                                <i class="fas fa-ticket-alt mr-2"></i> Tiket Saya
                            </a>
                            <a href="#" @click.prevent="logout(); userMenu = false" 
                               class="block px-4 py-2 hover:bg-slate-700 transition text-red-500">
                                <i class="fas fa-sign-out-alt mr-2"></i> Keluar
                            </a>
                        </div>
                    </div>
                    
                    <!-- Login Button - Show when not logged in -->
                    <button x-show="!currentUser" 
                            @click="showLoginModal = true"
                            class="hidden md:block px-6 py-2 bg-gradient-to-r from-red-500 to-red-700 rounded-lg hover:from-red-600 hover:to-red-800 transition">
                        <i class="fas fa-user mr-2"></i>Masuk
                    </button>
                    
                    <!-- Mobile Menu Button -->
                    <button @click="mobileMenu = !mobileMenu" class="md:hidden">
                        <i class="fas" :class="mobileMenu ? 'fa-times' : 'fa-bars'" class="text-xl"></i>
                    </button>
                </div>
            </div>
            
            <!-- Search Bar -->
            <div x-show="showSearch" 
                 x-transition
                 class="pb-4">
                <input type="text" 
                       x-model="searchQuery"
                       @input="filterMovies()"
                       placeholder="Cari film favorit Anda..." 
                       class="w-full px-6 py-3 bg-slate-900 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500">
            </div>
        </div>
        
        <!-- Mobile Menu -->
        <div x-show="mobileMenu" 
             x-transition
             class="md:hidden bg-slate-900 border-t border-slate-800">
            <div class="container mx-auto px-4 py-4 space-y-3">
                <a href="#home" class="block py-2 hover:text-red-500 transition">Beranda</a>
                <a href="#movies" class="block py-2 hover:text-red-500 transition">Film</a>
                <a href="#schedule" class="block py-2 hover:text-red-500 transition">Jadwal</a>
                <a href="#promo" class="block py-2 hover:text-red-500 transition">Promo</a>
                <button class="w-full px-6 py-2 bg-gradient-to-r from-red-500 to-red-700 rounded-lg">
                    <i class="fas fa-user mr-2"></i>Masuk
                </button>
            </div>
        </div>
    </nav>