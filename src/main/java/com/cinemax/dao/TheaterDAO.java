package com.cinemax.dao;

import com.cinemax.model.Theater;
import com.cinemax.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TheaterDAO {
    
    public List<Theater> getAllTheaters() throws SQLException {
        List<Theater> theaters = new ArrayList<>();
        String sql = "SELECT * FROM theaters ORDER BY theater_name ASC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Theater theater = extractTheaterFromResultSet(rs);
                theaters.add(theater);
            }
        }
        
        return theaters;
    }
    
    public Theater getTheaterById(int theaterId) throws SQLException {
        String sql = "SELECT * FROM theaters WHERE theater_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, theaterId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractTheaterFromResultSet(rs);
            }
        }
        
        return null;
    }
    
    public boolean createTheater(Theater theater) throws SQLException {
        String sql = "INSERT INTO theaters (theater_name, location, total_seats) VALUES (?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, theater.getTheaterName());
            pstmt.setString(2, theater.getLocation());
            pstmt.setInt(3, theater.getTotalSeats());
            int rowsAffected = pstmt.executeUpdate();
            
            return rowsAffected > 0;
        }
    }
    
    public boolean updateTheater(Theater theater) throws SQLException {
        String sql = "UPDATE theaters SET theater_name = ?, location = ?, total_seats = ? WHERE theater_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, theater.getTheaterName());
            pstmt.setString(2, theater.getLocation());
            pstmt.setInt(3, theater.getTotalSeats());
            pstmt.setInt(4, theater.getTheaterId());
            int rowsAffected = pstmt.executeUpdate();
            
            return rowsAffected > 0;
        }
    }
    
    public boolean deleteTheater(int theaterId) throws SQLException {
        String sql = "DELETE FROM theaters WHERE theater_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, theaterId);
            int rowsAffected = pstmt.executeUpdate();
            
            return rowsAffected > 0;
        }
    }
    
    private Theater extractTheaterFromResultSet(ResultSet rs) throws SQLException {
        Theater theater = new Theater();
        theater.setTheaterId(rs.getInt("theater_id"));
        theater.setTheaterName(rs.getString("theater_name"));
        theater.setLocation(rs.getString("location"));
        theater.setTotalSeats(rs.getInt("total_seats"));
        theater.setCreatedAt(rs.getTimestamp("created_at"));
        return theater;
    }
}

