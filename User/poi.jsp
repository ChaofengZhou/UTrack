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
  <li class="active"><a href="poi_list.jsp">POI</a></li>
  <li><a href="user_list.jsp">User</a></li>
   
</ul>
 <jsp:include page="/common/navbar.jsp" />
  <div class='container vertical-center'>
    <div class='jumbotron front_page'>
                    <%
          Connector con = new Connector();
          String login_name = (String)session.getAttribute("login_name");
          String pid = request.getParameter("pid");
          User user = new User();
          TreeMap<String, String> poi = user.findPOIbyPid(pid, con.con);
          ArrayList<HashMap<String, String>> listOfTmpVisits = (ArrayList<HashMap<String,String>>)session.getAttribute("tmp_visits");
        %>
      <h2 class='detail-title'><%=poi.get("name")%></h2>
      <div class='form-table'>
        <table>
          <tr>
            <th>Address </th>
            <td><%=poi.get("address")%></td>
          </tr>
          <tr>
            <th>URL </th>
            <td><%=poi.get("url")%></td>
          </tr>
          <tr>
            <th>Phone number </th>
            <td><%=poi.get("tel_num")%></td>
          </tr>
          <tr>
            <th>Category</th>
            <td><%=poi.get("category")%></td>
          </tr>
          <tr>
            <th>Year of Establishment</th>
            <td><%=poi.get("years_of_establish")%></td>
          </tr>
          <tr>
            <th>Hours of Operation</th>
            <td><%=poi.get("hours_of_operation")%></td>
          </tr>
          <tr>
            <th>Price</th>
            <td><%=poi.get("price")%></td>
          </tr>
        </table>
      </div>
      <%
      if(user.checkFavorited(login_name, pid, con.con)) {
        %>
        <a class='btn btn-primary save-profile-btn' disabled>Favorited</a>
      <%
      } else {
      %>
      <a href='favorite.jsp?pid=<%=poi.get("pid")%>' class='btn btn-primary save-profile-btn'>Favorite it!</a>
      <%
      }
        if(session.getAttribute("admin").equals("1")) {
          %>
          <form action='edit_poi.jsp' method=post>
            <input name='pid' value='<%=pid%>' hidden>
            <button type='submit' class='btn btn-warning save-profile-btn' style="margin-top:10px">Edit POI</button>
          </form>
            <%
        }
      %>
      <form method=post action="add_temp_visit.jsp" class="add-visit-form">
        <input name="pid" value="<%=pid%>" hidden> 
        <input name="name" value="<%=poi.get("name")%>" hidden> 
        <input name="address" value="<%=poi.get("address")%>" hidden> 
        <div>
          <input class="form-control visit-form" type='number' name="total_spending" placeholder='Total Spending' step="any" required></input>
          <input class="form-control visit-form" type='number' name="number_of_persons" placeholder='Number of Persons' required></input>
        </div>
        <div>
        <button type=submit class='btn btn-primary submit-feedback-btn'>Add to Temp Visit</button>
        <p style="font-size: 16px; margin: 12px 0 0 0">You have <%=listOfTmpVisits.size()%> temp visits to deal with.</p>
      </div>
      </form>

      <div class="form-group feedback-area" style="margin-bottom:0">
        <%ArrayList<String> list = user.checkLeftFeedback(login_name, pid, con.con);
        if(list != null) {%>
          <p>You have already commented this POI.</p>
        <%} else {%>
        <h3 style="margin-top:5px">Comment:</h3>
        <form method=post action="add_feedback.jsp">
        <input name="pid" value="<%=pid%>" hidden>  
        Score:<select class="form-control feedback-rating" name="score" style="margin-bottom:10px">
              <option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>
              <option>6</option><option>7</option><option>8</option><option>9</option><option>10</option>
            </select>
        <textarea class="form-control" rows="5" name="comment"></textarea>
        <button type=submit class='btn btn-primary submit-feedback-btn'>Submit</button>
      </form>
        <%}%>
      </div>
      </div>
      <div class='jumbotron front_page'>
        <div class='second-title'>Top Useful Feedbacks</div>
        <%
          int ranked_num = 5;
          String num = request.getParameter("num");
          if(num != null) {
            ranked_num = Integer.parseInt(num);
          }
        %>
        <form action="poi.jsp?pid=<%=pid%>" style="margin-left: 20px;margin-bottom: 25px;" method=POST>
          Number: <input type="number" name='num' class="form-control" id="num" min="0" value = '<%=ranked_num%>'>
          <button class='btn btn-primary show-btn' submit>Show</button>
        </form>
        <ul class="list-group feedback-list">
        <%
          ArrayList<TreeMap<String, String>> topFeedbacks = user.topFeedbacks(pid, ranked_num, con.con);
          for(TreeMap<String, String> feedback : topFeedbacks) {
            %>
              <li class='list-group-item form-table feedback-li'>
                <div class='detail-row'>From <a href='user.jsp?login=<%=feedback.get("login_name")%>'><%=feedback.get("full_name")%></a></div>
                <div class='detail-row'><b>Score:</b> <%=feedback.get("score")%></div>
                <div class='detail-row'><b>Content:</b> <%=feedback.get("text")%></div>
                <div class='detail-row'><b>Average usefulness rating:</b> <%=feedback.get("avg_rating")%></div>
                <%
                  String rating = user.checkRatedFeedback(login_name, feedback.get("fid"), con.con);
                  if(rating != null) {
                %>
                  <div class='detail-row' style='margin-top: 12px'><b>Your rate:</b> <%
                    if(rating.equals("0")) {
                    %>Useless<%
                  } else if(rating.equals("1")) {
                    %>Useful<%
                  } else {
                    %>Very useful<%
                  }
                    %></div>
                <%} else {%>
                  <form method=POST action="rate_feedback.jsp" style='margin: 12px 0 5px 0'>
                    <input name="pid" value="<%=pid%>" hidden>  
                    <input name="fid" value='<%=feedback.get("fid")%>' hidden>
                  <%if(feedback.get("login_name").equals(login_name)) {%>
                    <div class='detail-row' style='margin-top: 12px'><i>This is your feedback.</i></div>
                  <%}else {%>
                  <div class='detail-row' style='margin: 12px 0 0 0'><b>Rate it:</b>
                    <select name="rating" class="form-control feedback-rating">
                      <option value='0'>Useless</option><option value='1' selected>Useful</option><option value='2'>Very Useful</option>
                    </select>
                    <button type=submit class='btn btn-primary btn-sm feedback-rating-btn'>Submit</button>
                  </div>
                  </form>
                  <%}%>
                <%}%>
              </li>
            <%
          }
        %>
      </ul>
      </div>
    </div>
    </div>
    <div class='footer'>
      <div class='footer-text'>
        <p class='text-muted copyright'>Chaofeng Zhou - All Rights Reserved.</p>
      </div>
    </div>
  </body>
  </html>
<%}%>
