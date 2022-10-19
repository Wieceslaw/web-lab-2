package ru.ifmo.se.weblab2.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import ru.ifmo.se.weblab2.model.ContextRepository;
import ru.ifmo.se.weblab2.model.Point;
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
        Point point = validateInput(request);
        if (point != null) {
            ResultPoint rPoint = new ResultPoint(
                    System.currentTimeMillis() / 1000L,
                    (System.nanoTime() - startTime) / 1000,
                    point.getX(),
                    point.getY(),
                    point.getR(),
                    check(point)
            );
            repository.createPoint(rPoint, request.getRequestedSessionId());
            String json = new ObjectMapper().writeValueAsString(point);
            out.println(json);
        } else {
            response.setStatus(400);
            out.println("Error");
        }
    }

    private Point validateInput(HttpServletRequest request) {
        try {
            String xParam = request.getParameter("x");
            String yParam = request.getParameter("y");
            String rParam = request.getParameter("r");
            if (xParam == null || yParam == null || rParam == null) {
                return null;
            }
            double x = Double.parseDouble(xParam);
            double y = Double.parseDouble(yParam);
            double r = Double.parseDouble(rParam);
            if (!((x >= -4) && (x <= 4) &&
                    (y >= -5) && (y <= 5) &&
                    (r >= 1) && (r <= 5))) {
                return null;
            }
            return new Point(x, y, r);
        } catch (NumberFormatException ignored) {
            return null;
        }
    }

    private boolean check(Point point) {
        double x = point.getX();
        double y = point.getY();
        double r = point.getR();
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