<%@ page language="java" import="cs5530.*" %>
<%@ page import="java.util.*" %>
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
          TreeMap<String, String> curr_user = user.findUserByLogin(login_name, con.con);
          ArrayList<HashMap<String, String>> listOfTmpVisits = (ArrayList<HashMap<String,String>>)session.getAttribute("tmp_visits");
        if(request.getParameter("add_temp") == null) {
        %>
      <h2 class='detail-title'>Temp Visits</h2>
      <table class="table table-striped temp-visits-table">
    <thead>
      <tr>
        <th>POI Name</th>
        <th>Address</th>
        <th>Total Spending</th>
        <th>Number of Persons</th>
        <th>Date</th>
      </tr>
    </thead>
    <tbody>
      <%for(HashMap<String, String> visit : listOfTmpVisits) { %>
      <tr>
        <td><%=visit.get("name")%></td>
        <td><%=visit.get("address")%></td>
        <td><%=visit.get("total_spending")%></td>
        <td><%=visit.get("number_of_persons")%></td>
        <td><%=visit.get("date")%></td>
      </tr>
      <%}%>
    </tbody>
  </table>
  <form action='temp_visits.jsp' method='post'>
    <input name="add_temp" hidden>
    <button type=submit class='btn btn-primary save-profile-btn'>Confirm</button>
    <a href='mainpage.jsp' class='btn btn-default save-profile-btn' style="margin-left:0">Cancel</a>
  </form>

  <%} else {
      for(HashMap<String, String> visit : listOfTmpVisits) {
        user.addVisit(visit.get("login_name"), visit.get("pid"), Double.parseDouble(visit.get("total_spending")), Integer.parseInt(visit.get("number_of_persons")), con.con);
      }
      listOfTmpVisits.clear();
    %> <h2>Confirming temp visits succeeded!</h2>
      <a href='mainpage.jsp' class='btn btn-primary save-profile-btn'> Back to Home Page </a>
    <%
} %>
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
