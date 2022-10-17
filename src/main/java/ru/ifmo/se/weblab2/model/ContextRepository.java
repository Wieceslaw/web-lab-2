package ru.ifmo.se.weblab2.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ContextRepository implements Repository {
    private Map<String, List<ResultPoint>> context;
    private static ContextRepository instance;

    private ContextRepository() {
        context = new HashMap<String, List<ResultPoint>>();
    }

    static public ContextRepository getInstance() {
        if (instance == null) {
            instance = new ContextRepository();
        }
        return instance;
    }


    @Override
    public void createPoint(ResultPoint point, String sessionId) {
        if (context.get(sessionId) == null) {
            context.put(sessionId, new ArrayList<>());
        }
        context.get(sessionId).add(point);
        System.out.println("Saved!");
    }

    @Override
    public List<ResultPoint> getPointsList(String sessionId) {
        if (context.get(sessionId) == null) {
            context.put(sessionId, new ArrayList<>());
        }
        return (List<ResultPoint>) context.get(sessionId);
    }
}
