package com.cinemax.model;

import java.sql.Timestamp;

public class Theater {
    private int theaterId;
    private String theaterName;
    private String location;
    private int totalSeats;
    private Timestamp createdAt;
    
    // Constructors
    public Theater() {}
    
    public Theater(int theaterId, String theaterName, String location, int totalSeats) {
        this.theaterId = theaterId;
        this.theaterName = theaterName;
        this.location = location;
        this.totalSeats = totalSeats;
    }
    
    // Getters and Setters
    public int getTheaterId() {
        return theaterId;
    }
    
    public void setTheaterId(int theaterId) {
        this.theaterId = theaterId;
    }
    
    public String getTheaterName() {
        return theaterName;
    }
    
    public void setTheaterName(String theaterName) {
        this.theaterName = theaterName;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public int getTotalSeats() {
        return totalSeats;
    }
    
    public void setTotalSeats(int totalSeats) {
        this.totalSeats = totalSeats;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

