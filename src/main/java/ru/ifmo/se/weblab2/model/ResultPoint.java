package ru.ifmo.se.weblab2.model;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Objects;

public class ResultPoint {
    private final long datetime;
    private final long delay;
    private final double x;
    private final double y;
    private final double r;
    private final boolean result;

    public ResultPoint(long datetime, long delay, double x, double y, double r, boolean result) {
        this.datetime = datetime;
        this.delay = delay;
        this.x = x;
        this.y = y;
        this.r = r;
        this.result = result;
    }

    public long getDatetime() {
        return datetime;
    }

    public long getDelay() {
        return delay;
    }

    public double getX() {
        return x;
    }

    public double getY() {
        return y;
    }

    public double getR() {
        return r;
    }

    public boolean getResult() {
        return result;
    }

    public String getFormattedResult() {
        return result ? "Hit" : "Miss";
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ResultPoint)) return false;
        ResultPoint that = (ResultPoint) o;
        return datetime == that.datetime && delay == that.delay && Double.compare(that.x, x) == 0 && Double.compare(that.y, y) == 0 && Double.compare(that.r, r) == 0 && result == that.result;
    }

    @Override
    public int hashCode() {
        return Objects.hash(datetime, delay, x, y, r, result);
    }

    @Override
    public String toString() {
        return "ResultPoint{" +
                "date=" + datetime +
                ", delay=" + delay +
                ", x=" + x +
                ", y=" + y +
                ", r=" + r +
                ", result=" + result +
                '}';
    }
}
