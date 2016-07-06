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
<div class='container'>
  <div class='col-md-6 poi-list' style="padding-right: 40px">
    <div class='card-title'><h2>Search POI</h2></div>
    <% 
      Connector con = new Connector();
      User user = new User();
      if(request.getParameter("keyword") == null) {
    %>
    <div>
      <form action="poi_list.jsp" style='margin-bottom: 10px'>
        <label>Keyword:</label> <input type="text" name='keyword' class="form-control poi-search">
        <label>Address:</label> <input type="text" name='address' class="form-control poi-search">
        <label>Category:</label> <input type="text" name='category' class="form-control poi-search">
        <div class='col-md-6' style="padding: 0 10px 0 0">
          <label>Lowest price:</label> <input type="number" name='lowerPrice' class="form-control" step="any">
        </div>
        <div class='col-md-6' style="padding: 0 0 0 10px">  
          <label>Highest price:</label> <input type="number" name='higherPrice' class="form-control" step="any">
        </div>
        <div class=text-right>
          <button class='btn btn-primary search-btn' submit>Search</button>
        </div>
      </form>
      <div class="search-dropdown" style='margin-bottom: 10px;'>
        <label>Order by:</label> 
        <select name='searchType' class='form-control' style="margin-top: 0">
          <option value='a'>Price</option>
          <option value='b'>Average score from feedbacks</option>
          <option value='c'>Average score from feedbacks of trusted users</option>
        </select>
      </div>
    </div>
    <% 
     } else {
        String keywords = request.getParameter("keyword");
        String[] keywordArr = keywords.split(" ");
        String address = request.getParameter("address");
        String category = request.getParameter("category");
        String lowerPrice = request.getParameter("lowerPrice");
        String higherPrice = request.getParameter("higherPrice");
        String searchType = request.getParameter("searchType");
        String login_name = (String)session.getAttribute("login_name");
        ArrayList<TreeMap<String, String>> searchResultA = user.searchPOI(login_name, lowerPrice, higherPrice, address, keywordArr, category, "a", con.con);
        ArrayList<TreeMap<String, String>> searchResultB = user.searchPOI(login_name, lowerPrice, higherPrice, address, keywordArr, category, "b", con.con);
        ArrayList<TreeMap<String, String>> searchResultC = user.searchPOI(login_name, lowerPrice, higherPrice, address, keywordArr, category, "c", con.con);
      %>
            <div>
      <form action="poi_list.jsp" style='margin-bottom: 10px'>
        <label>Keyword:</label> <input type="text" value='<%=keywords%>' name='keyword' class="form-control poi-search">
        <label>Address:</label> <input type="text" value='<%=address%>' name='address' class="form-control poi-search">
        <label>Category:</label> <input type="text" value='<%=category%>' name='category' class="form-control poi-search">
        <div class='col-md-6' style="padding: 0 10px 0 0">
          <label>Lowest price:</label> <input type="number" value='<%=lowerPrice%>' name='lowerPrice' class="form-control" step="any">
        </div>
        <div class='col-md-6' style="padding: 0 0 0 10px">  
          <label>Highest price:</label> <input type="number" value='<%=higherPrice%>' name='higherPrice' class="form-control" step="any">
        </div>
        <div class=text-right>
          <button class='btn btn-primary search-btn' submit>Search</button>
        </div>
      </form>
      <div class="search-dropdown" style='margin-bottom: 10px;'>
        <label>Order by:</label> 
        <select name='searchType' class='form-control' style="margin-top: 0">
          <option value='a'>Price</option>
          <option value='b'>Average score from feedbacks</option>
          <option value='c'>Average score from feedbacks of trusted users</option>
        </select>
      </div>
    </div>
        <div id='byPrice'><%
        for(TreeMap<String, String> searchedPOI : searchResultA) {
          %>
            <li class='list-group-item form-table'>
              <p class='name-row'><a href='poi.jsp?pid=<%=searchedPOI.get("pid")%>'> <%=searchedPOI.get("name")%></a></p>
              <p class='detail-row'>Address: <%=searchedPOI.get("address")%></p>
              <p class='detail-row'>Price: <%=searchedPOI.get("price")%></p>
            </li>
          <%
        }
        %></div><div id='byFeedback' hidden><%
        for(TreeMap<String, String> searchedPOI : searchResultB) {
          %>
            <li class='list-group-item form-table'>
              <p class='name-row'><a href='poi.jsp?pid=<%=searchedPOI.get("pid")%>'> <%=searchedPOI.get("name")%></a></p>
              <p class='detail-row'>Address: <%=searchedPOI.get("address")%></p>
              <p class='detail-row'>Average Score: <%=searchedPOI.get("avg_score")%></p>
            </li>
          <%
        }
        %></div><div id='byTrustedFeedback' hidden><%
        for(TreeMap<String, String> searchedPOI : searchResultC) {
          %>
            <li class='list-group-item form-table'>
              <p class='name-row'><a href='poi.jsp?pid=<%=searchedPOI.get("pid")%>'> <%=searchedPOI.get("name")%></a></p>
              <p class='detail-row'>Address: <%=searchedPOI.get("address")%></p>
              <p class='detail-row'>Average Score: <%=searchedPOI.get("avg_score")%></p>
            </li>
          <%
        } %></div><%
      }
    %>

  </div>
  <div class='col-md-6 poi-list' hidden>
    <div class='card-title'><h2>POI List</h2></div>
      <ul class="list-group">
        <%
          ArrayList<ArrayList<String>> listOfPOIs = user.allPOIs(con.con);
          for(ArrayList<String> poi : listOfPOIs) {
            %>
              <li class='list-group-item form-table'>
                <p class='name-row'><a href='poi.jsp?pid=<%=poi.get(0)%>'> <%=poi.get(1)%></a></p>
                <p class='detail-row'>Address: <%=poi.get(2)%></p>
              </li>
            <%
          }
        %>
    </ul>
  </div>
  <div class='col-md-6 poi-list'>
    <div class='card-title'><h2>Top POIs</h2></div>
      <div >
      <div class="dropdown">
        <label>Ranking type:</label> 
        <select name='topType' class='form-control' style="margin-top: 0; margin-bottom: 10px">
          <option value='popular' selected>Most Popular</option>
          <option value='expensive'>Most Expensive</option>
          <option value='high-rated'>Most High Rated</option>
        </select>
      </div>
      <%
        int ranked_num = 5;
        String num = request.getParameter("num");
        if(num != null) {
          ranked_num = Integer.parseInt(num);
        }
      %>
      <form action="poi_list.jsp" style="display:inline-block">
        Number: <input type="number" name='num' class="form-control" id="num" min="0" value = '<%=ranked_num%>'>
        <button class='btn btn-primary show-btn' submit>Show</button><span style="margin-left:10px; font-size:14px">Show button will reset the filter below.</span>
      </form>
      <%
        TreeMap<String, ArrayList<TreeMap<String, String>>> topPopuplarPOIs = user.topPopuplarPOIs(ranked_num, con.con);
        TreeMap<String, ArrayList<TreeMap<String, String>>> topExpensivePOIs = user.topExpensivePOIs(ranked_num, con.con);
        TreeMap<String, ArrayList<TreeMap<String, String>>> topHighRatedPOIs = user.topHighRatedPOIs(ranked_num, con.con);
      %>
      <div class="category-dropdown" style="margin-top: 3px; padding-top: 7px; border-top: 1px solid #d0d0d0">
        <label>Category filter:</label> 
        <select name='categoryType' class='form-control' style="margin: 0 0 10px 0">
        <%
          for(String category : topPopuplarPOIs.keySet()) {
          String categoryID = category.replaceAll("\\s+","");
          %><option value='<%=categoryID%>'><%=category%></option><%
        }
        %>
        </select>
      </div>
    </div>
      <div id='popular'>
      <ul class="list-group">
        <%      
          for(Map.Entry<String, ArrayList<TreeMap<String, String>>> entry : topPopuplarPOIs.entrySet()) {
            String category = entry.getKey();
            String categoryID = category.replaceAll("\\s+","");
            ArrayList<TreeMap<String, String>> list = entry.getValue();
            %><div class='<%=categoryID%> cat' hidden><%
            for(TreeMap<String, String> poi : list) {
            %>
              <li class='list-group-item form-table'>
                <p class='name-row'><a href='poi.jsp?pid=<%=poi.get("pid")%>'> <%=poi.get("name")%></a></p>
                <p class='detail-row'>Address: <%=poi.get("address")%></p>
                <p class='detail-row'>Visited Times: <%=poi.get("visited_times")%></p>
              </li>
            <%
          }
          %></br></div><%
        }
        %>
      </ul>
    </div>
    <div id='expensive' hidden>
      <ul class="list-group">
        <%
          for(Map.Entry<String, ArrayList<TreeMap<String, String>>> entry : topExpensivePOIs.entrySet()) {
            String category = entry.getKey();
            String categoryID = category.replaceAll("\\s+","");
            ArrayList<TreeMap<String, String>> list = entry.getValue();
            %><div class='<%=categoryID%> cat' hidden><%
            for(TreeMap<String, String> poi : list) {
            %>
              <li class='list-group-item form-table'>
                <p class='name-row'><a href='poi.jsp?pid=<%=poi.get("pid")%>'> <%=poi.get("name")%></a></p>
                <p class='detail-row'>Address: <%=poi.get("address")%></p>
                <p class='detail-row'>Average Cost: <%=poi.get("avg_cost")%></p>

              </li>
            <%
          }
          %></br></div><%
        }
        %>
      </ul>
    </div>
    <div id='high-rated' hidden>
      <ul class="list-group">
        <%
          for(Map.Entry<String, ArrayList<TreeMap<String, String>>> entry : topHighRatedPOIs.entrySet()) {
            String category = entry.getKey();
            String categoryID = category.replaceAll("\\s+","");
            ArrayList<TreeMap<String, String>> list = entry.getValue();
            %><div class='<%=categoryID%> cat' hidden><%
            for(TreeMap<String, String> poi : list) {
            %>
              <li class='list-group-item form-table'>
                <p class='name-row'><a href='poi.jsp?pid=<%=poi.get("pid")%>'> <%=poi.get("name")%></a></p>
                <p class='detail-row'>Address: <%=poi.get("address")%></p>
                <p class='detail-row'>Average Score: <%=poi.get("avg_score")%></p>
              </li>
            <%
          }
          %></br></div><%
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
  <script type="text/javascript">
    $(document).ready(function() {
      $("select[name='topType']").on('change', function() {
        if ($(this).val() === 'popular') {
          $("#popular").show();
          $("#expensive").hide();
          $("#high-rated").hide();
        } else if ($(this).val() === 'expensive') {
          $("#popular").hide();
          $("#expensive").show();
          $("#high-rated").hide();
        } else {
          $("#popular").hide();
          $("#expensive").hide();
          $("#high-rated").show();
        }
      });
      $("select[name='searchType']").on('change', function() {
        if ($(this).val() === 'byPrice') {
          $("#byPrice").show();
          $("#expensive").hide();
          $("#byTrustedFeedback").hide();
        } else if ($(this).val() === 'byFeedback') {
          $("#byPrice").hide();
          $("#byFeedback").show();
          $("#byTrustedFeedback").hide();
        } else {
          $("#byPrice").hide();
          $("#byFeedback").hide();
          $("#byTrustedFeedback").show();
        }
      });
      $('.' + $("select[name='categoryType']").val()).show();
      $("select[name='categoryType']").on('change', function() {
        $('.cat').hide();
        $('.' + $(this).val()).show();
      });
    });
  </script>
</body>
</html>
<%}%>
