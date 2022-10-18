package ru.ifmo.se.weblab2.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ContextRepository implements Repository {
    private final Map<String, List<ResultPoint>> storage;
    private static ContextRepository instance;

    private ContextRepository() {
        storage = new HashMap<>();
    }

    static public ContextRepository getInstance() {
        if (instance == null) {
            instance = new ContextRepository();
        }
        return instance;
    }

    @Override
    public void createPoint(ResultPoint point, String sessionId) {
        if (storage.get(sessionId) == null) {
            storage.put(sessionId, new ArrayList<>());
        }
        storage.get(sessionId).add(point);
    }

    @Override
    public List<ResultPoint> getPointsList(String sessionId) {
        if (storage.get(sessionId) == null) {
            storage.put(sessionId, new ArrayList<>());
        }
        return storage.get(sessionId);
    }

    @Override
    public void clearPointsList(String sessionId) {
        if (storage.get(sessionId) != null) {
            storage.get(sessionId).clear();
        }
    }
}
