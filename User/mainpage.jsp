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
        %>
      <h2 class='detail-title'><%=curr_user.get("full_name")%></h2>
      <div class='form-table'>
        <table>
          <tr>
            <th>Address </th>
            <td><%=curr_user.get("address")%></td>
          </tr>
          <tr>
            <th>Phone number </th>
            <td><%=curr_user.get("phone_num")%></td>
          </tr>
          <tr>
            <th>User type </th>
            <td><%if(session.getAttribute("admin").equals("0")) {
              out.println("Regualr User");
            } else {
              out.println("Admin");
            }
            %>
            </td>
          </tr>
        </table>
      </div>
      <a href='two_degree.jsp' class='btn btn-primary save-profile-btn'>Two Degrees of Separation</a>
      <%
        if(session.getAttribute("admin").equals("1")) {
          %><a href='new_poi.jsp' class='btn btn-primary save-profile-btn' style="margin-left:5px">Create POI</a><%
          %><a href='user_list.jsp' class='btn btn-primary save-profile-btn' style="margin-left:5px">User Awards</a><%
        }
      %>
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
