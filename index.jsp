<%@ page language="java" import="cs5530.*" %>
<%@ page import="java.util.*" %>
<%
if (session.getAttribute("login_name") != null){
  response.setStatus(response.SC_MOVED_TEMPORARILY);
  response.setHeader("Location", "/~cs5530u113/User/mainpage.jsp");
} else {
%>
<jsp:include page="/common/header.jsp" />
        <ul class='nav navbar-nav navbar-right'>
          <%
            String login_name = request.getParameter("login_name");
            String error = null;
            if(login_name == null){
          %>
          <form class='navbar-form navbar-left' role='login' action='index.jsp' method='post'>
            <div class='form-group'>
              <input type='text' class='nav-form form-control' name='login_name' placeholder='Username' required>
              <input type='password' class='nav-form form-control' name='password' placeholder='Password' required>
            </div>
            <button type='submit' class='btn btn-success nav-signin'> Sign In</button>
            <a class='btn btn-info nav-signup' href='Auth/signup.jsp'> Sign Up</a>
          </form>
          <%
        } else {
              String password = request.getParameter("password");
              Connector con = new Connector();
              User user = new User();
              String[] loginResult = user.loginUser(login_name, password, con.con);
              
              if (loginResult[0] == null) {
                  error = "Authentication Failed.";
          %>
                    <form class='navbar-form navbar-left' role='login' action='index.jsp' method='post'>
            <div class='form-group'>
              <input type='text' class='nav-form form-control' name='login_name' placeholder='Username' required>
              <input type='password' class='nav-form form-control' name='password' placeholder='Password' required>
            </div>
            <button type='submit' class='btn btn-success nav-signin'> Sign In</button>
            <a class='btn btn-info nav-signup' href='Auth/signup.jsp'> Sign Up</a>
          </form>
          <%
              } else {
                  session.setAttribute("login_name", loginResult[0]);
                  session.setAttribute("full_name", loginResult[1]);
                  session.setAttribute("admin", loginResult[2]);
                  session.setAttribute("tmp_visits", new ArrayList<HashMap<String, String>>());
                  response.setStatus(response.SC_MOVED_TEMPORARILY);
                  response.setHeader("Location", "User/mainpage.jsp");
              }
            }
          %>
        </ul>
      </div>
      <!-- /.navbar-collapse -->
    </div>
    <!-- /.container-fluid -->
  </nav>
  <div class='container vertical-center'>
    <%
    if(error != null) {
      out.println("<div class='alert alert-danger' role='alert'><span class='glyphicon glyphicon-exclamation-sign' aria-hidden='true'></span> " + error + "</div>");
    }
    %>
    <div class='jumbotron front_page'>
      <h1>UTrack</h1>
      <p>
        UTracker is a Yelp/TripAdivor/Dianping-like system. The system manages information about POIs (points of interest) of various categories such as restaurants, bookstores, parks, (registered) users and POIs they have visited. It also stores information about user opinions and POI ratings.
      </p>
    </div>
  </div>
  <div class='container'>
    <div class='row index-column'>
      <div class='col-md-4'>
        <h2> POI</h2>
        <p>This system maintians a unique ID for each POI, name, address, URL, telephone number, year of establishment, hours of operation, price (an estimated expected price per person per visit), keywords, category (restaurant, park, bookstore, etc.).</p>
      </div>
      <div class='col-md-4'>
        <h2> User</h2>
        <p>For each registered user, this system maintains: his/her full name, login name, password, address, phone number, POIs he/she has visited and information regarding each visit (such as date, cost as total money spent, and number of persons in the party).</p>
      </div>
      <div class='col-md-4'>
        <h2> Feedback</h2>
        <p>Users can provide "feedback" for a POI, as a score (1-10) along with optional short text. Users can also rate other users' feedback as "useless", "useful", "very useful"; finally, users can declare other users as "trusted" or "not-trusted".</p>
      </div>
    </div>
  </div>
  <div class='index-footer'>
    <div class='footer-text'>
      <p class='copyright'>Chaofeng Zhou - All Rights Reserved.</p>
    </div>
  </div>
</body>

</html>
<%}%>
