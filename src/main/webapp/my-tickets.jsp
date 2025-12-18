<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tiket Saya - AnjayNobar</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- PDF Generation -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <!-- QR Code Generation -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <style>
        [x-cloak] { display: none !important; }
        
        body {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            min-height: 100vh;
            color: white;
        }
        
        .ticket-card {
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            transition: all 0.3s ease;
        }
        
        .ticket-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 30px rgba(239, 68, 68, 0.3);
        }
        
        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .status-confirmed {
            background: #10b981;
            color: white;
        }
        
        .status-cancelled {
            background: #ef4444;
            color: white;
        }
        
        .status-pending {
            background: #f59e0b;
            color: white;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #b91c1c 0%, #991b1b 100%);
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(220, 38, 38, 0.4);
        }
        
        .empty-state {
            min-height: 60vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>
</head>
<body>
    <div x-data="ticketsApp()" x-init="init()">
        <!-- Navbar -->
        <nav class="bg-slate-900/80 backdrop-blur-md sticky top-0 z-40 border-b border-slate-800">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between items-center h-16">
                    <!-- Logo -->
                    <a href="index.jsp" class="flex items-center space-x-2">
                        <i class="fas fa-film text-3xl text-red-600"></i>
                        <span class="text-2xl font-bold">Anjay<span class="text-red-600">Nobar</span></span>
                    </a>
                    
                    <!-- User Menu -->
                    <div class="flex items-center space-x-4">
                        <template x-if="currentUser">
                            <div class="relative" x-data="{ open: false }">
                                <button @click="open = !open" 
                                        class="flex items-center space-x-2 bg-slate-800 px-4 py-2 rounded-lg hover:bg-slate-700 transition">
                                    <i class="fas fa-user-circle text-xl"></i>
                                    <span x-text="currentUser.username"></span>
                                    <i class="fas fa-chevron-down text-sm"></i>
                                </button>
                                
                                <div x-show="open" 
                                     @click.away="open = false"
                                     x-cloak
                                     x-transition
                                     class="absolute right-0 mt-2 w-48 bg-slate-800 rounded-lg shadow-xl py-2 border border-slate-700">
                                    <div class="px-4 py-2 border-b border-slate-700">
                                        <p class="text-sm text-gray-400">Login sebagai</p>
                                        <p class="font-semibold" x-text="currentUser.role.toUpperCase()"></p>
                                    </div>
                                    
                                    <template x-if="currentUser.role === 'admin'">
                                        <a href="admin.jsp" class="block px-4 py-2 hover:bg-slate-700 transition">
                                            <i class="fas fa-cog mr-2"></i> Panel Admin
                                        </a>
                                    </template>
                                    
                                    <a href="index.jsp" class="block px-4 py-2 hover:bg-slate-700 transition">
                                        <i class="fas fa-home mr-2"></i> Beranda
                                    </a>
                                    
                                    <a href="my-tickets.jsp" class="block px-4 py-2 bg-slate-700">
                                        <i class="fas fa-ticket-alt mr-2"></i> Tiket Saya
                                    </a>
                                    
                                    <button @click="logout()" class="w-full text-left px-4 py-2 hover:bg-slate-700 transition text-red-500">
                                        <i class="fas fa-sign-out-alt mr-2"></i> Keluar
                                    </button>
                                </div>
                            </div>
                        </template>
                        
                        <template x-if="!currentUser">
                            <a href="index.jsp" class="px-6 py-2 btn-primary rounded-lg font-semibold">
                                <i class="fas fa-sign-in-alt mr-2"></i> Masuk
                            </a>
                        </template>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <!-- Header -->
            <div class="mb-8">
                <h1 class="text-4xl font-bold mb-2">
                    <i class="fas fa-ticket-alt text-red-600 mr-3"></i>
                    Tiket Saya
                </h1>
                <p class="text-gray-400">Riwayat pemesanan tiket Anda</p>
            </div>

            <!-- Loading State -->
            <div x-show="loading" class="text-center py-20">
                <div class="inline-block w-16 h-16 border-4 border-red-500 border-t-transparent rounded-full animate-spin"></div>
                <p class="mt-4 text-gray-400">Memuat tiket...</p>
            </div>

            <!-- Empty State -->
            <div x-show="!loading && tickets.length === 0" x-cloak class="empty-state">
                <div class="text-center">
                    <i class="fas fa-ticket-alt text-gray-600 text-6xl mb-4"></i>
                    <h3 class="text-2xl font-bold mb-2">Belum Ada Tiket</h3>
                    <p class="text-gray-400 mb-6">Anda belum memiliki riwayat pemesanan tiket</p>
                    <a href="index.jsp" class="inline-block px-8 py-3 btn-primary rounded-lg font-semibold">
                        <i class="fas fa-film mr-2"></i> Pesan Tiket Sekarang
                    </a>
                </div>
            </div>

            <!-- Tickets List -->
            <div x-show="!loading && tickets.length > 0" x-cloak class="grid gap-6">
                <template x-for="ticket in tickets" :key="ticket.bookingId">
                    <div class="ticket-card rounded-xl p-6 border border-slate-700">
                        <div class="flex flex-col md:flex-row md:items-center justify-between mb-4">
                            <div class="flex-1">
                                <div class="flex items-center gap-3 mb-2">
                                    <h3 class="text-2xl font-bold" x-text="ticket.movieTitle"></h3>
                                    <span class="status-badge" 
                                          :class="'status-' + ticket.bookingStatus"
                                          x-text="getStatusText(ticket.bookingStatus)"></span>
                                </div>
                                <p class="text-gray-400 text-sm">
                                    <i class="fas fa-calendar mr-2"></i>
                                    <span x-text="formatDate(ticket.createdAt)"></span>
                                </p>
                            </div>
                            
                            <div class="mt-4 md:mt-0 text-right">
                                <div class="bg-red-900/30 border border-red-600 rounded-lg px-4 py-2 inline-block">
                                    <p class="text-sm text-gray-400">Kode Booking</p>
                                    <p class="text-2xl font-bold text-red-500" x-text="ticket.bookingCode"></p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="grid md:grid-cols-3 gap-4 mb-4">
                            <div class="bg-slate-800/50 rounded-lg p-4">
                                <p class="text-sm text-gray-400 mb-1">
                                    <i class="fas fa-building mr-2"></i>Bioskop
                                </p>
                                <p class="font-semibold" x-text="ticket.theaterName || 'CinemaX'"></p>
                            </div>
                            
                            <div class="bg-slate-800/50 rounded-lg p-4">
                                <p class="text-sm text-gray-400 mb-1">
                                    <i class="fas fa-clock mr-2"></i>Waktu
                                </p>
                                <p class="font-semibold" x-text="ticket.showtime || '-'"></p>
                            </div>
                            
                            <div class="bg-slate-800/50 rounded-lg p-4">
                                <p class="text-sm text-gray-400 mb-1">
                                    <i class="fas fa-chair mr-2"></i>Kursi
                                </p>
                                <p class="font-semibold" x-text="ticket.seatCodes ? ticket.seatCodes.join(', ') : '-'"></p>
                            </div>
                        </div>
                        
                        <div class="flex flex-col md:flex-row md:items-center justify-between pt-4 border-t border-slate-700">
                            <div>
                                <p class="text-sm text-gray-400">Total Pembayaran</p>
                                <p class="text-2xl font-bold text-red-500" x-text="formatPrice(ticket.totalPrice)"></p>
                            </div>
                            
                            <div class="flex gap-2 mt-4 md:mt-0">
                                <button @click="viewDetail(ticket)" 
                                        class="px-4 py-2 bg-slate-700 hover:bg-slate-600 rounded-lg transition">
                                    <i class="fas fa-info-circle mr-2"></i>Detail
                                </button>
                                <button @click="downloadTicket(ticket)" 
                                        class="px-4 py-2 btn-primary rounded-lg">
                                    <i class="fas fa-download mr-2"></i>Unduh
                                </button>
                            </div>
                        </div>
                    </div>
                </template>
            </div>
        </div>

        <!-- Detail Modal -->
        <div x-show="showDetailModal" 
             x-cloak
             @click.self="showDetailModal = false"
             class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70"
             x-transition>
            <div class="bg-slate-900 rounded-2xl max-w-2xl w-full p-8"
                 @click.stop
                 x-transition:enter="transition ease-out duration-300"
                 x-transition:enter-start="opacity-0 transform scale-95"
                 x-transition:enter-end="opacity-100 transform scale-100">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="text-2xl font-bold">Detail Tiket</h3>
                    <button @click="showDetailModal = false" 
                            class="w-10 h-10 bg-slate-800 rounded-full hover:bg-slate-700 transition">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                
                <template x-if="selectedTicket">
                    <div>
                        <div class="bg-slate-800 rounded-lg p-6 mb-6">
                            <div class="text-center mb-4">
                                <div class="inline-block bg-white rounded-lg p-4 mb-3">
                                    <i class="fas fa-qrcode text-slate-900 text-6xl"></i>
                                </div>
                                <p class="text-3xl font-bold text-red-500" x-text="selectedTicket.bookingCode"></p>
                                <p class="text-sm text-gray-400 mt-1">Tunjukkan QR Code ini di loket</p>
                            </div>
                        </div>
                        
                        <div class="space-y-3">
                            <div class="flex justify-between py-2 border-b border-slate-700">
                                <span class="text-gray-400">Film</span>
                                <span class="font-semibold" x-text="selectedTicket.movieTitle"></span>
                            </div>
                            <div class="flex justify-between py-2 border-b border-slate-700">
                                <span class="text-gray-400">Nama Pemesan</span>
                                <span class="font-semibold" x-text="selectedTicket.customerName"></span>
                            </div>
                            <div class="flex justify-between py-2 border-b border-slate-700">
                                <span class="text-gray-400">Email</span>
                                <span class="font-semibold" x-text="selectedTicket.customerEmail"></span>
                            </div>
                            <div class="flex justify-between py-2 border-b border-slate-700">
                                <span class="text-gray-400">Telepon</span>
                                <span class="font-semibold" x-text="selectedTicket.customerPhone || '-'"></span>
                            </div>
                            <div class="flex justify-between py-2 border-b border-slate-700">
                                <span class="text-gray-400">Kursi</span>
                                <span class="font-semibold" x-text="selectedTicket.seatCodes ? selectedTicket.seatCodes.join(', ') : '-'"></span>
                            </div>
                            <div class="flex justify-between py-2 border-b border-slate-700">
                                <span class="text-gray-400">Jumlah Tiket</span>
                                <span class="font-semibold" x-text="selectedTicket.totalSeats + ' tiket'"></span>
                            </div>
                            <div class="flex justify-between py-2 border-b border-slate-700">
                                <span class="text-gray-400">Total Harga</span>
                                <span class="font-bold text-red-500 text-xl" x-text="formatPrice(selectedTicket.totalPrice)"></span>
                            </div>
                            <div class="flex justify-between py-2">
                                <span class="text-gray-400">Status</span>
                                <span class="status-badge" 
                                      :class="'status-' + selectedTicket.bookingStatus"
                                      x-text="getStatusText(selectedTicket.bookingStatus)"></span>
                            </div>
                        </div>
                    </div>
                </template>
            </div>
        </div>
    </div>

    <script>
        function ticketsApp() {
            return {
                currentUser: null,
                tickets: [],
                loading: false,
                showDetailModal: false,
                selectedTicket: null,
                
                async init() {
                    await this.checkSession();
                    if (this.currentUser) {
                        await this.loadTickets();
                    } else {
                        window.location.href = 'index.jsp';
                    }
                },
                
                async checkSession() {
                    try {
                        const response = await fetch('api/auth?action=check');
                        const result = await response.json();
                        if (result.loggedIn) {
                            this.currentUser = result.user;
                        }
                    } catch (error) {
                        console.error('Error checking session:', error);
                    }
                },
                
                async loadTickets() {
                    try {
                        this.loading = true;
                        console.log('Loading tickets for user:', this.currentUser);
                        console.log('User ID:', this.currentUser.userId);
                        console.log('Email:', this.currentUser.email);
                        
                        // Fetch by userId (preferred) or fallback to email
                        const userId = this.currentUser.userId;
                        let response;
                        
                        if (userId) {
                            response = await fetch(`api/bookings?userId=${userId}`);
                        } else {
                            response = await fetch(`api/bookings?email=` + encodeURIComponent(this.currentUser.email));
                        }
                        
                        console.log('Response status:', response.status);
                        
                        let data = await response.json();
                        console.log('Response data:', data);
                        
                        // If data is array, use it; otherwise it might be single object or error
                        if (Array.isArray(data)) {
                            this.tickets = data;
                        } else if (data && !data.error) {
                            this.tickets = [data];
                        } else {
                            this.tickets = [];
                            console.warn('No tickets found or error:', data);
                        }
                        
                        console.log('Loaded tickets:', this.tickets);
                        console.log('Total tickets:', this.tickets.length);
                    } catch (error) {
                        console.error('Error loading tickets:', error);
                        this.tickets = [];
                    } finally {
                        this.loading = false;
                    }
                },
                
                viewDetail(ticket) {
                    this.selectedTicket = ticket;
                    this.showDetailModal = true;
                },
                
                downloadTicket(ticket) {
                    const { jsPDF } = window.jspdf;
                    const doc = new jsPDF({
                        orientation: 'landscape',
                        unit: 'mm',
                        format: [100, 200] // Ticket size
                    });
                    
                    // Background
                    doc.setFillColor(255, 255, 255);
                    doc.rect(0, 0, 200, 100, 'F');
                    
                    // Header with brand color
                    doc.setFillColor(220, 38, 38); // Red color
                    doc.rect(0, 0, 200, 25, 'F');
                    
                    // Brand Name
                    doc.setTextColor(255, 255, 255);
                    doc.setFontSize(24);
                    doc.setFont(undefined, 'bold');
                    doc.text('ANJAYNOBAR', 10, 15);
                    
                    // Ticket Title
                    doc.setFontSize(10);
                    doc.setFont(undefined, 'normal');
                    doc.text('E-TICKET', 170, 15);
                    
                    // Divider line
                    doc.setDrawColor(220, 38, 38);
                    doc.setLineWidth(0.5);
                    doc.line(10, 27, 190, 27);
                    
                    // Movie Title
                    doc.setTextColor(0, 0, 0);
                    doc.setFontSize(16);
                    doc.setFont(undefined, 'bold');
                    const movieTitle = ticket.movieTitle || 'Movie Title';
                    doc.text(movieTitle, 10, 36);
                    
                    // Booking Code
                    doc.setFontSize(10);
                    doc.setFont(undefined, 'normal');
                    doc.text('Kode Booking', 10, 44);
                    doc.setFontSize(16);
                    doc.setFont(undefined, 'bold');
                    doc.setTextColor(220, 38, 38);
                    doc.text(ticket.bookingCode, 10, 51);
                    
                    // Left Column - Details
                    doc.setTextColor(0, 0, 0);
                    doc.setFontSize(9);
                    doc.setFont(undefined, 'normal');
                    
                    let yPos = 60;
                    const leftCol = 10;
                    const lineHeight = 7;
                    
                    
                    // Time
                    yPos += lineHeight + 4;
                    doc.setFont(undefined, 'bold');
                    doc.text('WAKTU', leftCol, yPos);
                    doc.setFont(undefined, 'normal');
                    doc.text(ticket.showtime || '-', leftCol, yPos + 4);
                    
                    // Theater
                    yPos += lineHeight + 4;
                    doc.setFont(undefined, 'bold');
                    doc.text('BIOSKOP', leftCol, yPos);
                    doc.setFont(undefined, 'normal');
                    doc.text(ticket.theaterName || 'AnjayNobar Theater', leftCol, yPos + 4);
                    
                    // Middle Column
                    const midCol = 70;
                    yPos = 60;
                    
                    // Seats
                    doc.setFont(undefined, 'bold');
                    doc.text('KURSI', midCol, yPos);
                    doc.setFont(undefined, 'normal');
                    const seats = ticket.seatCodes ? ticket.seatCodes.join(', ') : '-';
                    doc.text(seats, midCol, yPos + 4);
                    
                    // Quantity
                    yPos += lineHeight + 4;
                    doc.setFont(undefined, 'bold');
                    doc.text('JUMLAH TIKET', midCol, yPos);
                    doc.setFont(undefined, 'normal');
                    doc.text(String(ticket.totalSeats || 1), midCol, yPos + 4);
                    
                    // Price
                    yPos += lineHeight + 4;
                    doc.setFont(undefined, 'bold');
                    doc.text('TOTAL HARGA', midCol, yPos);
                    doc.setFont(undefined, 'normal');
                    doc.setTextColor(220, 38, 38);
                    doc.setFontSize(10);
                    doc.setFont(undefined, 'bold');
                    doc.text(this.formatPrice(ticket.totalPrice), midCol, yPos + 4);
                    
                    // QR Code on the right
                    const qrSize = 35;
                    const qrX = 155;
                    const qrY = 50;
                    
                    // Generate QR Code
                    try {
                        // Create temporary div for QR code
                        const qrDiv = document.createElement('div');
                        qrDiv.style.display = 'none';
                        document.body.appendChild(qrDiv);
                        
                        const qr = new QRCode(qrDiv, {
                            text: ticket.bookingCode,
                            width: 128,
                            height: 128
                        });
                        
                        // Wait a bit for QR code to generate
                        setTimeout(() => {
                            const qrImg = qrDiv.querySelector('img');
                            if (qrImg) {
                                doc.addImage(qrImg.src, 'PNG', qrX, qrY, qrSize, qrSize);
                            }
                            document.body.removeChild(qrDiv);
                            
                            // QR Label
                            doc.setTextColor(0, 0, 0);
                            doc.setFontSize(7);
                            doc.setFont(undefined, 'normal');
                            doc.text('Scan QR Code', qrX + qrSize/2, qrY + qrSize + 3, { align: 'center' });
                            
                            // Footer
                            doc.setDrawColor(220, 38, 38);
                            doc.setLineWidth(0.3);
                            doc.line(10, 93, 190, 93);
                            
                            doc.setFontSize(7);
                            doc.setTextColor(100, 100, 100);
                            const footerText = 'Tunjukkan tiket ini di loket bioskop • ' + this.formatDate(ticket.createdAt);
                            doc.text(footerText, 100, 97, { align: 'center' });
                            
                            // Save PDF
                            doc.save('Tiket-' + ticket.bookingCode + '.pdf');
                        }, 100);
                    } catch (error) {
                        console.error('Error generating QR code:', error);
                        
                        // If QR fails, draw a placeholder
                        doc.setDrawColor(200, 200, 200);
                        doc.setLineWidth(0.5);
                        doc.rect(qrX, qrY, qrSize, qrSize);
                        doc.setFontSize(8);
                        doc.setTextColor(150, 150, 150);
                        doc.text(ticket.bookingCode, qrX + qrSize/2, qrY + qrSize/2, { align: 'center' });
                        
                        // Footer
                        doc.setDrawColor(220, 38, 38);
                        doc.setLineWidth(0.3);
                        doc.line(10, 93, 190, 93);
                        
                        doc.setFontSize(7);
                        doc.setTextColor(100, 100, 100);
                        const footerText = 'Tunjukkan tiket ini di loket bioskop • ' + this.formatDate(ticket.createdAt);
                        doc.text(footerText, 100, 97, { align: 'center' });
                        
                        // Save PDF
                        doc.save('Tiket-' + ticket.bookingCode + '.pdf');
                    }
                },
                
                async logout() {
                    try {
                        await fetch('api/auth?action=logout', { method: 'POST' });
                        window.location.href = 'index.jsp';
                    } catch (error) {
                        console.error('Error logging out:', error);
                    }
                },
                
                formatPrice(price) {
                    if (!price) return 'Rp 0';
                    return 'Rp ' + parseInt(price).toLocaleString('id-ID');
                },
                
                formatDate(dateString) {
                    if (!dateString) return '-';
                    const date = new Date(dateString);
                    const options = { 
                        year: 'numeric', 
                        month: 'long', 
                        day: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit'
                    };
                    return date.toLocaleDateString('id-ID', options);
                },
                
                getStatusText(status) {
                    const statusMap = {
                        'confirmed': 'Terkonfirmasi',
                        'cancelled': 'Dibatalkan',
                        'pending': 'Menunggu',
                        'used': 'Sudah Digunakan'
                    };
                    return statusMap[status] || status;
                }
            }
        }
    </script>
</body>
</html>
