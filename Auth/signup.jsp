<%@ page language="java" import="cs5530.*" %>
<%@ page import="java.util.*" %>
<jsp:include page="/common/header.jsp" />
<ul class='nav navbar-nav navbar-right'></ul>
    </div>
    <!-- /.navbar-collapse -->
  </div>
  <!-- /.container-fluid -->
</nav>
  <div class='container vertical-center'>
    <%
      String login_name = request.getParameter("login_name");
      if(login_name == null){
    %>
      <div class='card-title form-name'>Register a new user</div>
        <div class='col-md-4'></div>
        <form action='signup.jsp' method='post'>
          <div class='col-md-4'>
            <input type='text' name='login_name' class='signup-form form-control' placeholder='Username' required autofocus>
            <input type='password' name='password' class='signup-form form-control' placeholder='Password' required>
            <!-- <input type='password' name='passwordrp' class='signup-form form-control' placeholder='Repeat Password' pattern='^.{8,}$' required> -->
            <input type='text' name='fullName' class='signup-form form-control' placeholder='Full Name' required>
            <input type='text' name='address' class='signup-form form-control' placeholder='Address'>
            <input type='number' name='phone_num' class='signup-form form-control' placeholder='Phone number'>
            <div class='col-md-6'>
              <input type='radio' name='role' value='0' checked> Regular User 
            </div>
            <div class='col-md-6'>
              <input type='radio' name='role' value='1'> Admin
            </div>
            <div class='col-md-2'></div>
            <div class='col-md-4'>
              <button type='submit' class='btn btn-success signup-btn'> Sign up</button>
            </div>
            <div class='col-md-4'>
              <a class='btn btn-danger cancel-btn' href='../index.jsp'> Cancel</a>
            </div>
            <div class='col-md-2'></div>
          </div>
        </form>
      </div>
      <%
      } else {
        String password = request.getParameter("password");
        String full_name = request.getParameter("fullName");
        String address = request.getParameter("address");
        String phone_num = request.getParameter("phone_num");
        int admin = Integer.parseInt(request.getParameter("role"));
        Connector con = new Connector();
        User user = new User();
        String result = user.createUser(login_name, password, full_name, admin, address, phone_num, con.con);

        if (result.startsWith("login name already exists")) {
          out.println("login name already exists.");
        } else {
          session.setAttribute("login_name", login_name);
          session.setAttribute("full_name", full_name);
          session.setAttribute("admin", admin);
          session.setAttribute("tmp_visits", new ArrayList<HashMap<String, String>>());
          response.setStatus(response.SC_MOVED_TEMPORARILY);
          response.setHeader("Location", "../User/mainpage.jsp");
        }
      }

      %>  
      </div>

    </div><div class='footer'>
      <div class='footer-text'>
        <p class='copyright'>Chaofeng Zhou - All Rights Reserved.</p>
      </div>
    </div>
  </body>
  </html>
