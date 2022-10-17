<%@ page import="ru.ifmo.se.weblab2.model.Repository" %>
<%@ page import="ru.ifmo.se.weblab2.model.ContextRepository" %>
<%@ page import="ru.ifmo.se.weblab2.model.ResultPoint" %>
<%@ page import="java.util.List" %>
<%@ page import="ru.ifmo.se.weblab2.model.ResultPoint" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="java.time.Instant" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.ZoneOffset" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%!
    Repository repository = ContextRepository.getInstance();
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
    <style>
        @font-face {
            font-family: 'MyFont';
            src: url(fonts/kremlin.ttf) format("truetype");
        }
        * {
            margin: 0%;
            padding: 0%;
            font-family: 'MyFont';
            color: #F8C104;
            font-size: 20px;
        }

        header {
            display: flex;
            justify-content: center;
            background-color: red;
            padding: 10px;
        }

        header * {
            font-family: monospace;
            color: #F8C104;
            font-size: 30px;
        }

        html {
            background-color: #CC0404;
        }

        .panel {
            display: flex;
            justify-content: center;
            flex-direction: row;
            width: 100%;
        }

        .x {
            flex-wrap: wrap;
        }

        form[method="get"] {
            display: flex;
            align-content: space-around;
            flex-direction: column;
            padding: 3%;
        }

        .graph {
            border-width: 2px;
            border-style: solid;
            border-color: black;
            margin: 20px;
            width: 250px;
            height: 250px;
        }

        .graph-image {
            width: 250px;
            height: 250px;
            background-color: #F8C104;
            background-size: cover;
        }

        .graph-image * {
            font-family: monospace;
        }

        table {
            table-layout: fixed;
            width: 100%;
            background-color:rgba(0, 0, 0, 0.5);
        }

        table, th {
            border-width: 3px;
            border-style: solid;
            border-color: #F8C104;
            border-collapse: collapse;
        }

        td {
            padding: 5px;
        }

        tbody td {
            text-align: center;
        }

        thead {
            background: rgb(255, 0, 0);
        }

        .graph-axle-line {
            stroke: black;
        }

        .submit-button {
            width: 128px;
            height: 32px;
        }

        .submit-button:hover {
            background-color: red;
        }

        .error {
            color: red;
            background-color: rgba(0, 0, 0, 0.5);
            border-width: 1px;
            text-indent: 5px;
            padding: .5em 1em;
            width: 100%;
            margin: 5px;
        }

        .graph-point {
            stroke: black;
        }

        .form-input {
            margin: 5px;
            width: 100%;
        }

        .header-container {
            display: flex;
            justify-content: space-between;
            width: 700px;
            align-items: center;
            flex-wrap: wrap;
        }

        .x {
            border-color: #F8C104;
            border-width: 5px;
            padding: 10px;
        }

        .x legend {
            padding-right: 10px;
            padding-left: 10px;
        }

        .x input {
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;

            border-radius: 50%;
            width: 16px;
            height: 16px;

            border: 2px solid #999;
            transition: 0.2s all linear;
            outline: none;
            margin-right: 5px;

            position: relative;
            top: 4px;

            border-color: #F8C104;
        }

        .x input:checked {
            background-color: #f8bf04c0;
        }

        .bounce {
            outline: 0;
            border-color: red;
            animation-name: bounce;
            animation-duration: .5s;
            animation-delay: 0.25s;
        }

        @keyframes bounce {
            0% {
                transform: translateX(0px);
                timing-function: ease-in;
            }
            37% {
                transform: translateX(5px);
                timing-function: ease-out;
            }
            55% {
                transform: translateX(-5px);
                timing-function: ease-in;
            }
            73% {
                transform: translateX(4px);
                timing-function: ease-out;
            }
            82% {
                transform: translateX(-4px);
                timing-function: ease-in;
            }
            91% {
                transform: translateX(2px);
                timing-function: ease-out;
            }
            96% {
                transform: translateX(-2px);
                timing-function: ease-in;
            }
            100% {
                transform: translateX(0px);
                timing-function: ease-in;
            }
        }


    </style>
</head>

<body>
<header>
    <div class="header-container">
        <object data="hammer.svg" width="50px" height="50px"></object>
        <span>Lebedev Wieceslaw</span>
        <span>P32312</span>
        <span>3310</span>
        <object data="star.svg" width="50px" height="50px"></object>
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
                </svg>
            </div>
            <form action="change me" method="get" id="graphForm">
                <fieldset class="x form-input">
                    <legend>X</legend>
                    <label>
                        <span>-5</span>
                        <input type="radio" name="x" value="-5">
                    </label>
                    <label>
                        <span>-4</span>
                        <input type="radio" name="x" value="-4">
                    </label>
                    <label>
                        <span>-3</span>
                        <input type="radio" name="x" value="-3">
                    </label>
                    <label>
                        <span>-2</span>
                        <input type="radio" name="x" value="-2">
                    </label>
                    <label>
                        <span>-1</span>
                        <input type="radio" name="x" value="-1">
                    </label>
                    <label>
                        <span>0</span>
                        <input type="radio" name="x" value="0" checked>
                    </label>
                    <label>
                        <span>1</span>
                        <input type="radio" name="x" value="1">
                    </label>
                    <label>
                        <span>2</span>
                        <input type="radio" name="x" value="2">
                    </label>
                    <label>
                        <span>3</span>
                        <input type="radio" name="x" value="3">
                    </label>
                </fieldset>
                <div class="form-input">
                    <div>
                        <span>Y</span>
                        <input type="text" name="y" id="y" maxlength="6" autocomplete="off"
                               placeholder="(-5...5)" />
                    </div>
                    <div id="error"></div>
                </div>
                <div class="form-input">
                    <span>R</span>
                    <select name="r" id="r">
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                    </select>
                </div>
                <p>
                    <input type="submit" value="DAVAI" class="submit-button form-input">
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
                    <% List<ResultPoint> pointsList = repository.getPointsList(request.getRequestedSessionId());
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
<script src="js/script.js"></script>
</body>
</html>