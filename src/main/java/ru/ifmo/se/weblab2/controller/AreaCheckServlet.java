package ru.ifmo.se.weblab2.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import ru.ifmo.se.weblab2.model.ContextRepository;
import ru.ifmo.se.weblab2.model.Repository;
import ru.ifmo.se.weblab2.model.ResultPoint;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class AreaCheckServlet extends HttpServlet {
    private Repository repository;

    @Override
    public void init() {
        repository = ContextRepository.getInstance();
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        long startTime = System.nanoTime();
        PrintWriter out = response.getWriter();
        double x = Double.parseDouble(request.getParameter("x"));
        double y = Double.parseDouble(request.getParameter("y"));
        double r = Double.parseDouble(request.getParameter("r"));
        if (validateInput(request)) {
            ResultPoint point = new ResultPoint(
                    System.currentTimeMillis() / 1000L,
                    (System.nanoTime() - startTime) / 1000,
                    x,
                    y,
                    r,
                    check(request)
            );
            repository.createPoint(point, request.getRequestedSessionId());
            String json = new ObjectMapper().writeValueAsString(point);
            out.println(json);
        } else {
            out.println("Error"); // TODO: dispatch to error page
        }
    }

    private boolean validateInput(HttpServletRequest request) {
        try {
            double x = Double.parseDouble(request.getParameter("x"));
            double y = Double.parseDouble(request.getParameter("y"));
            double r = Double.parseDouble(request.getParameter("r"));
            return (x >= -4) && (x <= 4) &&
                    (y >= -5) && (y <= 5) &&
                    (r >= 1) && (r <= 5);
        } catch (NumberFormatException ignored) {
            return false;
        }
    }

    private boolean check(HttpServletRequest request) {
        double x = Double.parseDouble(request.getParameter("x"));
        double y = Double.parseDouble(request.getParameter("y"));
        double r = Double.parseDouble(request.getParameter("r"));
        if (x > 0 && y > 0) {
            return false;
        } else if (x <= 0 && y >= 0) {
            return y <= 2 * x + r;
        } else if (x <= 0 && y <= 0) {
            return x >= -r && y >= -(r / 2);
        } else {
            return Math.sqrt((x * x) + (y * y)) <= (r / 2);
        }
    }

}