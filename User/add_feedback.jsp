<%@ page language="java" import="cs5530.*" %>
<%
  Connector con = new Connector();
  String pid = request.getParameter("pid");
  int score = Integer.parseInt(request.getParameter("score"));
  String text = request.getParameter("comment");
  String login_name = (String)session.getAttribute("login_name");
  User user = new User();
  out.println(user.leaveFeedback(login_name, pid, score, text, con.con));
  response.setStatus(response.SC_MOVED_TEMPORARILY);
  response.setHeader("Location", "poi.jsp?pid=" + pid);
%>
