package com.cinemax.dao;

import com.cinemax.model.Schedule;
import com.cinemax.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScheduleDAO {
    
    public List<Schedule> getSchedulesByMovieId(int movieId) throws SQLException {
        List<Schedule> schedules = new ArrayList<>();
        // Filter out past schedules - only show future dates or today's future times
        String sql = "SELECT * FROM v_schedule_details WHERE movie_id = ? " +
                     "AND (show_date > CURRENT_DATE OR (show_date = CURRENT_DATE AND show_time > CURRENT_TIME)) " +
                     "ORDER BY show_date, show_time";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, movieId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Schedule schedule = extractScheduleFromResultSet(rs);
                    schedules.add(schedule);
                }
            }
        }
        
        return schedules;
    }
    
    // For admin - get all schedules including past ones
    public List<Schedule> getAllSchedulesByMovieId(int movieId) throws SQLException {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM v_schedule_details WHERE movie_id = ? " +
                     "ORDER BY show_date DESC, show_time DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, movieId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Schedule schedule = extractScheduleFromResultSet(rs);
                    schedules.add(schedule);
                }
            }
        }
        
        return schedules;
    }
    
    public Schedule getScheduleById(int scheduleId) throws SQLException {
        String sql = "SELECT * FROM v_schedule_details WHERE schedule_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, scheduleId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractScheduleFromResultSet(rs);
                }
            }
        }
        
        return null;
    }
    
    public List<Schedule> getTodaySchedules() throws SQLException {
        List<Schedule> schedules = new ArrayList<>();
        // Only show today's schedules with future times
        String sql = "SELECT * FROM v_schedule_details WHERE show_date = CURRENT_DATE " +
                     "AND show_time > CURRENT_TIME ORDER BY show_time";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Schedule schedule = extractScheduleFromResultSet(rs);
                schedules.add(schedule);
            }
        }
        
        return schedules;
    }
    
    public List<Schedule> getAllSchedules() throws SQLException {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM v_schedule_details ORDER BY show_date DESC, show_time ASC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Schedule schedule = extractScheduleFromResultSet(rs);
                schedules.add(schedule);
            }
        }
        
        return schedules;
    }
    
    public boolean createSchedule(Schedule schedule) throws SQLException {
        // Use RETURNING to get the inserted schedule_id
        String sql = "INSERT INTO schedules (movie_id, theater_id, show_date, show_time, price) VALUES (?, ?, ?, ?, ?) RETURNING schedule_id";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, schedule.getMovieId());
            pstmt.setInt(2, schedule.getTheaterId());
            pstmt.setDate(3, schedule.getShowDate());
            pstmt.setTime(4, schedule.getShowTime());
            pstmt.setBigDecimal(5, schedule.getPrice());
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int newScheduleId = rs.getInt("schedule_id");
                    // Generate seats for the new schedule
                    generateSeatsForSchedule(conn, newScheduleId, schedule.getTheaterId());
                    return true;
                }
            }
        }
        
        return false;
    }
    
    public boolean updateSchedule(Schedule schedule) throws SQLException {
        String sql = "UPDATE schedules SET movie_id = ?, theater_id = ?, show_date = ?, show_time = ?, price = ? WHERE schedule_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, schedule.getMovieId());
            pstmt.setInt(2, schedule.getTheaterId());
            pstmt.setDate(3, schedule.getShowDate());
            pstmt.setTime(4, schedule.getShowTime());
            pstmt.setBigDecimal(5, schedule.getPrice());
            pstmt.setInt(6, schedule.getScheduleId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    public boolean deleteSchedule(int scheduleId) throws SQLException {
        String sql = "DELETE FROM schedules WHERE schedule_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, scheduleId);
            int rowsAffected = pstmt.executeUpdate();
            
            return rowsAffected > 0;
        }
    }
    
    private int getLastInsertedScheduleId(Connection conn) throws SQLException {
        String sql = "SELECT MAX(schedule_id) as last_id FROM schedules";
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("last_id");
            }
        }
        return 0;
    }
    
    private void generateSeatsForSchedule(Connection conn, int scheduleId, int theaterId) throws SQLException {
        // Get total seats for theater
        String getTheaterSql = "SELECT total_seats FROM theaters WHERE theater_id = ?";
        int totalSeats = 80; // default
        
        try (PreparedStatement pstmt = conn.prepareStatement(getTheaterSql)) {
            pstmt.setInt(1, theaterId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                totalSeats = rs.getInt("total_seats");
            }
        }
        
        // Generate seats
        int seatsPerRow = 10;
        int rowsCount = (int) Math.ceil((double) totalSeats / seatsPerRow);
        
        String insertSeatSql = "INSERT INTO seats (schedule_id, row_letter, seat_number, status) VALUES (?, ?, ?, 'available')";
        
        try (PreparedStatement pstmt = conn.prepareStatement(insertSeatSql)) {
            for (int i = 0; i < rowsCount; i++) {
                char rowLetter = (char) ('A' + i);
                for (int j = 1; j <= seatsPerRow && (i * seatsPerRow + j) <= totalSeats; j++) {
                    pstmt.setInt(1, scheduleId);
                    pstmt.setString(2, String.valueOf(rowLetter));
                    pstmt.setInt(3, j);
                    pstmt.addBatch();
                }
            }
            pstmt.executeBatch();
        }
    }
    
    private Schedule extractScheduleFromResultSet(ResultSet rs) throws SQLException {
        Schedule schedule = new Schedule();
        schedule.setScheduleId(rs.getInt("schedule_id"));
        schedule.setMovieId(rs.getInt("movie_id"));
        schedule.setTheaterId(rs.getInt("theater_id"));
        schedule.setShowDate(rs.getDate("show_date"));
        schedule.setShowTime(rs.getTime("show_time"));
        schedule.setPrice(rs.getBigDecimal("price"));
        
        // Additional info from view (may be null if not using view)
        try {
            schedule.setMovieTitle(rs.getString("movie_title"));
            schedule.setPosterUrl(rs.getString("poster_url"));
            schedule.setDuration(rs.getInt("duration"));
            schedule.setRated(rs.getString("rated"));
            schedule.setTheaterName(rs.getString("theater_name"));
            schedule.setLocation(rs.getString("location"));
            schedule.setTotalSeats(rs.getInt("total_seats"));
            schedule.setAvailableSeats(rs.getInt("available_seats"));
        } catch (SQLException e) {
            // These fields may not exist in all queries, ignore
        }
        
        return schedule;
    }
}
