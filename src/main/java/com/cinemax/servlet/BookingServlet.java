package com.cinemax.servlet;

import com.cinemax.dao.BookingDAO;
import com.cinemax.dao.ScheduleDAO;
import com.cinemax.model.Booking;
import com.cinemax.model.Schedule;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/api/bookings")
public class BookingServlet extends HttpServlet {
    private BookingDAO bookingDAO;
    private ScheduleDAO scheduleDAO;
    private Gson gson;
    
    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        scheduleDAO = new ScheduleDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            System.out.println("=== Booking Request Started ===");
            
            // Read JSON from request body
            BufferedReader reader = request.getReader();
            String jsonBody = reader.lines().collect(Collectors.joining());
            System.out.println("Request body: " + jsonBody);
            
            JsonObject jsonObject = gson.fromJson(jsonBody, JsonObject.class);
            
            int userId = jsonObject.has("userId") ? jsonObject.get("userId").getAsInt() : 0;
            int scheduleId = jsonObject.get("scheduleId").getAsInt();
            String customerName = jsonObject.get("customerName").getAsString();
            String customerEmail = jsonObject.get("customerEmail").getAsString();
            String customerPhone = jsonObject.get("customerPhone").getAsString();
            
            System.out.println("User ID: " + userId);
            System.out.println("Schedule ID: " + scheduleId);
            System.out.println("Customer: " + customerName + " (" + customerEmail + ")");
            
            // Parse seat IDs from JsonArray
            List<Integer> seatIds = new ArrayList<>();
            JsonArray seatArray = jsonObject.getAsJsonArray("seatIds");
            for (JsonElement element : seatArray) {
                seatIds.add(element.getAsInt());
            }
            
            System.out.println("Seat IDs: " + seatIds);
            
            // Get schedule to calculate price
            Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
            
            if (schedule == null) {
                System.out.println("ERROR: Schedule not found for ID: " + scheduleId);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"error\": \"Schedule not found\"}");
                return;
            }
            
            System.out.println("Schedule found. Price: " + schedule.getPrice());
            
            // Create booking object
            Booking booking = new Booking();
            booking.setUserId(userId);
            booking.setScheduleId(scheduleId);
            booking.setCustomerName(customerName);
            booking.setCustomerEmail(customerEmail);
            booking.setCustomerPhone(customerPhone);
            booking.setTotalSeats(seatIds.size());
            booking.setTotalPrice(schedule.getPrice().multiply(new BigDecimal(seatIds.size())));
            
            System.out.println("Total seats: " + seatIds.size());
            System.out.println("Total price: " + booking.getTotalPrice());
            
            // Save booking
            String bookingCode = bookingDAO.createBooking(booking, seatIds);
            
            System.out.println("Booking created successfully. Code: " + bookingCode);
            System.out.println("=== Booking Request Completed ===");
            
            // Return booking code
            JsonObject result = new JsonObject();
            result.addProperty("success", true);
            result.addProperty("bookingCode", bookingCode);
            result.addProperty("message", "Booking berhasil dibuat!");
            
            out.print(gson.toJson(result));
            
        } catch (SQLException e) {
            System.err.println("SQL ERROR: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject error = new JsonObject();
            error.addProperty("success", false);
            error.addProperty("error", "Database error: " + e.getMessage());
            out.print(gson.toJson(error));
        } catch (Exception e) {
            System.err.println("GENERAL ERROR: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject error = new JsonObject();
            error.addProperty("success", false);
            error.addProperty("error", "Error: " + e.getMessage());
            out.print(gson.toJson(error));
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            String bookingCode = request.getParameter("bookingCode");
            String email = request.getParameter("email");
            String userIdParam = request.getParameter("userId");
            
            System.out.println("=== Get Bookings Request ===");
            System.out.println("Booking Code: " + bookingCode);
            System.out.println("Email: " + email);
            System.out.println("User ID: " + userIdParam);
            
            if (bookingCode != null) {
                Booking booking = bookingDAO.getBookingByCode(bookingCode);
                System.out.println("Found booking: " + (booking != null ? booking.getBookingCode() : "null"));
                out.print(gson.toJson(booking));
            } else if (userIdParam != null) {
                int userId = Integer.parseInt(userIdParam);
                List<Booking> bookings = bookingDAO.getBookingsByUserId(userId);
                System.out.println("Found " + bookings.size() + " bookings for user ID: " + userId);
                for (Booking b : bookings) {
                    System.out.println("  - " + b.getBookingCode() + " | " + b.getMovieTitle() + " | " + b.getCustomerEmail());
                }
                out.print(gson.toJson(bookings));
            } else if (email != null) {
                List<Booking> bookings = bookingDAO.getBookingsByEmail(email);
                System.out.println("Found " + bookings.size() + " bookings for email: " + email);
                for (Booking b : bookings) {
                    System.out.println("  - " + b.getBookingCode() + " | " + b.getMovieTitle() + " | " + b.getCustomerEmail());
                }
                out.print(gson.toJson(bookings));
            } else {
                System.out.println("No bookingCode, email, or userId parameter provided");
                out.print("[]");
            }
            
        } catch (SQLException e) {
            System.err.println("SQL Error in doGet: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject error = new JsonObject();
            error.addProperty("error", e.getMessage());
            out.print(gson.toJson(error));
        } catch (Exception e) {
            System.err.println("General Error in doGet: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject error = new JsonObject();
            error.addProperty("error", e.getMessage());
            out.print(gson.toJson(error));
        }
    }
}