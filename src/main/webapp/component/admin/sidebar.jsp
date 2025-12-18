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
            <a href="admin.jsp" class="sidebar-link flex items-center gap-3 px-4 py-3.5 rounded-xl hover:bg-slate-700/50" data-page="admin">
                <i class="fas fa-home w-5 text-lg"></i>
                <span class="font-medium">Dashboard</span>
            </a>
            <a href="movies.jsp" class="sidebar-link flex items-center gap-3 px-4 py-3.5 rounded-xl hover:bg-slate-700/50" data-page="movies">
                <i class="fas fa-film w-5 text-lg"></i>
                <span class="font-medium">Film</span>
            </a>
            <a href="theaters.jsp" class="sidebar-link flex items-center gap-3 px-4 py-3.5 rounded-xl hover:bg-slate-700/50" data-page="theaters">
                <i class="fas fa-building w-5 text-lg"></i>
                <span class="font-medium">Bioskop</span>
            </a>
            <a href="categories.jsp" class="sidebar-link flex items-center gap-3 px-4 py-3.5 rounded-xl hover:bg-slate-700/50" data-page="categories">
                <i class="fas fa-tags w-5 text-lg"></i>
                <span class="font-medium">Kategori</span>
            </a>
        </nav>
        
        <div class="mt-auto pt-6 border-t border-slate-700 space-y-2">
            <a href="../index.jsp" class="sidebar-link flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-slate-700/50 text-gray-300">
                <i class="fas fa-arrow-left w-5"></i>
                <span class="font-medium">Kembali ke Beranda</span>
            </a>
            <button onclick="logout()" class="w-full sidebar-link flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-red-600/90 text-gray-300 hover:text-white">
                <i class="fas fa-sign-out-alt w-5"></i>
                <span class="font-medium">Logout</span>
            </button>
        </div>
    </div>
</div>

<script>
// Fungsi untuk mengatur menu aktif berdasarkan halaman saat ini
function setActiveMenu() {
    // Ambil URL saat ini
    const currentPath = window.location.pathname;
    
    // Ambil nama file dari path
    const currentPage = currentPath.split('/').pop().replace('.jsp', '');
    
    // Ambil semua link sidebar
    const sidebarLinks = document.querySelectorAll('.sidebar-link[data-page]');
    
    // Hapus kelas active dari semua link
    sidebarLinks.forEach(link => {
        link.classList.remove('bg-gradient-to-r', 'from-red-600', 'to-red-700', 'shadow-lg');
        link.querySelector('span').classList.remove('font-semibold');
        link.querySelector('span').classList.add('font-medium');
    });
    
    // Tentukan halaman yang aktif
    let activePage = currentPage;
    
    // Jika di admin.jsp, set dashboard sebagai aktif
    if (currentPage === 'admin') {
        activePage = 'admin';
    }
    
    // Tambahkan kelas active ke link yang sesuai
    sidebarLinks.forEach(link => {
        if (link.dataset.page === activePage) {
            link.classList.add('bg-gradient-to-r', 'from-red-600', 'to-red-700', 'shadow-lg');
            link.querySelector('span').classList.remove('font-medium');
            link.querySelector('span').classList.add('font-semibold');
        }
    });
}

// Jalankan fungsi saat halaman dimuat
document.addEventListener('DOMContentLoaded', setActiveMenu);

// Fungsi logout (contoh)
function logout() {
    if (confirm('Apakah Anda yakin ingin logout?')) {
        window.location.href = '../logout.jsp';
    }
}
</script>