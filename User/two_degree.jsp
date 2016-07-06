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
  <li><a href="mainpage.jsp">Home</a></li>
  <li><a href="poi_list.jsp">POI</a></li>
  <li class="active"><a href="user_list.jsp">User</a></li>
</ul>
<jsp:include page="/common/navbar.jsp" />
  <div class='container vertical-center'>
    <div class='card-title'><h2>Two degrees of separation</h2></div>
    <div class='jumbotron front_page'>
      <form action="two_degree.jsp" style="margin: 10px 0 10px 0;" method=GET>
        <div class='col-md-6'>
          <label>Choose one person</label>
        <select name='firstPerson' class='form-control' style="margin: 0 0 10px 0">
          <option disabled selected>Name / Address</option>
        <%
          Connector con = new Connector();
          String login_name = (String)session.getAttribute("login_name");
          User user = new User();
          ArrayList<TreeMap<String, String>> listOfUsers = user.allUsers(con.con);
          for(TreeMap<String, String> user_ : listOfUsers) {
          %><option value='<%=user_.get("login_name")%>'><%=user_.get("full_name")%> (<b>Address:</b> <%=user_.get("address")%>)</option><%
        }
        %>
        </select>
      </div>
        <div class='col-md-6'>
          <label>Choose the other person</label>
        <select name='secondPerson' class='form-control' style="margin: 0 0 10px 0">
          <option disabled selected>Name / Address</option>
        <%
          for(TreeMap<String, String> user_ : listOfUsers) {
          %><option value='<%=user_.get("login_name")%>'><b>Name:</b> <%=user_.get("full_name")%> (<b>Address:</b> <%=user_.get("address")%>)</option><%
        }
        %>
        </select>
        </div>
        <div class=text-right>
        <button class="btn btn-primary" type='submit' style="margin: 10px 15px 0 0;">Check</button>
        <a href='mainpage.jsp' class='btn btn-default save-profile-btn' style="margin-left:0">Cancel</a>
      </div>
      </form>
      <%
        String firstPerson = request.getParameter("firstPerson");
        String secondPerson = request.getParameter("secondPerson");
        if(firstPerson != null) {
          TreeMap<String, String> firstUser = user.findUserByLogin(firstPerson, con.con);
          TreeMap<String, String> secondUser = user.findUserByLogin(secondPerson, con.con);
          %><div style="margin-left: 15px">
            <p><b><%=firstUser.get("full_name")%></b> <u>address: <%=firstUser.get("address")%></u> and <b><%=secondUser.get("full_name")%></b> <u>address: <%=secondUser.get("address")%></u></p>
          <%
          int degree = user.twoDegreeOfSeparation(firstPerson, secondPerson, con.con);
          if(degree == 2) {
            %><p>are 2-degrees away.</p><%
          } else if (degree == 1){
            %><p>are 1-degree away.</p><%
          } else {
            %><p>are neither 1-degree nor 2-degrees away.</p><%
          }
        }
      %>
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
