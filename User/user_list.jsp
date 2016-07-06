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
<div class='container'>
  <div class='col-md-6 poi-list'>
    <div class='card-title'><h2>User List</h2></div>
    <div>
      <input type="text" name='nameSearch' id='nameSearch' placeholder="Filter name here" class="form-control poi-search">
    </div>
      <ul class="list-group" id="user-list">
        <%
          Connector con = new Connector();
          User api = new User();
          ArrayList<TreeMap<String, String>> listOfUsers = api.allUsers(con.con);
          for(TreeMap<String, String> user : listOfUsers) {
            %>
              <li class='list-group-item form-table'>
                <p class='name-row'><a href='user.jsp?login=<%=user.get("login_name")%>'> <%=user.get("full_name")%></a></p>
                <p class='detail-row'>Address: <%=user.get("address")%></p>
              </li>
            <%
          }
        %>
      </ul>
    </div>
    <%
    if(session.getAttribute("admin").equals("1")) {
    %>
    <div class='col-md-6 poi-list'>
    <div class='card-title'><h2>User Awards</h2></div>
      <div >
      <div class="dropdown">
        <label>Ranking type:</label> 
        <select name='topType' class='form-control' style="margin-top: 0px; margin-bottom: 10px">
          <option value='trusted' selected>Most Trusted</option>
          <option value='useful'>Most Useful</option>
        </select>
      </div>
      <%
        int ranked_num = 5;
        String num = request.getParameter("num");
        if(num != null) {
          ranked_num = Integer.parseInt(num);
        }
      %>
      <form action="user_list.jsp" style="display:inline-block">
        Number: <input type="number" name='num' class="form-control" id="num" min="0" value = '<%=ranked_num%>'>
        <button class='btn btn-primary show-btn' submit>Show</button>
      </form>
    </div>
      <%
        ArrayList<TreeMap<String, String>> topTrustedUsers = api.topTrustedUsers(ranked_num, con.con);
        ArrayList<TreeMap<String, String>> topUsefulUsers = api.topUsefulUsers(ranked_num, con.con);
      %>
      <div id='trusted'>
      <ul class="list-group">
        <%      
          for(TreeMap<String, String> user : topTrustedUsers) {
            %>
              <li class='list-group-item form-table'>
                <p class='name-row'><a href='user.jsp?login=<%=user.get("login_name")%>'> <%=user.get("full_name")%></a></p>
                <p class='detail-row'>Address: <%=user.get("address")%></p>
                <p class='detail-row'>Trustness: <%=user.get("trustness")%></p>
              </li>
            <%
          }
        %>
      </ul>
    </div>
    <div id='useful' hidden>
      <ul class="list-group">
        <%
          for(TreeMap<String, String> user : topUsefulUsers) {
            %>
              <li class='list-group-item form-table'>
                <p class='name-row'><a href='user.jsp?pid=<%=user.get("login_name")%>'> <%=user.get("full_name")%></a></p>
                <p class='detail-row'>Address: <%=user.get("address")%></p>
                <p class='detail-row'>Average Rating: <%=user.get("avg_rating")%></p>
              </li>
            <%
          }
        %>
      </ul>
    </div>
  </div>
  <% }
  %>
  </div>
  <div class='footer'>
    <div class='footer-text'>
      <p class='copyright'>Chaofeng Zhou - All Rights Reserved.</p>
    </div>
  </div>
  <script type="text/javascript">
    $(document).ready(function() {
      $("select[name='topType']").on('change', function() {
        if ($(this).val() === 'trusted') {
          $("#trusted").show();
          $("#useful").hide();
        } else {
          $("#trusted").hide();
          $("#useful").show();
        }
      });

      $('#user-list li').each(function(){
        $(this).attr('data-search-term', $(this).find(".name-row").text().toLowerCase());
      });

      $("#nameSearch").on('keyup', function(){
        var searchTerm = $(this).val().toLowerCase();
        console.log(searchTerm);
        $('#user-list li').each(function(){
          console.log($(this).attr("data-search-term"));
          if ($(this).filter('[data-search-term *= ' + searchTerm + ']').length > 0 || searchTerm.length < 1) {
              $(this).show();
          } else {
              $(this).hide();
          }
        });
      });
    });
  </script>
</body>
</html>
<%}%>

