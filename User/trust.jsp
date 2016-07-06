<%@ page language="java" import="cs5530.*" %>
<%
  Connector con = new Connector();
  String login_name = (String)session.getAttribute("login_name");
  String page_login = request.getParameter("login");
  int trust_or_not = Integer.parseInt(request.getParameter("t"));
  User user = new User();
  out.println(user.declareUserTrustness(login_name, page_login, trust_or_not, con.con));
  response.setStatus(response.SC_MOVED_TEMPORARILY);
  response.setHeader("Location", "user.jsp?login=" + page_login);
%>
