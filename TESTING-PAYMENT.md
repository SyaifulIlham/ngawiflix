# Testing Payment Flow - Quick Guide

## Prerequisites
1. Server Tomcat running
2. Database PostgreSQL running
3. User sudah terdaftar (atau register baru)

## Step-by-Step Testing

### 1. Login
```
1. Buka http://localhost:8080/pemesanan-tikek-bioskop/
2. Klik tombol "Masuk" di navbar
3. Login dengan:
   - Username: user (password: user123)
   - Atau register akun baru
```

### 2. Pilih Film & Jadwal
```
1. Klik "Pesan Tiket" pada film yang diinginkan
2. Pilih Bioskop (dropdown)
3. Pilih Tanggal (dropdown muncul setelah pilih bioskop)
4. Pilih Jam (dropdown muncul setelah pilih tanggal)
5. Seat selection modal akan muncul
```

### 3. Pilih Kursi
```
1. Klik kursi yang tersedia (warna abu-abu)
2. Kursi terpilih akan berubah warna merah
3. Total harga akan terupdate otomatis
```

### 4. Konfirmasi & Payment
```
1. Klik tombol "Konfirmasi Pesanan"
2. Payment modal muncul dengan QR Code
3. Countdown dimulai dari 10 detik
4. Pada detik ke-5: status "processing" (loading spinner)
5. Pada detik ke-0: otomatis proses payment
6. Success modal muncul dengan booking code
```

### 5. Verify Database
```sql
-- Cek booking terbaru
SELECT * FROM bookings ORDER BY created_at DESC LIMIT 1;

-- Cek booking details
SELECT bd.*, s.row_letter, s.seat_number, s.status
FROM booking_details bd
JOIN seats s ON bd.seat_id = s.seat_id
WHERE bd.booking_id = (SELECT booking_id FROM bookings ORDER BY created_at DESC LIMIT 1);

-- Cek status kursi (harus 'occupied')
SELECT * FROM seats WHERE status = 'occupied';
```

## Expected Results

### Payment Modal Display
- ✅ QR Code icon ditampilkan
- ✅ Total pembayaran muncul
- ✅ List kursi yang dipilih muncul
- ✅ Countdown timer berjalan

### After Payment Success
- ✅ Data masuk ke tabel `bookings`
- ✅ Data masuk ke tabel `booking_details`
- ✅ Status kursi berubah ke 'occupied'
- ✅ Booking code ter-generate (format: CX-XXXXXXXX)
- ✅ Success modal muncul
- ✅ Booking code ditampilkan

## Common Issues & Solutions

### ❌ Error 500 saat klik Konfirmasi
**Cek:**
1. Browser Console → Network tab → Response error message
2. Tomcat Console → Detailed error log
3. Database → Apakah schedule_id valid?
4. Database → Apakah seat_id valid dan belum occupied?

**Solusi:**
```bash
# Restart Tomcat
# Rebuild project
mvn clean install

# Cek database connection
psql -U postgres -d cinemax
\dt  # list tables
```

### ❌ Payment modal tidak muncul
**Cek:**
1. Apakah user sudah login? (cek navbar - harus ada menu user)
2. Apakah ada kursi yang dipilih? (selectedSeats.length > 0)
3. Browser Console → Cek error JavaScript

### ❌ Countdown tidak jalan
**Cek:**
```javascript
// Di browser console
console.log(Alpine.store('app').paymentCountdown)
console.log(Alpine.store('app').paymentStatus)
```

### ❌ Data tidak masuk database
**Cek:**
1. Tomcat console → SQL error?
2. Database → Foreign key constraint error?
3. Transaction rollback?

```sql
-- Verify schedule exists
SELECT * FROM schedules WHERE schedule_id = 1;

-- Verify seats exists dan available
SELECT * FROM seats WHERE seat_id IN (1,2,3);
```

## Debug Mode

### Enable detailed logging in browser
```javascript
// Di browser console sebelum booking
localStorage.setItem('debug', 'true');
```

### Check server logs
```bash
# Location: Tomcat/logs/catalina.out
tail -f catalina.out

# Look for:
=== Booking Request Started ===
Request body: {...}
Schedule ID: 1
Customer: ...
Seat IDs: [1,2,3]
Total price: 150000
Booking created successfully. Code: CX-XXXXXXXX
```

## Quick SQL Queries

```sql
-- Reset seat status (untuk testing ulang)
UPDATE seats SET status = 'available' WHERE schedule_id = 1;

-- Delete test bookings
DELETE FROM booking_details WHERE booking_id IN (SELECT booking_id FROM bookings WHERE customer_email = 'test@test.com');
DELETE FROM bookings WHERE customer_email = 'test@test.com';

-- View all bookings
SELECT b.booking_code, b.customer_name, b.total_seats, b.total_price, b.created_at
FROM bookings b
ORDER BY b.created_at DESC;
```

## Success Indicators

Jika semua berjalan lancar:
1. ✅ Payment modal muncul dengan smooth
2. ✅ Countdown berjalan lancar
3. ✅ Processing state muncul
4. ✅ Success modal muncul setelah 2 detik
5. ✅ Booking code unique ter-generate
6. ✅ Database terisi dengan benar
7. ✅ Seat status ter-update
8. ✅ No error di console (browser & server)
