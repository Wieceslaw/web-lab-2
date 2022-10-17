package ru.ifmo.se.weblab2.controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ControllerServlet extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String x = request.getParameter("x");
        String y = request.getParameter("y");
        String r = request.getParameter("r");
        if (x != null && y != null && r != null ) {
            getServletContext().getRequestDispatcher("/check").forward(request, response);
        } else {
            getServletContext().getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}
