package ru.ifmo.se.weblab2.controller;

import ru.ifmo.se.weblab2.model.ContextRepository;
import ru.ifmo.se.weblab2.model.Repository;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class ClearServlet extends HttpServlet {
    private Repository repository;

    @Override
    public void init() {
        repository = ContextRepository.getInstance();
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) {
        repository.clearPointsList(request.getRequestedSessionId());
    }
}
