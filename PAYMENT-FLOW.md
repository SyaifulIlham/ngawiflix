# Payment Flow Documentation

## Fitur Payment dengan QR Code

### Alur Pembayaran

1. **User memilih kursi** dan klik "Konfirmasi Pesanan"
2. **Payment Modal muncul** dengan QR Code
3. **Countdown timer** dimulai (10 detik)
4. Pada detik ke-5, status berubah ke "processing"
5. Pada detik ke-0, **otomatis melakukan pembayaran**
6. **Data booking tersimpan ke database**
7. **Success modal** muncul dengan booking code

### State Management

```javascript
showPaymentModal: false,           // Control visibility payment modal
paymentStatus: 'pending',          // 'pending', 'processing', 'success'
paymentCountdown: 10,              // Countdown timer (10 detik)
```

### Payment Status

1. **pending** - Menampilkan QR Code dan countdown
2. **processing** - Menampilkan loading spinner
3. **success** - Menampilkan checkmark sukses

### Function Flow

```javascript
bookTickets()
  ↓
startPaymentCountdown()
  ↓ (setelah countdown selesai)
processPayment()
  ↓
BookingServlet (POST /api/bookings)
  ↓
BookingDAO.createBooking()
  ↓
Success Modal dengan booking code
```

### API Endpoint

**POST** `/api/bookings`

Request Body:
```json
{
  "scheduleId": 1,
  "customerName": "John Doe",
  "customerEmail": "john@example.com",
  "customerPhone": "08123456789",
  "seatIds": [1, 2, 3]
}
```

Response Success:
```json
{
  "success": true,
  "bookingCode": "CX-XXXXXXXX",
  "message": "Booking berhasil dibuat!"
}
```

Response Error:
```json
{
  "success": false,
  "error": "Error message"
}
```

### Database Transaction

BookingDAO melakukan transaksi dengan langkah:
1. Generate booking code
2. Insert ke tabel `bookings`
3. Insert ke tabel `booking_details` (untuk setiap seat)
4. Update status seat menjadi 'occupied'
5. Commit transaction (atau rollback jika error)

### Troubleshooting

#### Error 500 saat booking
1. Cek console log di server untuk detail error
2. Pastikan database connection berjalan
3. Verify scheduleId valid
4. Verify seatIds valid dan belum terpesan

#### Payment modal tidak muncul
1. Pastikan user sudah login
2. Pastikan ada kursi yang dipilih
3. Cek browser console untuk error JavaScript

#### Countdown tidak berjalan
1. Verify `startPaymentCountdown()` dipanggil
2. Cek apakah interval di-clear dengan benar

### Testing

1. Login sebagai user
2. Pilih film dan jadwal
3. Pilih kursi
4. Klik "Konfirmasi Pesanan"
5. Payment modal muncul dengan QR code
6. Tunggu countdown (atau bisa dipercepat untuk testing)
7. Verify booking tersimpan di database
8. Verify seat status berubah jadi 'occupied'
9. Verify booking code ditampilkan di success modal

### Logging

BookingServlet menampilkan log detail:
- Request body JSON
- Schedule ID dan customer info
- Seat IDs yang dipesan
- Schedule price
- Total calculation
- Booking code yang di-generate
- Error messages (jika ada)

Cek Tomcat logs untuk detail debugging.
