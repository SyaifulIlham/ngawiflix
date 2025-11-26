package com.cinemax.dao;

import com.cinemax.model.Booking;
import com.cinemax.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class BookingDAO {
    
    public String createBooking(Booking booking, List<Integer> seatIds) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Generate booking code
            String bookingCode = generateBookingCode();
            
            // Insert booking with user_id
            String sql = "INSERT INTO bookings (booking_code, user_id, schedule_id, total_seats, total_price, " +
                        "customer_name, customer_email, customer_phone, booking_status) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'confirmed') RETURNING booking_id";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, bookingCode);
            
            // Set user_id (NULL if 0)
            if (booking.getUserId() > 0) {
                pstmt.setInt(2, booking.getUserId());
            } else {
                pstmt.setNull(2, java.sql.Types.INTEGER);
            }
            
            pstmt.setInt(3, booking.getScheduleId());
            pstmt.setInt(4, booking.getTotalSeats());
            pstmt.setBigDecimal(5, booking.getTotalPrice());
            pstmt.setString(6, booking.getCustomerName());
            pstmt.setString(7, booking.getCustomerEmail());
            pstmt.setString(8, booking.getCustomerPhone());
            
            rs = pstmt.executeQuery();
            int bookingId = 0;
            if (rs.next()) {
                bookingId = rs.getInt(1);
            }
            
            // Insert booking details and update seat status
            String detailSql = "INSERT INTO booking_details (booking_id, seat_id) VALUES (?, ?)";
            String updateSeatSql = "UPDATE seats SET status = 'occupied' WHERE seat_id = ?";
            
            PreparedStatement detailStmt = conn.prepareStatement(detailSql);
            PreparedStatement seatStmt = conn.prepareStatement(updateSeatSql);
            
            for (Integer seatId : seatIds) {
                detailStmt.setInt(1, bookingId);
                detailStmt.setInt(2, seatId);
                detailStmt.addBatch();
                
                seatStmt.setInt(1, seatId);
                seatStmt.addBatch();
            }
            
            detailStmt.executeBatch();
            seatStmt.executeBatch();
            
            conn.commit(); // Commit transaction
            
            return bookingCode;
            
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback(); // Rollback on error
            }
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) {
                conn.setAutoCommit(true);
            }
        }
    }
    
    public Booking getBookingByCode(String bookingCode) throws SQLException {
        String sql = "SELECT b.*, " +
                    "STRING_AGG(s.row_letter || s.seat_number, ', ' ORDER BY s.row_letter, s.seat_number) as seat_codes " +
                    "FROM bookings b " +
                    "LEFT JOIN booking_details bd ON b.booking_id = bd.booking_id " +
                    "LEFT JOIN seats s ON bd.seat_id = s.seat_id " +
                    "WHERE b.booking_code = ? " +
                    "GROUP BY b.booking_id";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, bookingCode);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Booking booking = new Booking();
                    booking.setBookingId(rs.getInt("booking_id"));
                    booking.setScheduleId(rs.getInt("schedule_id"));
                    booking.setBookingCode(rs.getString("booking_code"));
                    booking.setTotalSeats(rs.getInt("total_seats"));
                    booking.setTotalPrice(rs.getBigDecimal("total_price"));
                    booking.setBookingStatus(rs.getString("booking_status"));
                    booking.setCustomerName(rs.getString("customer_name"));
                    booking.setCustomerEmail(rs.getString("customer_email"));
                    booking.setCustomerPhone(rs.getString("customer_phone"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    String seatCodes = rs.getString("seat_codes");
                    if (seatCodes != null) {
                        booking.setSeatCodes(List.of(seatCodes.split(", ")));
                    }
                    
                    return booking;
                }
            }
        }
        
        return null;
    }
    
    public List<Booking> getBookingsByEmail(String email) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, " +
                    "m.title as movie_title, " +
                    "s.show_time, " +
                    "t.theater_name, " +
                    "STRING_AGG(st.row_letter || st.seat_number, ', ' ORDER BY st.row_letter, st.seat_number) as seat_codes " +
                    "FROM bookings b " +
                    "LEFT JOIN schedules s ON b.schedule_id = s.schedule_id " +
                    "LEFT JOIN movies m ON s.movie_id = m.movie_id " +
                    "LEFT JOIN theaters t ON s.theater_id = t.theater_id " +
                    "LEFT JOIN booking_details bd ON b.booking_id = bd.booking_id " +
                    "LEFT JOIN seats st ON bd.seat_id = st.seat_id " +
                    "WHERE b.customer_email = ? " +
                    "GROUP BY b.booking_id, m.title, s.show_time, t.theater_name " +
                    "ORDER BY b.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setBookingId(rs.getInt("booking_id"));
                    booking.setScheduleId(rs.getInt("schedule_id"));
                    booking.setBookingCode(rs.getString("booking_code"));
                    booking.setTotalSeats(rs.getInt("total_seats"));
                    booking.setTotalPrice(rs.getBigDecimal("total_price"));
                    booking.setBookingStatus(rs.getString("booking_status"));
                    booking.setCustomerName(rs.getString("customer_name"));
                    booking.setCustomerEmail(rs.getString("customer_email"));
                    booking.setCustomerPhone(rs.getString("customer_phone"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    // Additional fields from joins - handle NULL values
                    booking.setMovieTitle(rs.getString("movie_title"));
                    
                    // Convert show_time timestamp to string
                    Timestamp showTime = rs.getTimestamp("show_time");
                    if (showTime != null) {
                        booking.setShowtime(showTime.toString());
                    }
                    
                    booking.setTheaterName(rs.getString("theater_name"));
                    
                    String seatCodes = rs.getString("seat_codes");
                    if (seatCodes != null && !seatCodes.isEmpty()) {
                        booking.setSeatCodes(List.of(seatCodes.split(", ")));
                    }
                    
                    bookings.add(booking);
                }
            }
        }
        
        return bookings;
    }
    
    public List<Booking> getBookingsByUserId(int userId) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, " +
                    "m.title as movie_title, " +
                    "s.show_time, " +
                    "t.theater_name, " +
                    "STRING_AGG(st.row_letter || st.seat_number, ', ' ORDER BY st.row_letter, st.seat_number) as seat_codes " +
                    "FROM bookings b " +
                    "LEFT JOIN schedules s ON b.schedule_id = s.schedule_id " +
                    "LEFT JOIN movies m ON s.movie_id = m.movie_id " +
                    "LEFT JOIN theaters t ON s.theater_id = t.theater_id " +
                    "LEFT JOIN booking_details bd ON b.booking_id = bd.booking_id " +
                    "LEFT JOIN seats st ON bd.seat_id = st.seat_id " +
                    "WHERE b.user_id = ? " +
                    "GROUP BY b.booking_id, m.title, s.show_time, t.theater_name " +
                    "ORDER BY b.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setBookingId(rs.getInt("booking_id"));
                    booking.setScheduleId(rs.getInt("schedule_id"));
                    booking.setBookingCode(rs.getString("booking_code"));
                    booking.setTotalSeats(rs.getInt("total_seats"));
                    booking.setTotalPrice(rs.getBigDecimal("total_price"));
                    booking.setBookingStatus(rs.getString("booking_status"));
                    booking.setCustomerName(rs.getString("customer_name"));
                    booking.setCustomerEmail(rs.getString("customer_email"));
                    booking.setCustomerPhone(rs.getString("customer_phone"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    // Additional fields from joins - handle NULL values
                    booking.setMovieTitle(rs.getString("movie_title"));
                    
                    // Convert show_time timestamp to string
                    Timestamp showTime = rs.getTimestamp("show_time");
                    if (showTime != null) {
                        booking.setShowtime(showTime.toString());
                    }
                    
                    booking.setTheaterName(rs.getString("theater_name"));
                    
                    String seatCodes = rs.getString("seat_codes");
                    if (seatCodes != null && !seatCodes.isEmpty()) {
                        booking.setSeatCodes(List.of(seatCodes.split(", ")));
                    }
                    
                    bookings.add(booking);
                }
            }
        }
        
        return bookings;
    }
    
    private String generateBookingCode() {
        return "CX-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
}
