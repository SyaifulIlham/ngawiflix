<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="id" class="scroll-smooth">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tentang Kami - CineGO</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
        <style>
            .team-card {
                position: relative;
                background: linear-gradient(145deg, #1e293b, #0f172a);
                border-radius: 1rem;
                padding: 2rem;
                transition: all 0.3s ease;
            }

            .team-card::before {
                content: '';
                position: absolute;
                inset: -2px;
                border-radius: 1rem;
                padding: 2px;
                background: linear-gradient(145deg, var(--glow-color), transparent);
                -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
                -webkit-mask-composite: xor;
                mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
                mask-composite: exclude;
                opacity: 0.8;
            }

            .team-card:hover::before {
                opacity: 1;
                box-shadow: 0 0 30px var(--glow-color);
            }

            .team-card-red {
                --glow-color: #ef4444;
            }

            .team-card-blue {
                --glow-color: #3b82f6;
            }

            .team-card-purple {
                --glow-color: #a855f7;
            }

            .team-card-green {
                --glow-color: #10b981;
            }

            .team-card:hover {
                transform: translateY(-5px);
            }
        </style>
    </head>

    <body class="bg-slate-950 text-white" x-data="{ mobileMenu: false, showSearch: false }">

        <!-- Include Navbar -->
        <jsp:include page="component/navbar.jsp" />

        <!-- Hero Section -->
        <section class="pt-32 pb-20 relative overflow-hidden">
            <div class="absolute inset-0 bg-gradient-to-b from-red-900/20 to-transparent"></div>
            <div class="container mx-auto px-4 lg:px-8 relative z-10">
                <div class="text-center max-w-4xl mx-auto">
                    <h1
                        class="text-5xl md:text-6xl font-bold mb-6 bg-gradient-to-r from-red-500 to-red-700 bg-clip-text text-transparent">
                        Tentang CineGO
                    </h1>
                    <p class="text-xl text-gray-300 leading-relaxed">
                        Platform pemesanan tiket bioskop modern yang menghadirkan pengalaman menonton yang lebih mudah
                        dan menyenangkan
                    </p>
                </div>
            </div>
        </section>

        <!-- About Application Section -->
        <section class="py-20 bg-slate-900/50">
            <div class="container mx-auto px-4 lg:px-8">
                <div class="max-w-4xl mx-auto">
                    <div class="bg-slate-900 rounded-2xl p-8 md:p-12 shadow-2xl border border-slate-800">
                        <div class="flex items-center mb-6">
                            <div class="bg-gradient-to-br from-red-500 to-red-700 p-4 rounded-xl mr-4">
                                <i class="fas fa-film text-3xl"></i>
                            </div>
                            <h2 class="text-3xl font-bold">Tentang Aplikasi</h2>
                        </div>

                        <div class="space-y-6 text-gray-300 text-lg leading-relaxed">
                            <p>
                                <strong class="text-white">CineGO</strong> adalah aplikasi pemesanan tiket bioskop yang
                                dirancang untuk memberikan
                                kemudahan dan kenyamanan dalam memesan tiket film favorit Anda. Dengan antarmuka yang
                                modern dan user-friendly,
                                kami menghadirkan pengalaman booking yang cepat dan efisien.
                            </p>

                            <div class="grid md:grid-cols-2 gap-6 my-8">
                                <div class="bg-slate-800 p-6 rounded-xl">
                                    <div class="flex items-center mb-3">
                                        <i class="fas fa-rocket text-red-500 text-2xl mr-3"></i>
                                        <h3 class="text-xl font-semibold text-white">Misi Kami</h3>
                                    </div>
                                    <p class="text-gray-400">
                                        Menyediakan platform booking tiket bioskop yang mudah, cepat, dan terpercaya
                                        untuk semua kalangan.
                                    </p>
                                </div>

                                <div class="bg-slate-800 p-6 rounded-xl">
                                    <div class="flex items-center mb-3">
                                        <i class="fas fa-eye text-red-500 text-2xl mr-3"></i>
                                        <h3 class="text-xl font-semibold text-white">Visi Kami</h3>
                                    </div>
                                    <p class="text-gray-400">
                                        Menjadi platform pemesanan tiket bioskop #1 yang dipercaya di Indonesia.
                                    </p>
                                </div>
                            </div>

                            <h3 class="text-2xl font-semibold text-white mt-8 mb-4">Fitur Unggulan</h3>
                            <div class="grid md:grid-cols-3 gap-4">
                                <div class="bg-slate-800 p-5 rounded-lg text-center">
                                    <i class="fas fa-mobile-alt text-red-500 text-3xl mb-3"></i>
                                    <h4 class="font-semibold text-white mb-2">Responsif</h4>
                                    <p class="text-sm text-gray-400">Akses dari perangkat apapun</p>
                                </div>

                                <div class="bg-slate-800 p-5 rounded-lg text-center">
                                    <i class="fas fa-bolt text-red-500 text-3xl mb-3"></i>
                                    <h4 class="font-semibold text-white mb-2">Cepat</h4>
                                    <p class="text-sm text-gray-400">Proses booking dalam hitungan detik</p>
                                </div>

                                <div class="bg-slate-800 p-5 rounded-lg text-center">
                                    <i class="fas fa-shield-alt text-red-500 text-3xl mb-3"></i>
                                    <h4 class="font-semibold text-white mb-2">Aman</h4>
                                    <p class="text-sm text-gray-400">Transaksi terjamin keamanannya</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Team Section -->
        <section class="py-20">
            <div class="container mx-auto px-4 lg:px-8">
                <div class="text-center mb-16">
                    <h2 class="text-4xl font-bold mb-4">Tim Kami</h2>
                    <p class="text-gray-400 text-lg">Orang-orang hebat di balik CineGO</p>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 max-w-5xl mx-auto">
                    <!-- Team Member 1 - Raffa Yuda Pratama -->
                    <div class="team-card team-card-red text-center">
                        <div class="relative inline-block mb-4">
                            <div
                                class="w-28 h-28 rounded-lg bg-gradient-to-br from-red-500 to-red-900 flex items-center justify-center text-4xl font-bold mx-auto">
                                <img src="./assets/raffa.png" class="w-[95%] h-[95%] object-cover rounded-lg" alt="Raffa Yuda Pratama">
                            </div>
                        </div>
                        <h3 class="text-xl font-bold mb-2">Raffa Yuda Pratama</h3>
                        <p class="text-red-500 font-semibold mb-3">0110224081</p>
                        <p class="text-gray-400 text-sm mb-4">Membuat dan mengembangkan website</p>
                        <div class="flex justify-center space-x-3">
                            <a href="#"
                                class="w-8 h-8 bg-slate-800 rounded-full flex items-center justify-center hover:bg-red-500 transition">
                                <i class="fas fa-envelope text-sm"></i>
                            </a>
                            <a href="#"
                                class="w-8 h-8 bg-slate-800 rounded-full flex items-center justify-center hover:bg-red-500 transition">
                                <i class="fab fa-linkedin text-sm"></i>
                            </a>
                        </div>
                    </div>

                    <!-- Team Member 2 - Ahmad Hamizan -->
                    <div class="team-card team-card-blue text-center">
                        <div class="relative inline-block mb-4">
                            <div
                                class="w-28 h-28 rounded-lg bg-gradient-to-br from-blue-500 to-blue-900 flex items-center justify-center text-4xl font-bold mx-auto">
                                <img src="./assets/hamizan.jpeg" class="w-[95%] h-[95%] object-cover rounded-lg" alt="Ahmad Hamizan">
                            </div>
                        </div>
                        <h3 class="text-xl font-bold mb-2">Ahmad Hamizan</h3>
                        <p class="text-blue-500 font-semibold mb-3">0110224163</p>
                        <p class="text-gray-400 text-sm mb-4">Mengerjakan Laporan</p>
                        <div class="flex justify-center space-x-3">
                            <a href="#"
                                class="w-8 h-8 bg-slate-800 rounded-full flex items-center justify-center hover:bg-blue-500 transition">
                                <i class="fas fa-envelope text-sm"></i>
                            </a>
                            <a href="#"
                                class="w-8 h-8 bg-slate-800 rounded-full flex items-center justify-center hover:bg-blue-500 transition">
                                <i class="fab fa-linkedin text-sm"></i>
                            </a>
                        </div>
                    </div>

                    <!-- Team Member 3 - Wahyu Ahmad Yassin -->
                    <div class="team-card team-card-purple text-center">
                        <div class="relative inline-block mb-4">
                            <div
                                class="w-28 h-28 rounded-lg bg-gradient-to-br from-purple-500 to-purple-900 flex items-center justify-center text-4xl font-bold mx-auto">
                                <img src="./assets/wahyu.jpeg" class="w-[95%] h-[95%] object-cover rounded-lg" alt="Wahyu Ahmad Yassin">
                            </div>
                        </div>
                        <h3 class="text-xl font-bold mb-2">Wahyu Ahmad Yassin</h3>
                        <p class="text-purple-500 font-semibold mb-3">0110224047</p>
                        <p class="text-gray-400 text-sm mb-4">Mengerjakan Laporan</p>
                        <div class="flex justify-center space-x-3">
                            <a href="#"
                                class="w-8 h-8 bg-slate-800 rounded-full flex items-center justify-center hover:bg-purple-500 transition">
                                <i class="fas fa-envelope text-sm"></i>
                            </a>
                            <a href="#"
                                class="w-8 h-8 bg-slate-800 rounded-full flex items-center justify-center hover:bg-purple-500 transition">
                                <i class="fab fa-linkedin text-sm"></i>
                            </a>
                        </div>
                    </div>

                    <!-- Team Member 4 - Syaiful Ilham -->
                    <div class="team-card team-card-green text-center">
                        <div class="relative inline-block mb-4">
                            <div
                                class="w-28 h-28 rounded-lg bg-gradient-to-br from-green-500 to-green-900 flex items-center justify-center text-4xl font-bold mx-auto">
                                <img src="./assets/ipul.jpeg" class="w-[95%] h-[95%] object-cover rounded-lg" alt="Syaiful Ilham">
                            </div>
                        </div>
                        <h3 class="text-xl font-bold mb-2">Syaiful Ilham</h3>
                        <p class="text-green-500 font-semibold mb-3">0110224084</p>
                        <p class="text-gray-400 text-sm mb-4">Mengerjakan Laporan</p>
                        <div class="flex justify-center space-x-3">
                            <a href="#"
                                class="w-8 h-8 bg-slate-800 rounded-full flex items-center justify-center hover:bg-green-500 transition">
                                <i class="fas fa-envelope text-sm"></i>
                            </a>
                            <a href="#"
                                class="w-8 h-8 bg-slate-800 rounded-full flex items-center justify-center hover:bg-green-500 transition">
                                <i class="fab fa-linkedin text-sm"></i>
                            </a>
                        </div>
                    </div>

                    <!-- Team Member 5 - Zahra Aulia Rahmani -->
                    <div class="team-card team-card-green text-center">
                        <div class="relative inline-block mb-4">
                            <div
                                class="w-28 h-28 rounded-lg bg-gradient-to-br from-green-500 to-green-900 flex items-center justify-center text-4xl font-bold mx-auto">
                                <img src="./assets/zahra2.jpeg" class="w-[95%] h-[95%] object-cover rounded-lg" alt="Zahra Aulia Rahmani">
                            </div>
                        </div>
                        <h3 class="text-xl font-bold mb-2">Zahra Aulia Rahmani</h3>
                        <p class="text-green-500 font-semibold mb-3">0110224193</p>
                        <p class="text-gray-400 text-sm mb-4">Mengerjakan Laporan</p>
                        <div class="flex justify-center space-x-3">
                            <a href="#"
                                class="w-8 h-8 bg-slate-800 rounded-full flex items-center justify-center hover:bg-green-500 transition">
                                <i class="fas fa-envelope text-sm"></i>
                            </a>
                            <a href="#"
                                class="w-8 h-8 bg-slate-800 rounded-full flex items-center justify-center hover:bg-green-500 transition">
                                <i class="fab fa-linkedin text-sm"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

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

    </body>

    </html>