package com.cinemax.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class Booking {
    private int bookingId;
    private int userId;
    private int scheduleId;
    private String bookingCode;
    private int totalSeats;
    private BigDecimal totalPrice;
    private String bookingStatus;
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    private Timestamp createdAt;
    private List<String> seatCodes;
    
    // Additional fields for joined data
    private String movieTitle;
    private String showtime;
    private String theaterName;
    
    // Constructors
    public Booking() {}
    
    // Getters and Setters
    public int getBookingId() {
        return bookingId;
    }
    
    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getScheduleId() {
        return scheduleId;
    }
    
    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }
    
    public String getBookingCode() {
        return bookingCode;
    }
    
    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }
    
    public int getTotalSeats() {
        return totalSeats;
    }
    
    public void setTotalSeats(int totalSeats) {
        this.totalSeats = totalSeats;
    }
    
    public BigDecimal getTotalPrice() {
        return totalPrice;
    }
    
    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
    
    public String getBookingStatus() {
        return bookingStatus;
    }
    
    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getCustomerEmail() {
        return customerEmail;
    }
    
    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }
    
    public String getCustomerPhone() {
        return customerPhone;
    }
    
    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public List<String> getSeatCodes() {
        return seatCodes;
    }
    
    public void setSeatCodes(List<String> seatCodes) {
        this.seatCodes = seatCodes;
    }
    
    public String getMovieTitle() {
        return movieTitle;
    }
    
    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }
    
    public String getShowtime() {
        return showtime;
    }
    
    public void setShowtime(String showtime) {
        this.showtime = showtime;
    }
    
    public String getTheaterName() {
        return theaterName;
    }
    
    public void setTheaterName(String theaterName) {
        this.theaterName = theaterName;
    }
}
