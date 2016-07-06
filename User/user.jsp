<%@ page language="java" import="cs5530.*" %>
<%@ page import="java.util.*" %>
<%
if (session.getAttribute("login_name") == null){
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
    <div class='jumbotron front_page'>
              <%
          Connector con = new Connector();
          String login_name = (String)session.getAttribute("login_name");
          String page_login_name = request.getParameter("login");
          User user = new User();
          TreeMap<String, String> curr_user = user.findUserByLogin(page_login_name, con.con);
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
        </table>
      </div>
      <%
        String trust_result = user.checkTrusted(login_name, page_login_name, con.con);
        if(trust_result == null) {
      %>
        <a href='trust.jsp?login=<%=page_login_name%>&t=1' class='btn btn-primary save-profile-btn'>Trust this user</a>
        <a href='trust.jsp?login=<%=page_login_name%>&t=-1' class='btn btn-warning save-profile-btn'>Distrust this user</a>
      <%
        } else if (trust_result.equals("-1")) {
      %>
        <a class='btn btn-primary save-profile-btn' disabled>Distrusted</a>
      <%
        } else { 
      %>
        <a class='btn btn-primary save-profile-btn' disabled>Trusted</a>
      <%
        }
      %>
      </div>

    <!-- </div> -->
    </div>
    <div class='footer'>
      <div class='footer-text'>
        <p class='copyright'>Chaofeng Zhou - All Rights Reserved.</p>
      </div>
    </div>
  </body>
  </html>
<%}%>
