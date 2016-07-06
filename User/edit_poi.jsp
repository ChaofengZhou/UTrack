<%@ page language="java" import="cs5530.*" %>
<%@ page import="java.util.*" %>
<%
if (session.getAttribute("login_name") == null || session.getAttribute("admin").equals("0")){
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
        User user = new User();
        String pid = request.getParameter("pid");
        TreeMap<String, String> poi = user.findPOIbyPid(pid, con.con);
        String keywords = poi.get("keywords");
        if(keywords == null) {
          keywords = "";
        }
        String name = request.getParameter("name");
        if(name == null) {
      %>
      <h2 class='detail-title'>Edit POI</h2>
          <form action='edit_poi.jsp' method='post'>
          <div class='form-table'>
          <input name='pid' value='<%=pid%>' hidden>
          <table>
            <tr>
              <th>Name</th>
              <td><input class='form-control' type='text' value='<%=poi.get("name")%>' name='name' required/></td>
              <th>Address</th>
              <td><input class='form-control' type='text' value='<%=poi.get("address")%>' name='address' required/></td>
            </tr>
            <tr>
              <th>URL</th>
              <td><input class='form-control' type='text' value='<%=poi.get("url")%>' name='url'/></td>
              <th>Category</th>
              <td><input class='form-control' type='text' value='<%=poi.get("category")%>' name='category'/></td>
            </tr>
            <tr>
              <th>Phone number</th>
              <td><input class='form-control' type='text' value='<%=poi.get("tel_num")%>' name='tel_num'/></td>
              <th>Price</th>
              <td><input class='form-control' type='number' value='<%=poi.get("price")%>' name='price' step="any"/></td>
            </tr>
            <tr>
              <th>Keyword</th>
              <td><input class='form-control' type='text' value='<%=keywords%>' name='keywords'/></td>
              </tr>
            <tr>
              <th>Year of Establishment</th>
              <td><input class='form-control' type='number' value='<%=poi.get("years_of_establish")%>' name='years_of_establish'/></td>
              <th>Hours of Operation</th>
              <td><input class='form-control' type='text' value='<%=poi.get("hours_of_operation")%>' name='hours_of_operation'/></td>
            </tr>
          </table>
        </div>
        <button type='submit' class='btn btn-primary submit-form-btn'> Update POI </button>
        <a href='poi.jsp?pid=<%=pid%>' class='btn btn-default save-profile-btn'>Cancel</a>
        </form>
      <%
      } else {
          String url = request.getParameter("url");
          double price = 0;
          if(request.getParameter("price") != "") {
            price = Double.parseDouble(request.getParameter("price"));
          }
          pid = request.getParameter("pid");
          name = request.getParameter("name");
          String address = request.getParameter("address");
          String category = request.getParameter("category");
          String phone = request.getParameter("tel_num");
          keywords = request.getParameter("keywords");
          String[] keywordArr = keywords.split(" ");
          int years_of_establish = 0;
          if(request.getParameter("years_of_establish") != "") {
            years_of_establish = Integer.parseInt(request.getParameter("years_of_establish"));
          }
          String hours_of_operation = request.getParameter("hours_of_operation");
          String result = user.updatePOI(pid, name, address, url, phone, category, keywordArr, years_of_establish, hours_of_operation, price, con.con);
          if(result.equals("Updating POI succeeded!")) {
          %> <h2>Updating POI succeeded!</h2>
            <a href='poi.jsp?pid=<%=pid%>' class='btn btn-primary save-profile-btn'> Back to POI </a>
          <%
        }
    }
      %>
    </div>

    <!-- </div> -->
    </div>
    <div class='index-footer'>
      <div class='footer-text'>
        <p class='copyright'>Chaofeng Zhou - All Rights Reserved.</p>
      </div>
    </div>
  </body>
  </html>
<%}%>
