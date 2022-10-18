package ru.ifmo.se.weblab2.controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Objects;

public class ControllerServlet extends HttpServlet {
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String command = request.getParameter("command");
        if (Objects.equals(command, "check")) {
            getServletContext().getRequestDispatcher("/check").forward(request, response);
        } else if (Objects.equals(command, "clear")) {
            getServletContext().getRequestDispatcher("/clear").forward(request, response);
        } else {
            getServletContext().getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}
