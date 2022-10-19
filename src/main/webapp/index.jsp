<%@ page import="ru.ifmo.se.weblab2.model.Repository" %>
<%@ page import="ru.ifmo.se.weblab2.model.ContextRepository" %>
<%@ page import="ru.ifmo.se.weblab2.model.ResultPoint" %>
<%@ page import="java.util.List" %>
<%@ page import="ru.ifmo.se.weblab2.model.ResultPoint" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="java.time.Instant" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.ZoneOffset" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%!
    Repository repository = ContextRepository.getInstance();
    List<ResultPoint> pointsList;
%>
<%!
    String formatDouble(double d) {
        if ((double) ((int) d) == d) {
            return String.valueOf((int) d);
        } else {
            return String.valueOf(d);
        }
    }
%>
<%!
    long getTimeZoneOffset(HttpServletRequest request) {
        if (request.getCookies() != null) {
            Map<String, String> cookieMap =
                    Arrays.stream(request.getCookies())
                            .collect(Collectors.toMap(Cookie::getName, Cookie::getValue));
            if (cookieMap.get("timezoneoffset") != null) {
                long timezoneoffset = -Long.parseLong(cookieMap.get("timezoneoffset")) * 60;
                return timezoneoffset;
            }
        }
        return 0;
    }
%>
<%!
    String getFormattedDate(long milli) {
        Instant dateTime = Instant.ofEpochSecond(milli);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy, HH:mm:ss").withZone(ZoneOffset.UTC);
        return formatter.format(dateTime);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width">
    <title>Title</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<header>
    <div class="header-container">
        <object data="images/hammer.svg" width="50px" height="50px"></object>
        <span>Lebedev Wieceslaw</span>
        <span>P32312</span>
        <span>3310</span>
        <object class="rotate" data="images/star.svg" width="50px" height="50px"></object>
    </div>
</header>
<main>
    <div class="container">
        <div class="panel">
            <div class="graph">
                <svg viewBox="0 0 300 300" class="graph-image">
                    <!-- polygons -->
                    <path d="
                            M 200 150
                            A 50 50, 0, 0, 1, 150 200
                            L 150 150
                        "
                          fill="red"></path>

                    <polygon points="
                        150, 150
                        50, 150,
                        50, 200,
                        150, 200
                        "
                             fill="red"></polygon>

                    <polygon points="
                        150, 50
                        150, 150
                        100, 150
                        "
                             fill="red"></polygon>

                    <!-- axles -->
                    <text class="graph-axle-text" x="285" y="140">x</text>
                    <line class="graph-axle-line" x1="0" x2="295" y1="150" y2="150"></line>
                    <polygon class="graph-axle-arrow" points="299,150 290,155 290,145"></polygon>

                    <text class="graph-axle-text" x="160" y="15">y</text>
                    <line class="graph-axle-line" x1="150" x2="150" y1="5" y2="300"></line>
                    <polygon class="graph-axle-arrow" points="150,1 145,10 155,10"></polygon>

                    <!-- points -->
                    <line class="graph-point" x1="50" x2="50" y1="145" y2="155"></line>
                    <line class="graph-point" x1="100" x2="100" y1="145" y2="155"></line>
                    <line class="graph-point" x1="200" x2="200" y1="145" y2="155"></line>
                    <line class="graph-point" x1="250" x2="250" y1="145" y2="155"></line>

                    <line class="graph-point" x1="145" x2="155" y1="250" y2="250"></line>
                    <line class="graph-point" x1="145" x2="155" y1="200" y2="200"></line>
                    <line class="graph-point" x1="145" x2="155" y1="100" y2="100"></line>
                    <line class="graph-point" x1="145" x2="155" y1="50" y2="50"></line>

                    <!-- labels -->
                    <text class="graph-label r-whole-neg" text-anchor="middle" x="50" y="140">-R</text>
                    <text class="graph-label r-half-neg" text-anchor="middle" x="100" y="140">-R/2</text>
                    <text class="graph-label r-half-pos" text-anchor="middle" x="200" y="140">R/2</text>
                    <text class="graph-label r-whole-pos" text-anchor="middle" x="250" y="140">R</text>

                    <text class="graph-label r-whole-neg" text-anchor="start" x="160" y="255">-R</text>
                    <text class="graph-label r-half-neg" text-anchor="start" x="160" y="205">-R/2</text>
                    <text class="graph-label r-half-pos" text-anchor="start" x="160" y="105">R/2</text>
                    <text class="graph-label r-whole-pos" text-anchor="start" x="160" y="55">R</text>

                    <!-- dashes -->
                    <line class="graph-axle-line graph-x-dash-line" stroke-dasharray="5,5" x1="-10" x2="-10" y1="0" y2="300"></line>
                    <line class="graph-axle-line graph-y-dash-line" stroke-dasharray="5,5" x1="0" x2="300" y1="-10" y2="-10"></line>

                    <%
                        pointsList = repository.getPointsList(request.getRequestedSessionId());
                        for (ResultPoint point: pointsList) {
                            double x = (point.getX() / point.getR()) * 100 + 150;
                            double y = -(point.getY() / point.getR()) * 100 + 150;
                    %>
                        <circle cx="<%=x%>" cy="<%=y%>" r="2"></circle>
                    <%}%>
                </svg>
            </div>
            <form action="change me" method="get" id="graphForm">
                <fieldset class="x form-input">
                    <legend>X</legend>
                    <input type="button" name="x" value="-4">
                    <input type="button" name="x" value="-3">
                    <input type="button" name="x" value="-2">
                    <input type="button" name="x" value="-1">
                    <input type="button" name="x" value="0">
                    <input type="button" name="x" value="1">
                    <input type="button" name="x" value="2">
                    <input type="button" name="x" value="3">
                    <input type="button" name="x" value="4">
                </fieldset>
                <div id="x-error"></div>
                <div class="form-input">
                    <div>
                        <span>Y</span>
                        <input type="text" name="y" id="y" maxlength="6" autocomplete="off"
                               placeholder="(-5...5)" />
                    </div>
                    <div id="y-error"></div>
                </div>
                <fieldset class="r form-input">
                    <legend>R</legend>
                    <input type="button" name="r" value="1">
                    <input type="button" name="r" value="2">
                    <input type="button" name="r" value="3">
                    <input type="button" name="r" value="4">
                    <input type="button" name="r" value="5">
                </fieldset>
                <div id="r-error"></div>
                <p>
                    <input type="submit" value="DAVAI" class="submit-button form-input">
                    <input type="button" value="CLEAR" class="clear-button form-input">
                </p>
            </form>
        </div>
        <div>
            <table id="table">
                <caption>
                    Result table
                </caption>
                <thead>
                <tr>
                    <th>Date and time</th>
                    <th>Delay</th>
                    <th>X</th>
                    <th>Y</th>
                    <th>R</th>
                    <th>Result</th>
                </tr>
                </thead>
                <tbody id="table-body">
                    <% pointsList = repository.getPointsList(request.getRequestedSessionId());
                        long timeZoneOffset = getTimeZoneOffset(request);
                        ResultPoint point;
                        for (int i = pointsList.size() - 1; i >= 0; i--) {
                            point = pointsList.get(i);
                    %>
                    <tr>
                        <td><%= getFormattedDate(point.getDatetime() + timeZoneOffset) %></td>
                        <td><%= point.getDelay()%> mcs</td>
                        <td><%= formatDouble(point.getX()) %></td>
                        <td><%= formatDouble(point.getY()) %></td>
                        <td><%= formatDouble(point.getR()) %></td>
                        <td><%= point.getFormattedResult() %></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</main>
<script src="js/js.cookie.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="js/errors.js"></script>
<script src="js/utils.js"></script>
<script src="js/graph.js"></script>
<script src="js/script.js"></script>
</body>
</html>