<%@ page language="java" import="cs5530.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>

<%
if (session.getAttribute("admin") == null){
  response.setStatus(response.SC_MOVED_TEMPORARILY);
  response.setHeader("Location", "/~cs5530u113/index.jsp");
} else {
%>
<jsp:include page="/common/header.jsp" />
<ul class='nav navbar-nav'>
  <li class="active"><a href="mainpage.jsp">Home</a></li>
  <li><a href="poi_list.jsp">POI</a></li>
  <li><a href="user_list.jsp">User</a></li>
   
</ul>
<jsp:include page="/common/navbar.jsp" />
  <div class='container vertical-center'>
    <div class='jumbotron front_page'>
        <%
          Connector con = new Connector();
          String login_name = (String)session.getAttribute("login_name");
          User user = new User();
          String name = request.getParameter("name");
          String address = request.getParameter("address");
          String pid = request.getParameter("pid");
          String total_spending = request.getParameter("total_spending");
          String number_of_persons = request.getParameter("number_of_persons");
          Date date = new Date();

          HashMap<String, String> map = new HashMap<String, String>();
          map.put("login_name", login_name);
          map.put("pid", pid);
          map.put("name", name);
          map.put("address", address);
          map.put("total_spending", total_spending);
          map.put("number_of_persons", number_of_persons);
          map.put("date", date.toString());

          ArrayList<HashMap<String, String>> listOfTmpVisits = (ArrayList<HashMap<String,String>>)session.getAttribute("tmp_visits");
          listOfTmpVisits.add(map);

          ArrayList<TreeMap<String, String>> suggestedPOIs = user.suggestedPOIs(pid, con.con);
        %>
      <h2 class='detail-title'>Suggested POIs Related to <%=name%></h2>
      <table class="table table-striped temp-visits-table">
    <thead>
      <tr>
        <th>POI Name</th>
        <th>Address</th>
        <th>Visted Times</th>
      </tr>
    </thead>
    <tbody>
      <%for(TreeMap<String, String> poi : suggestedPOIs) { %>
      <tr>
        <td><a href="poi.jsp?pid=<%=poi.get("pid")%>"><%=poi.get("name")%></td>
        <td><%=poi.get("address")%></td>
        <td><%=poi.get("visited_times")%></td>
      </tr>
      <%}%>
    </tbody>
  </table>
  <a href='poi.jsp?pid=<%=pid%>' class='btn btn-primary save-profile-btn'> Back to POI </a>
        </div>
      </div>
      </div>
    </div>
    <div class='index-footer'>
      <div class='footer-text'>
        <p class='text-muted copyright'>Chaofeng Zhou - All Rights Reserved.</p>
      </div>
    </div>
  </body>
  </html>
<% } %>
