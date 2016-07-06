<%@ page language="java" import="cs5530.*" %>
<%
  Connector con = new Connector();
  String pid = request.getParameter("pid");
  int fid = Integer.parseInt(request.getParameter("fid"));
  int rating = Integer.parseInt(request.getParameter("rating"));
  String login_name = (String)session.getAttribute("login_name");
  User user = new User();
  out.println(user.rateFeedback(login_name, fid, rating, con.con));
  response.setStatus(response.SC_MOVED_TEMPORARILY);
  response.setHeader("Location", "poi.jsp?pid=" + pid);
%>
