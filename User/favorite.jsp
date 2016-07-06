<%@ page language="java" import="cs5530.*" %>
<%
  Connector con = new Connector();
  String pid = request.getParameter("pid");
  String login_name = (String)session.getAttribute("login_name");
  User user = new User();
  out.println(user.declareFavorite(login_name, pid, con.con));
  response.setStatus(response.SC_MOVED_TEMPORARILY);
  response.setHeader("Location", "poi.jsp?pid=" + pid);
%>
