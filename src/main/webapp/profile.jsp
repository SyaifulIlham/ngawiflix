<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="id" class="scroll-smooth">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Profile - CineGO</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
    </head>

    <body class="bg-slate-950 text-white min-h-screen" x-data="profileApp()" x-init="init()">

        <!-- Include Navbar -->
        <jsp:include page="component/navbar.jsp" />

        <!-- Main Content -->
        <div class="pt-32 pb-20">
            <div class="container mx-auto px-4 lg:px-8">
                <!-- Page Header -->
                <div class="mb-8">
                    <h1 class="text-4xl font-bold mb-2">Profile Saya</h1>
                    <p class="text-gray-400">Kelola informasi akun Anda</p>
                </div>

                <div class="grid lg:grid-cols-3 gap-8">
                    <!-- Profile Card -->
                    <div class="lg:col-span-1">
                        <div class="bg-slate-900 rounded-2xl p-6 border border-slate-800">
                            <!-- Avatar -->
                            <div class="text-center mb-6">
                                <div class="relative inline-block">
                                    <div
                                        class="w-32 h-32 rounded-full bg-gradient-to-br from-red-500 to-red-700 flex items-center justify-center text-4xl font-bold mx-auto mb-4">
                                        <i class="fas fa-user text-white"></i>
                                    </div>
                                    <button
                                        class="absolute bottom-2 right-2 bg-slate-800 hover:bg-slate-700 rounded-full p-2 transition">
                                        <i class="fas fa-camera text-sm"></i>
                                    </button>
                                </div>
                                <h2 class="text-2xl font-bold" x-text="user.fullName || user.username"></h2>
                                <p class="text-gray-400" x-text="user.email"></p>
                                <div class="mt-3">
                                    <span
                                        class="inline-block px-3 py-1 bg-red-500/20 text-red-500 rounded-full text-sm font-semibold uppercase"
                                        x-text="user.role"></span>
                                </div>
                            </div>

                            <!-- Quick Stats -->
                            <div class="space-y-3 pt-6 border-t border-slate-800">
                                <div class="flex items-center justify-between">
                                    <span class="text-gray-400">
                                        <i class="fas fa-ticket-alt mr-2"></i>Total Tiket
                                    </span>
                                    <span class="font-bold" x-text="stats.totalTickets"></span>
                                </div>
                                <div class="flex items-center justify-between">
                                    <span class="text-gray-400">
                                        <i class="fas fa-calendar mr-2"></i>Bergabung
                                    </span>
                                    <span class="font-bold" x-text="formatDate(user.createdAt)"></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Profile Information -->
                    <div class="lg:col-span-2 space-y-6">
                        <!-- Personal Information -->
                        <div class="bg-slate-900 rounded-2xl p-6 border border-slate-800">
                            <div class="flex items-center justify-between mb-6">
                                <h3 class="text-2xl font-bold">Informasi Personal</h3>
                                <button @click="editMode = !editMode"
                                    class="px-4 py-2 bg-slate-800 hover:bg-slate-700 rounded-lg transition">
                                    <i class="fas" :class="editMode ? 'fa-times' : 'fa-edit'" class="mr-2"></i>
                                    <span x-text="editMode ? 'Batal' : 'Edit'"></span>
                                </button>
                            </div>

                            <form @submit.prevent="saveProfile()" class="space-y-4">
                                <div class="grid md:grid-cols-2 gap-4">
                                    <!-- Username -->
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Username</label>
                                        <input type="text" x-model="formData.username" :disabled="!editMode"
                                            class="w-full px-4 py-3 bg-slate-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 disabled:opacity-50 disabled:cursor-not-allowed">
                                    </div>

                                    <!-- Full Name -->
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Nama Lengkap</label>
                                        <input type="text" x-model="formData.fullName" :disabled="!editMode"
                                            class="w-full px-4 py-3 bg-slate-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 disabled:opacity-50 disabled:cursor-not-allowed">
                                    </div>

                                    <!-- Email -->
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Email</label>
                                        <input type="email" x-model="formData.email" :disabled="!editMode"
                                            class="w-full px-4 py-3 bg-slate-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 disabled:opacity-50 disabled:cursor-not-allowed">
                                    </div>

                                    <!-- Phone -->
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">No. Telepon</label>
                                        <input type="tel" x-model="formData.phone" :disabled="!editMode"
                                            placeholder="08xxxxxxxxxx"
                                            class="w-full px-4 py-3 bg-slate-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 disabled:opacity-50 disabled:cursor-not-allowed">
                                    </div>
                                </div>

                                <!-- Save Button -->
                                <div x-show="editMode" x-transition class="flex justify-end">
                                    <button type="submit"
                                        class="px-6 py-3 bg-gradient-to-r from-red-500 to-red-700 rounded-lg hover:from-red-600 hover:to-red-800 transition font-semibold">
                                        <i class="fas fa-save mr-2"></i>Simpan Perubahan
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- Change Password -->
                        <div class="bg-slate-900 rounded-2xl p-6 border border-slate-800">
                            <h3 class="text-2xl font-bold mb-6">Ubah Password</h3>

                            <form @submit.prevent="changePassword()" class="space-y-4">
                                <div>
                                    <label class="block text-sm font-medium text-gray-400 mb-2">Password Lama</label>
                                    <input type="password" x-model="passwordData.oldPassword"
                                        class="w-full px-4 py-3 bg-slate-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500"
                                        required>
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-gray-400 mb-2">Password Baru</label>
                                    <input type="password" x-model="passwordData.newPassword"
                                        class="w-full px-4 py-3 bg-slate-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500"
                                        required>
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-gray-400 mb-2">Konfirmasi Password
                                        Baru</label>
                                    <input type="password" x-model="passwordData.confirmPassword"
                                        class="w-full px-4 py-3 bg-slate-800 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500"
                                        required>
                                </div>

                                <div class="flex justify-end">
                                    <button type="submit"
                                        class="px-6 py-3 bg-slate-800 hover:bg-slate-700 rounded-lg transition font-semibold">
                                        <i class="fas fa-key mr-2"></i>Ubah Password
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- Account Actions -->
                        <div class="bg-slate-900 rounded-2xl p-6 border border-slate-800">
                            <h3 class="text-2xl font-bold mb-6">Aksi Akun</h3>

                            <div class="space-y-3">
                                <button @click="logout()"
                                    class="w-full px-6 py-3 bg-slate-800 hover:bg-slate-700 rounded-lg transition text-left">
                                    <i class="fas fa-sign-out-alt mr-2 text-yellow-500"></i>
                                    <span>Logout dari Akun</span>
                                </button>

                                <button @click="confirmDelete()"
                                    class="w-full px-6 py-3 bg-red-900/20 hover:bg-red-900/30 rounded-lg transition text-left text-red-500">
                                    <i class="fas fa-trash mr-2"></i>
                                    <span>Hapus Akun</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Toast Notification -->
        <div x-show="toast.show" x-transition @click="toast.show = false"
            :class="toast.type === 'success' ? 'bg-green-500' : 'bg-red-500'"
            class="fixed bottom-8 right-8 px-6 py-4 rounded-lg shadow-lg cursor-pointer z-50" style="display: none;">
            <div class="flex items-center space-x-3">
                <i class="fas" :class="toast.type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'"></i>
                <span x-text="toast.message"></span>
            </div>
        </div>

        <script>
            function profileApp() {
                return {
                    user: {},
                    formData: {},
                    passwordData: {
                        oldPassword: '',
                        newPassword: '',
                        confirmPassword: ''
                    },
                    stats: {
                        totalTickets: 0
                    },
                    editMode: false,
                    toast: {
                        show: false,
                        message: '',
                        type: 'success'
                    },

                    init() {
                        // Load user data from session
                        const currentUser = JSON.parse(sessionStorage.getItem('currentUser') || '{}');

                        // Debug logging
                        console.log('=== Profile Page Debug ===');
                        console.log('currentUser:', currentUser);
                        console.log('Has username?', !!currentUser.username);

                        // Redirect if not logged in
                        if (!currentUser.username) {
                            alert('Silakan login terlebih dahulu');
                            window.location.href = 'index.jsp';
                            return;
                        }

                        this.user = currentUser;
                        this.formData = { ...currentUser };

                        // Simulate loading stats (replace with actual API call)
                        this.loadStats();
                    },

                    loadStats() {
                        // TODO: Replace with actual API call
                        this.stats.totalTickets = Math.floor(Math.random() * 20);
                    },

                    async saveProfile() {
                        // Validate form
                        if (!this.formData.username || !this.formData.email) {
                            this.showToast('Username dan email harus diisi', 'error');
                            return;
                        }

                        try {
                            this.loading = true;

                            // Send update request to backend
                            const params = new URLSearchParams({
                                action: 'update',
                                userId: this.user.userId,
                                username: this.formData.username,
                                email: this.formData.email,
                                fullName: this.formData.fullName || '',
                                phone: this.formData.phone || ''
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
                                // Update local user data
                                this.user = { ...this.user, ...this.formData };
                                sessionStorage.setItem('currentUser', JSON.stringify(this.user));

                                this.editMode = false;
                                this.showToast('Profile berhasil diperbarui!', 'success');
                            } else {
                                this.showToast(result.error || 'Gagal memperbarui profile', 'error');
                            }
                        } catch (error) {
                            console.error('Error updating profile:', error);
                            this.showToast('Terjadi kesalahan saat memperbarui profile', 'error');
                        } finally {
                            this.loading = false;
                        }
                    },

                    async changePassword() {
                        if (this.passwordData.newPassword !== this.passwordData.confirmPassword) {
                            this.showToast('Password baru tidak cocok!', 'error');
                            return;
                        }

                        if (this.passwordData.newPassword.length < 6) {
                            this.showToast('Password minimal 6 karakter!', 'error');
                            return;
                        }

                        try {
                            this.loading = true;

                            // Send password change request to backend
                            const params = new URLSearchParams({
                                action: 'changePassword',
                                userId: this.user.userId,
                                oldPassword: this.passwordData.oldPassword,
                                newPassword: this.passwordData.newPassword
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
                                this.showToast('Password berhasil diubah!', 'success');

                                // Reset form
                                this.passwordData = {
                                    oldPassword: '',
                                    newPassword: '',
                                    confirmPassword: ''
                                };
                            } else {
                                this.showToast(result.error || 'Gagal mengubah password', 'error');
                            }
                        } catch (error) {
                            console.error('Error changing password:', error);
                            this.showToast('Terjadi kesalahan saat mengubah password', 'error');
                        } finally {
                            this.loading = false;
                        }
                    },

                    logout() {
                        if (confirm('Yakin ingin logout?')) {
                            sessionStorage.removeItem('currentUser');
                            window.location.href = 'index.jsp';
                        }
                    },

                    confirmDelete() {
                        if (confirm('PERINGATAN: Akun Anda akan dihapus permanen. Yakin ingin melanjutkan?')) {
                            // TODO: Send delete request to backend
                            this.showToast('Fitur hapus akun akan segera tersedia', 'error');
                        }
                    },

                    formatDate(dateString) {
                        if (!dateString) return 'N/A';
                        const date = new Date(dateString);
                        return date.toLocaleDateString('id-ID', { year: 'numeric', month: 'short' });
                    },

                    showToast(message, type = 'success') {
                        this.toast.message = message;
                        this.toast.type = type;
                        this.toast.show = true;

                        setTimeout(() => {
                            this.toast.show = false;
                        }, 3000);
                    }
                }
            }
        </script>
    </body>

    </html>