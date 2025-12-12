package com.cinemax.servlet;

import com.cinemax.dao.ScheduleDAO;
import com.cinemax.model.Schedule;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/api/schedules")
public class ScheduleServlet extends HttpServlet {
    private ScheduleDAO scheduleDAO;
    private Gson gson;
    
    @Override
    public void init() {
        scheduleDAO = new ScheduleDAO();
        
        // Create custom Gson with Date and Time serializers
        gson = new GsonBuilder()
            .registerTypeAdapter(Date.class, new JsonSerializer<Date>() {
                @Override
                public JsonElement serialize(Date date, Type type, JsonSerializationContext context) {
                    return new JsonPrimitive(date.toString()); // yyyy-MM-dd format
                }
            })
            .registerTypeAdapter(Time.class, new JsonSerializer<Time>() {
                @Override
                public JsonElement serialize(Time time, Type type, JsonSerializationContext context) {
                    return new JsonPrimitive(time.toString()); // HH:mm:ss format
                }
            })
            .create();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*"); // Allow CORS
        
        PrintWriter out = response.getWriter();
        
        try {
            String movieIdParam = request.getParameter("movieId");
            String scheduleIdParam = request.getParameter("scheduleId");
            String idParam = request.getParameter("id");
            String includeAllParam = request.getParameter("includeAll"); // for admin
            
            if (idParam != null) {
                int scheduleId = Integer.parseInt(idParam);
                Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
                if (schedule != null) {
                    out.print(gson.toJson(schedule));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print("{\"error\": \"Schedule not found\"}");
                }
            } else if (scheduleIdParam != null && !scheduleIdParam.trim().isEmpty()) {
                int scheduleId = Integer.parseInt(scheduleIdParam.trim());
                Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
                out.print(gson.toJson(schedule));
            } else if (movieIdParam != null && !movieIdParam.trim().isEmpty()) {
                int movieId = Integer.parseInt(movieIdParam.trim());
                List<Schedule> schedules;
                
                // For admin, include all schedules (including past ones)
                if ("true".equals(includeAllParam)) {
                    schedules = scheduleDAO.getAllSchedulesByMovieId(movieId);
                } else {
                    // For users, only show future schedules
                    schedules = scheduleDAO.getSchedulesByMovieId(movieId);
                }
                
                out.print(gson.toJson(schedules));
            } else {
                // Return all schedules for admin
                List<Schedule> schedules = scheduleDAO.getAllSchedules();
                out.print(gson.toJson(schedules));
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid parameter format: " + e.getMessage() + "\"}");
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Database error: " + e.getMessage() + "\"}");
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Server error: " + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            BufferedReader reader = request.getReader();
            String json = reader.lines().collect(Collectors.joining());
            
            // Parse JSON manually to handle date/time conversion
            com.google.gson.JsonObject jsonObject = JsonParser.parseString(json).getAsJsonObject();
            Schedule schedule = new Schedule();
            
            schedule.setMovieId(jsonObject.get("movieId").getAsInt());
            schedule.setTheaterId(jsonObject.get("theaterId").getAsInt());
            
            // Parse date string (format: yyyy-MM-dd)
            String dateStr = jsonObject.get("showDate").getAsString();
            schedule.setShowDate(Date.valueOf(dateStr));
            
            // Parse time string (format: HH:mm or HH:mm:ss)
            String timeStr = jsonObject.get("showTime").getAsString();
            if (timeStr.length() == 5) {
                timeStr += ":00"; // Add seconds if not present
            }
            schedule.setShowTime(Time.valueOf(timeStr));
            
            // Parse price
            double priceValue = jsonObject.get("price").getAsDouble();
            schedule.setPrice(java.math.BigDecimal.valueOf(priceValue));
            
            boolean success = scheduleDAO.createSchedule(schedule);
            
            if (success) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                out.print("{\"success\": true, \"message\": \"Schedule created successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\": false, \"error\": \"Failed to create schedule\"}");
            }
            
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Invalid request data: " + e.getMessage().replace("\"", "\\\"") + "\"}");
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            String scheduleIdParam = request.getParameter("id");
            if (scheduleIdParam == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"error\": \"Schedule ID is required\"}");
                return;
            }
            
            int scheduleId = Integer.parseInt(scheduleIdParam);
            
            BufferedReader reader = request.getReader();
            String json = reader.lines().collect(Collectors.joining());
            
            // Parse JSON manually to handle date/time conversion
            com.google.gson.JsonObject jsonObject = JsonParser.parseString(json).getAsJsonObject();
            Schedule schedule = new Schedule();
            schedule.setScheduleId(scheduleId);
            
            schedule.setMovieId(jsonObject.get("movieId").getAsInt());
            schedule.setTheaterId(jsonObject.get("theaterId").getAsInt());
            
            // Parse date string (format: yyyy-MM-dd)
            String dateStr = jsonObject.get("showDate").getAsString();
            schedule.setShowDate(Date.valueOf(dateStr));
            
            // Parse time string (format: HH:mm or HH:mm:ss)
            String timeStr = jsonObject.get("showTime").getAsString();
            if (timeStr.length() == 5) {
                timeStr += ":00"; // Add seconds if not present
            }
            schedule.setShowTime(Time.valueOf(timeStr));
            
            // Parse price
            double priceValue = jsonObject.get("price").getAsDouble();
            schedule.setPrice(java.math.BigDecimal.valueOf(priceValue));
            
            boolean success = scheduleDAO.updateSchedule(schedule);
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"Schedule updated successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\": false, \"error\": \"Failed to update schedule\"}");
            }
            
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Invalid schedule ID\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Invalid request data\"}");
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            String scheduleIdParam = request.getParameter("id");
            if (scheduleIdParam == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"error\": \"Schedule ID is required\"}");
                return;
            }
            
            int scheduleId = Integer.parseInt(scheduleIdParam);
            
            boolean success = scheduleDAO.deleteSchedule(scheduleId);
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"Schedule deleted successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\": false, \"error\": \"Failed to delete schedule\"}");
            }
            
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Invalid schedule ID\"}");
        }
    }
}
