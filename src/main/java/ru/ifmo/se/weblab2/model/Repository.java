package ru.ifmo.se.weblab2.model;

import java.util.List;

public interface Repository {
    void createPoint(ResultPoint point, String sessionId);

    List<ResultPoint> getPointsList(String sessionId);
}
