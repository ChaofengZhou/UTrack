<ul class='nav navbar-nav navbar-right'>
  <!-- <a class='navbar-text' href='../User/mainpage.jsp'><b><%out.println(session.getAttribute("full_name"));%></b></a> -->
    
    <li class="dropdown">
    <a href="" class="navbar-dropdown" id="nav-dropdown" data-toggle="dropdown"><%out.println(session.getAttribute("full_name"));%> <span class="caret"></span></a>
    <ul class="dropdown-menu">
      <li></li>
      <li><a href="temp_visits.jsp">Temp Visits</a></li>
      <li role="separator" class="divider"></li>
      <li><a href='/~cs5530u113/Auth/logout.jsp' style="color:#c9302c">Logout</a></li>
    </ul>
  </li>
<!-- <form class='navbar-form navbar-left'> -->
  <!--     <li class="dropdown">
    <a href="" class="navbar-dropdown" data-toggle="dropdown"><%out.println(session.getAttribute("full_name"));%></a>
    <ul class="dropdown-menu">
      <li><a href="#">Temp Visits</a></li>
      <li role="separator" class="divider"></li>
      <li><a href='/~cs5530u113/Auth/logout.jsp' style="color:#c9302c">Logout</a></li>
    </ul>
  </li> -->
      <!-- <a type='submit' class='btn btn-danger nav-logout' href='/~cs5530u113/Auth/logout.jsp'>Log out</a> -->
    <!-- </form> -->
  </ul>
    </div>
    <!-- /.navbar-collapse -->
  </div>
  <!-- /.container-fluid -->
</nav>
