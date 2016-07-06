package cs5530;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.TreeMap;
import java.util.Map;

public class User {
  public User() {
  }

  public String createUser(String login_name, String password, String full_name, int admin, String address,
      String phone_num, Connection con) {
    ResultSet rs = null;
    String output = "";
    try {
      String sql = "select * from User where login_name = ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, login_name);

      rs = stmt.executeQuery();
      while (rs.next()) {
        output = rs.getString("login_name");
      }
      if (output != "") {
        output = "login name already exists.";
      } else {
        sql = "insert into User (login_name, password, full_name, admin, address, phone_num) values (?, ?, ?, ?, ?, ?)";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, login_name);
        stmt.setString(2, password);
        stmt.setString(3, full_name);
        stmt.setInt(4, admin);
        stmt.setString(5, address);
        stmt.setString(6, phone_num);

        output = "";
        int rows = stmt.executeUpdate();
        output = "Creating user succeeded!";
      }
      rs.close();
    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    } finally {
      try {
        if (rs != null && !rs.isClosed())
          rs.close();
      } catch (Exception e) {
        System.out.println("cannot close resultset");
      }
    }
    return output;
  }

  public String[] loginUser(String login_name, String password, Connection con) {
    ResultSet rs = null;
    String[] result = new String[3];
    try {
      String sql = "select * from User where login_name = ? and password = ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, login_name);
      stmt.setString(2, password);

      rs = stmt.executeQuery();
      while (rs.next()) {
        result[0] = rs.getString("login_name");
        result[1] = rs.getString("full_name");
        result[2] = rs.getString("admin");
      }

    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    } finally {
      try {
        if (rs != null && !rs.isClosed())
          rs.close();
      } catch (Exception e) {
        System.out.println("cannot close resultset");
      }
    }
    return result;
  }

  public String findFeedbackbyFid(int fid_int, Connection con) {
    ResultSet rs = null;
    String output = "";
    try {
      String sql = "select * from Feedback where fid = ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setInt(1, fid_int);

      rs = stmt.executeQuery();
      ArrayList<String> poiList = new ArrayList<String>();
      String fid = "";
      while (rs.next()) {
        poiList.add("\nFID: " + rs.getString("fid"));
        fid = rs.getString("fid");
      }
      if (poiList.size() == 0) {
        return "FID does not exists.";
      } else if (poiList.size() == 1) {
        return fid;
      }
    } catch (Exception e) {
      System.out.println("cannot execute the query!!!. " + e.getMessage());
    } finally {
      try {
        if (rs != null && !rs.isClosed())
          rs.close();
      } catch (Exception e) {
        System.out.println("cannot close resultset");
      }
    }
    return output;
  }

  // public TreeMap<String, String> findUserbyName(String name, Connection con) {
  //   ResultSet rs = null;
  //   TreeMap<String, String> pid_POI = new TreeMap<String, String>();
  //   try {
  //     name = '%' + name + '%';
  //     String sql = "select * from User where full_name like ?";
  //     PreparedStatement stmt = con.prepareStatement(sql);
  //     stmt.setString(1, name);
  //     rs = stmt.executeQuery();
  //     while (rs.next()) {
  //       pid_POI.put(rs.getString("login_name"), "Address: " + rs.getString("address"));
  //     }
  //   } catch (Exception e) {
  //     System.out.println("cannot execute the query. " + e.getMessage());
  //   } finally {
  //     try {
  //       if (rs != null && !rs.isClosed())
  //         rs.close();
  //     } catch (Exception e) {
  //       System.out.println("cannot close resultset");
  //     }
  //   }
  //   return pid_POI;
  // }

  // public TreeMap<Integer, String> findPOIbyName(String pname, Connection con) {
  //   ResultSet rs = null;
  //   TreeMap<Integer, String> pid_POI = new TreeMap<Integer, String>();
  //   try {
  //     String sql = "select * from POI where name = ?";
  //     PreparedStatement stmt = con.prepareStatement(sql);
  //     stmt.setString(1, pname);
  //     rs = stmt.executeQuery();
  //     while (rs.next()) {
  //       pid_POI.put(rs.getInt("pid"), "Address: " + rs.getString("address"));
  //     }

  //   } catch (Exception e) {
  //     System.out.println("cannot execute the query. " + e.getMessage());
  //   } finally {
  //     try {
  //       if (rs != null && !rs.isClosed())
  //         rs.close();
  //     } catch (Exception e) {
  //       System.out.println("cannot close resultset");
  //     }
  //   }
  //   return pid_POI;
  // }

  public String addVisit(String login_name, String pid, double total_spending, int number_of_persons,
      Connection con) {
    ResultSet rs = null;
    String output = "";
    try {
      String sql = "insert into Visits (login_name, pid) values (?, ?)";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, login_name);
      stmt.setString(2, pid);
      int rows = stmt.executeUpdate();
      if (rows == 0) {
        throw new SQLException("Adding visit failed.");
      }
      int visit_id;
      try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
        if (generatedKeys.next()) {
          visit_id = generatedKeys.getInt(1);
        } else {
          throw new SQLException("Adding visit failed.");
        }
      }
      Date currentDatetime = new Date(System.currentTimeMillis());
      java.sql.Date sqlDate = new java.sql.Date(currentDatetime.getTime());
      
      sql = "insert into Visit_event (visit_id, date, total_spending, number_of_persons) values (?, ?, ?, ?)";
      stmt = con.prepareStatement(sql);
      stmt.setInt(1, visit_id);
      stmt.setDate(2, sqlDate);
      stmt.setDouble(3, total_spending);
      stmt.setInt(4, number_of_persons);
      rows = stmt.executeUpdate();

      output = "Adding visit succeeded!";
      rs.close();

    } catch (Exception e) {

    } finally {
      try {
        if (rs != null && !rs.isClosed())
          rs.close();
      } catch (Exception e) {
        System.out.println("cannot close resultset");
      }
    }
    return output;
  }

  public boolean checkFavorited(String login_name, String pid, Connection con) {
    ResultSet rs = null;
    try {
      String sql = "select * from Favorites where login_name = ? and pid = ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, login_name);
      stmt.setString(2, pid);

      rs = stmt.executeQuery();
      while (rs.next()) {
        return true;
      }
    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    return false;
  }

  public String declareFavorite(String login_name, String pid, Connection con) {
    String output = "";
    ResultSet rs = null;
    try {
      String sql = "select * from Favorites where login_name = ? and pid = ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, login_name);
      stmt.setString(2, pid);

      rs = stmt.executeQuery();
      while (rs.next()) {
        output = rs.getString("login_name");
      }
      if (output != "") {
        output = "You have already favorited this place. Please try another place.";
      } else {
        Date currentDatetime = new Date(System.currentTimeMillis());
        java.sql.Date sqlDate = new java.sql.Date(currentDatetime.getTime());

        sql = "INSERT INTO Favorites (login_name, pid, date) VALUES (?, ?, ?)";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, login_name);
        stmt.setString(2, pid);
        stmt.setDate(3, sqlDate);

        output = "";
        stmt.executeUpdate();
        output = "Adding favorite POI succeeded!";
      }
    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    return output;
  }

  public ArrayList<String> checkLeftFeedback(String login_name, String pid, Connection con) {
    ResultSet rs = null;
    ArrayList<String> list = new ArrayList<String>();
    try {
      String sql = "select * from Feedback where login_name = ? and pid = ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, login_name);
      stmt.setString(2, pid);

      rs = stmt.executeQuery();
      while (rs.next()) {
        list.add(rs.getString("score"));
        list.add(rs.getString("text"));
        return list;
      }
    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    return null;
  }

  public String leaveFeedback(String login_name, String pid, int score_int, String text, Connection con) {
    String output = "";
    ResultSet rs = null;
    try {
      String sql = "select * from Feedback where login_name = ? and pid = ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, login_name);
      stmt.setString(2, pid);

      rs = stmt.executeQuery();
      while (rs.next()) {
        output = rs.getString("login_name");
      }
      if (output != "") {
        output = "You have already left feedback for this place. Please try another place.";
      } else {
        sql = "INSERT INTO Feedback (login_name, pid, score, text) VALUES (?, ?, ?, ?)";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, login_name);
        stmt.setString(2, pid);
        stmt.setInt(3, score_int);
        stmt.setString(4, text);

        output = "";
        stmt.executeUpdate();
        output = "Adding feedback succeeded!";
      }
    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    return output;
  }

  public String checkRatedFeedback(String login_name, String fid_int, Connection con) {
    ResultSet rs = null;
    try {
      String sql = "select * from Rate_feedback where login_name = ? and fid = ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, login_name);
      stmt.setString(2, fid_int);

      rs = stmt.executeQuery();
      while (rs.next()) {
        return rs.getString("rating");
      }
    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    return null;
  }

  public String rateFeedback(String login_name, int fid_int, int rating_int, Connection con) {
    String output = "";
    ResultSet rs = null;
    try {
      String sql = "select * from Feedback where login_name = ? and fid = ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, login_name);
      stmt.setInt(2, fid_int);

      rs = stmt.executeQuery();
      while (rs.next()) {
        output = rs.getString("login_name");
      }
      if (output != "") {
        output = "You cannot rate your own feedback to the POI.";
      } else {
        sql = "INSERT INTO Rate_feedback (login_name, fid, rating) VALUES (?, ?, ?)";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, login_name);
        stmt.setInt(2, fid_int);
        stmt.setInt(3, rating_int);

        output = "";
        stmt.executeUpdate();
        output = "Rating feedback succeeded!";
      }
    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    return output;
  }

  public String checkTrusted(String login_name, String trustee_login, Connection con) {
    ResultSet rs = null;
    try {
      String sql = "select * from Trusts where truster_login = ? and trustee_login = ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, login_name);
      stmt.setString(2, trustee_login);

      rs = stmt.executeQuery();
      while (rs.next()) {
        return rs.getString("trust_or_not");
      }
      
    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    return null;
  }

  public String declareUserTrustness(String login_name, String trustee_login, int trust_or_not_int, Connection con) {
    String output = "";
    ResultSet rs = null;
    try {
      String sql = "select * from Trusts where truster_login = ? and trustee_login = ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, login_name);
      stmt.setString(2, trustee_login);

      rs = stmt.executeQuery();
      while (rs.next()) {
        output = rs.getString("truster_login");
      }
      if (output != "") {
        output = "You have already declared trustness to this user. Please try another user.";
      } else {
        sql = "INSERT INTO Trusts (truster_login, trustee_login, trust_or_not) VALUES (?, ?, ?)";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, login_name);
        stmt.setString(2, trustee_login);
        stmt.setInt(3, trust_or_not_int);

        output = "";
        stmt.executeUpdate();
        output = "Declaring user trustness succeeded!";
      }
    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    return output;
  }

  public ArrayList<String> topPOIs__(int m, Connection con) {
    String output = "";
    ResultSet rs;
    ArrayList<String> outputs = new ArrayList<String>();
    try {
      String sql = "select distinct category from POI";
      PreparedStatement stmt = con.prepareStatement(sql);
      rs = stmt.executeQuery();
      ArrayList<String> categories = new ArrayList<String>();
      while (rs.next()) {
        categories.add(rs.getString("category"));
      }

      outputs.add("Here is the top m popular POIs in each category:");
      for (String category : categories) {
        sql = "select P.name, count(*) as visited_times From POI P left join Visits V on P.pid = V.pid where P.category = ? Group by P.pid order by visited_times DESC LIMIT ?";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, category);
        stmt.setInt(2, m);

        rs = stmt.executeQuery();
        output = category + ":\n";
        while (rs.next()) {
          output += "POI name: " + rs.getString("name") + ", Visited Times: " + rs.getString("visited_times")
              + '\n';
        }
        outputs.add(output);
      }

    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    return outputs;
  }

  public int twoDegreeOfSeparation(String login1, String login2, Connection con) {
    ResultSet rs = null;
    try {
      String sql = "select distinct U.login_name from User U, Favorites F where F.login_name = U.login_name and F.pid in (select distinct F1.pid from Favorites F1 where F1.login_name = ?);";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, login1);

      HashSet<String> oneDegreeOfLogin1 = new HashSet<String>();
      rs = stmt.executeQuery();
      while (rs.next()) {
        oneDegreeOfLogin1.add(rs.getString("login_name"));
      }
      rs.close();

      rs = null;
      sql = "select distinct U.login_name from User U, Favorites F where F.login_name = U.login_name and F.pid in (select distinct F1.pid from Favorites F1 where F1.login_name = ?);";
      stmt = con.prepareStatement(sql);
      stmt.setString(1, login2);

      HashSet<String> oneDegreeOfLogin2 = new HashSet<String>();
      rs = stmt.executeQuery();
      while (rs.next()) {
        oneDegreeOfLogin2.add(rs.getString("login_name"));
      }
      rs.close();
      if (oneDegreeOfLogin1.contains(login2) && oneDegreeOfLogin1.contains(login1)) {
        return 1;
      }
      oneDegreeOfLogin1.retainAll(oneDegreeOfLogin2);
      if(oneDegreeOfLogin1.size() > 0) {
        return 2;
      }
    } catch (Exception e) {
      System.out.println("cannot execute the query " + e.getMessage());
    } finally {
      try {
        if (rs != null && !rs.isClosed())
          rs.close();
      } catch (Exception e) {
        System.out.println("cannot close resultset");
      }
    }
    return 0;
  }

  public ArrayList<TreeMap<String, String>> topTrustedUsers(int m_int, Connection con) {
    ArrayList<TreeMap<String, String>> result = new ArrayList<TreeMap<String, String>>();
    ResultSet rs;
    try {
      String sql = "select U.login_name, U.full_name, U.address, CASE WHEN sum(T.trust_or_not)"
          + " IS NULL THEN 0 ELSE sum(T.trust_or_not) END AS trustness From User U Left join Trusts T on U.login_name = T.trustee_login group by U.login_name order by trustness desc limit ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setInt(1, m_int);
      rs = stmt.executeQuery();
      ResultSetMetaData meta = rs.getMetaData();
      while (rs.next()) {
        TreeMap<String, String> map = new TreeMap<String, String>();
        for (int i = 1; i <= meta.getColumnCount(); i++) {
          String key = meta.getColumnName(i);
          String value = rs.getString(key);
          map.put(key, value);
        }
        result.add(map);
      }
    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    return result;
  }

  public ArrayList<TreeMap<String, String>> topUsefulUsers(int m_int, Connection con) {
    ArrayList<TreeMap<String, String>> result = new ArrayList<TreeMap<String, String>>();
    ResultSet rs;
    try {
      String sql = "select U.login_name, U.full_name, U.address, ifnull(avg(R.rating), 0) as avg_rating from User U left join Rate_feedback R on U.login_name = R.login_name group by U.login_name order by avg_rating desc LIMIT ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setInt(1, m_int);
      rs = stmt.executeQuery();
      ResultSetMetaData meta = rs.getMetaData();
      while (rs.next()) {
        TreeMap<String, String> map = new TreeMap<String, String>();
        for (int i = 1; i <= meta.getColumnCount(); i++) {
          String key = meta.getColumnName(i);
          String value = rs.getString(key);
          map.put(key, value);
        }
        result.add(map);
      }
    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    return result;
  }

  public String topUsers(int m_int, Connection con) {
    String output = "";
    ResultSet rs;
    try {
      String sql = "select U.full_name, CASE WHEN sum(T.trust_or_not)"
          + " IS NULL THEN 0 ELSE sum(T.trust_or_not) END AS trustness From User U Left join Trusts T on U.login_name = T.trustee_login group by U.login_name order by trustness desc limit ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setInt(1, m_int);
      rs = stmt.executeQuery();

      output += "Here are the top m most trusted users:\n";
      while (rs.next()) {
        output += "User name: " + rs.getString("full_name") + "    Count of trusts: " + rs.getInt("trustness")
            + "\n";
      }

      sql = "select U.full_name, ifnull(avg(R.rating), 0) as avg_rating from User U left join Rate_feedback R on U.login_name = R.login_name group by U.login_name order by avg_rating desc LIMIT ?";
      stmt = con.prepareStatement(sql);
      stmt.setInt(1, m_int);
      rs = stmt.executeQuery();

      output += "\nHere are the top m most useful users:\n";
      while (rs.next()) {
        output += "User name: " + rs.getString("full_name") + "    Average rating of feedback: "
            + rs.getDouble("avg_rating") + "\n";
      }

    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    return output;
  }

  public String createPOI(String name, String address, String url, String category, String[] keywords, String tel_num,
      int years_of_establishment_int, String hours_of_operation, double price_double, Connection con) {
    String output = "";

    try {
      String sql = "insert into POI (name, address, url, category, tel_num, years_of_establish, hours_of_operation, price) values (?, ?, ?, ?, ?, ?, ?, ?)";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, name);
      stmt.setString(2, address);
      stmt.setString(3, url);
      stmt.setString(4, category);
      stmt.setString(5, tel_num);
      stmt.setInt(6, years_of_establishment_int);
      stmt.setString(7, hours_of_operation);
      stmt.setDouble(8, price_double);

      stmt.executeUpdate();

      int pid;
      try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
        if (generatedKeys.next()) {
          pid = generatedKeys.getInt(1);
          output = pid + "";
        } else {
          throw new SQLException("Adding keyword failed.");
        }
      }
      linkKeywords(pid + "", keywords, con);
    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    
    return output;
  }

  public void linkKeywords(String pid, String[] keywords, Connection con) {
    ResultSet rs = null;
    String output = "";
    try {
      for (String keyword : keywords) {
        String sql = "select * from Keyword where word = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, keyword);

        rs = stmt.executeQuery();
        while (rs.next()) {
          output = rs.getString("wid");
        }
        if (output != "") {
          sql = "insert into Has_keyword (pid, wid) values (?, ?)";
          stmt = con.prepareStatement(sql);
          stmt.setString(1, pid);
          stmt.setString(2, output);
          stmt.executeUpdate();
        } else {
          sql = "insert into Keyword (word) values (?)";
          stmt = con.prepareStatement(sql);
          stmt.setString(1, keyword);
          stmt.executeUpdate();

          int wid;
          try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
            if (generatedKeys.next()) {
              wid = generatedKeys.getInt(1);
            } else {
              throw new SQLException("Adding keyword failed.");
            }
          }
          sql = "insert into Has_keyword (pid, wid) values (?, ?)";
          stmt = con.prepareStatement(sql);
          stmt.setString(1, pid);
          stmt.setInt(2, wid);
          stmt.executeUpdate();
        }
      }
    } catch (Exception e) {
    }
  }

  public String updatePOI(String pid, String name, String address, String url, String tel_num, String category,
      String[] keywords, int years_of_establishment_int, String hours_of_operation, double price_double,
      Connection con) {
    String output = "";
    try {
      String sql = "UPDATE POI SET name = ?, address = ?, url = ?, category = ?, tel_num = ?, years_of_establish = ?, hours_of_operation = ?, price = ? WHERE pid = ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, name);
      stmt.setString(2, address);
      stmt.setString(3, url);
      stmt.setString(4, category);
      stmt.setString(5, tel_num);
      stmt.setInt(6, years_of_establishment_int);
      stmt.setString(7, hours_of_operation);
      stmt.setDouble(8, price_double);
      stmt.setString(9, pid);

      output = "";
      stmt.executeUpdate();
      linkKeywords(pid, keywords, con);
      
    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    output = "Updating POI succeeded!";
    return output;
  }

  public ArrayList<TreeMap<String, String>> topFeedbacks(String pid, int n_int, Connection con) {
    ArrayList<TreeMap<String, String>> result = new ArrayList<TreeMap<String, String>>();
    ResultSet rs = null;
    try {
      String sql = "select U.login_name, U.full_name, F.fid, F.score, F.text, ifnull(avg(R.rating), 0) as avg_rating From POI P left join Feedback F on P.pid = F.pid left join Rate_feedback R on F.fid = R.fid, User U where U.login_name = F.login_name and P.pid = ? group by F.fid LIMIT ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, pid);
      stmt.setInt(2, n_int);
      
      rs = stmt.executeQuery();
      ResultSetMetaData meta = rs.getMetaData();
      while (rs.next()) {
        TreeMap<String, String> map = new TreeMap<String, String>();
        for (int i = 1; i <= meta.getColumnCount(); i++) {
          String key = meta.getColumnName(i);
          String value = rs.getString(key);
          map.put(key, value);
        }
        result.add(map);
      }
      rs.close();
    } catch (Exception e) {
      System.out.println("cannot execute the query " + e.getMessage());
    } finally {
      try {
        if (rs != null && !rs.isClosed())
          rs.close();
      } catch (Exception e) {
        System.out.println("cannot close resultset");
      }
    }
    return result;
  }

  // public String topFeedbacks(String pid, int n_int, Connection con) {
  //   String output = "";
  //   ResultSet rs = null;
  //   try {
  //     String sql = "select F.text, ifnull(avg(R.rating), 0) as avg_rating From POI P left join Feedback F on P.pid = F.pid left join Rate_feedback R on F.fid = R.fid where P.pid = ? group by F.fid LIMIT ?";
  //     PreparedStatement stmt = con.prepareStatement(sql);
  //     stmt.setString(1, pid);
  //     stmt.setInt(2, n_int);

  //     rs = stmt.executeQuery();
  //     while (rs.next()) {
  //       output += "Feedback content: " + rs.getString("text") + "    Average Rating: " + rs.getDouble("avg_rating")
  //           + "\n";
  //     }
  //     rs.close();
  //   } catch (Exception e) {
  //     System.out.println("cannot execute the query " + e.getMessage());
  //   } finally {
  //     try {
  //       if (rs != null && !rs.isClosed())
  //         rs.close();
  //     } catch (Exception e) {
  //       System.out.println("cannot close resultset");
  //     }
  //   }
  //   return output;
  // }

  public ArrayList<TreeMap<String, String>>  suggestedPOIs(String pid, Connection con) {
    ArrayList<TreeMap<String, String>> result = new ArrayList<TreeMap<String, String>>();
    ResultSet rs = null;
    try {
      String sql = "select P.pid, P.name, P.address, count(*) as visited_times From POI P, Visits V where P.pid = V.pid and P.pid != ? and V.login_name in (select distinct V1.login_name from Visits V1 where V1.pid = ?) group by P.pid order by visited_times desc";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, pid);
      stmt.setString(2, pid);
      rs = stmt.executeQuery();
      ResultSetMetaData meta = rs.getMetaData();
      while (rs.next()) {
        TreeMap<String, String> map = new TreeMap<String, String>();
        for (int i = 1; i <= meta.getColumnCount(); i++) {
          String key = meta.getColumnName(i);
          String value = rs.getString(key);
          map.put(key, value);
        }
        result.add(map);
      }
      rs.close();
    } catch (Exception e) {
      System.out.println("cannot execute the query " + e.getMessage());
    } finally {
      try {
        if (rs != null && !rs.isClosed())
          rs.close();
      } catch (Exception e) {
        System.out.println("cannot close resultset");
      }
    }
    return result;
  }

  public ArrayList<ArrayList<String>> allPOIs(Connection con) {
    ResultSet rs = null;
    ArrayList<ArrayList<String>> listOfPOIs = new ArrayList<ArrayList<String>>();
    try {
      String sql = "select * from POI order by name";
      PreparedStatement stmt = con.prepareStatement(sql);
      rs = stmt.executeQuery();
      while (rs.next()) {
        ArrayList<String> arr = new ArrayList<String>();
        arr.add(rs.getString("pid"));
        arr.add(rs.getString("name"));
        arr.add(rs.getString("address"));
        listOfPOIs.add(arr);
      }
      rs.close();
    } catch (Exception e) {
      System.out.println("cannot execute the query " + e.getMessage());
    } finally {
      try {
        if (rs != null && !rs.isClosed())
          rs.close();
      } catch (Exception e) {
        System.out.println("cannot close resultset");
      }
    }
    return listOfPOIs;
  }

  public ArrayList<TreeMap<String, String>> listFeedbackOfPOI(String pid, Connection con) {
    ResultSet rs = null;
    ArrayList<TreeMap<String, String>> listOfFeedback = new ArrayList<TreeMap<String, String>>();
    try {
      String sql = "select * from Feedback where pid = ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, pid);
      rs = stmt.executeQuery();
      ResultSetMetaData meta = rs.getMetaData();
      while (rs.next()) {
        TreeMap<String, String> map = new TreeMap<String, String>();
        for (int i = 1; i <= meta.getColumnCount(); i++) {
          String key = meta.getColumnName(i);
          String value = rs.getString(key);
          map.put(key, value);
        }
        listOfFeedback.add(map);
      }
      rs.close();
    } catch (Exception e) {
      System.out.println("cannot execute the query " + e.getMessage());
    } finally {
      try {
        if (rs != null && !rs.isClosed())
          rs.close();
      } catch (Exception e) {
        System.out.println("cannot close resultset");
      }
    }
    return listOfFeedback;
  }

  public TreeMap<String, String> findUserByLogin(String login, Connection con) {
    ResultSet rs = null;
    TreeMap<String, String> map = new TreeMap<String, String>();
    try {
      String sql = "select * from User where login_name = ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, login);
      rs = stmt.executeQuery();
      ResultSetMetaData meta = rs.getMetaData();
      while (rs.next()) {
        for (int i = 1; i <= meta.getColumnCount(); i++) {
          String key = meta.getColumnName(i);
          String value = rs.getString(key);
          map.put(key, value);
        }
      }
      rs.close();
    } catch (Exception e) {
      System.out.println("cannot execute the query " + e.getMessage());
    } finally {
      try {
        if (rs != null && !rs.isClosed())
          rs.close();
      } catch (Exception e) {
        System.out.println("cannot close resultset");
      }
    }
    return map;
  }

  public TreeMap<String, String> findPOIbyPid(String pid, Connection con) {
    ResultSet rs = null;
    TreeMap<String, String> map = new TreeMap<String, String>();
    try {
      String sql = "select * from POI where pid = ?";
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, pid);
      rs = stmt.executeQuery();
      ResultSetMetaData meta = rs.getMetaData();
      while (rs.next()) {
        for (int i = 1; i <= meta.getColumnCount(); i++) {
          String key = meta.getColumnName(i);
          String value = rs.getString(key);
          map.put(key, value);
        }
      }
      rs.close();
    } catch (Exception e) {
      System.out.println("cannot execute the query " + e.getMessage());
    } finally {
      try {
        if (rs != null && !rs.isClosed())
          rs.close();
      } catch (Exception e) {
        System.out.println("cannot close resultset");
      }
    }
    return map;
  }

  public ArrayList<TreeMap<String, String>> allUsers(Connection con) {
    ResultSet rs = null;
    ArrayList<TreeMap<String, String>> listOfUsers = new ArrayList<TreeMap<String, String>>();
    try {
      String sql = "select * from User order by full_name";
      PreparedStatement stmt = con.prepareStatement(sql);
      rs = stmt.executeQuery();
      ResultSetMetaData meta = rs.getMetaData();
      while (rs.next()) {
        TreeMap<String, String> map = new TreeMap<String, String>();
        for (int i = 1; i <= meta.getColumnCount(); i++) {
          String key = meta.getColumnName(i);
          String value = rs.getString(key);
          map.put(key, value);
        }
        listOfUsers.add(map);
      }
      rs.close();
    } catch (Exception e) {
      System.out.println("cannot execute the query " + e.getMessage());
    } finally {
      try {
        if (rs != null && !rs.isClosed())
          rs.close();
      } catch (Exception e) {
        System.out.println("cannot close resultset");
      }
    }
    return listOfUsers;
  }

  public TreeMap<String, ArrayList<TreeMap<String, String>>> topPopuplarPOIs(int m, Connection con) {
    ResultSet rs;
    TreeMap<String, ArrayList<TreeMap<String, String>>> result = new TreeMap<String, ArrayList<TreeMap<String, String>>>();
    try {
      String sql = "select distinct category from POI";
      PreparedStatement stmt = con.prepareStatement(sql);
      rs = stmt.executeQuery();
      while (rs.next()) {
        result.put(rs.getString("category"), new ArrayList<TreeMap<String, String>>());
      }
      for(Map.Entry<String, ArrayList<TreeMap<String, String>>> entry : result.entrySet()) {
        String category = entry.getKey();
        ArrayList<TreeMap<String, String>> list = entry.getValue();
        
        sql = "select P.pid, P.name, P.address, count(V.visit_id) as visited_times From POI P left join Visits V on P.pid = V.pid where P.category = ? Group by P.pid order by visited_times DESC LIMIT ?";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, category);
        stmt.setInt(2, m);
        rs = stmt.executeQuery();
        ResultSetMetaData meta = rs.getMetaData();
        while (rs.next()) {
          TreeMap<String, String> map = new TreeMap<String, String>();
          for (int i = 1; i <= meta.getColumnCount(); i++) {
            String key = meta.getColumnName(i);
            String value = rs.getString(key);
            map.put(key, value);
          }
          list.add(map);
        }
      }

    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    return result;
  }

  public TreeMap<String, ArrayList<TreeMap<String, String>>> topExpensivePOIs(int m, Connection con) {
    ResultSet rs;
    TreeMap<String, ArrayList<TreeMap<String, String>>> result = new TreeMap<String, ArrayList<TreeMap<String, String>>>();
    try {
      String sql = "select distinct category from POI";
      PreparedStatement stmt = con.prepareStatement(sql);
      rs = stmt.executeQuery();
      while (rs.next()) {
        result.put(rs.getString("category"), new ArrayList<TreeMap<String, String>>());
      }
      for(Map.Entry<String, ArrayList<TreeMap<String, String>>> entry : result.entrySet()) {
        String category = entry.getKey();
        ArrayList<TreeMap<String, String>> list = entry.getValue();
        
        sql = "select P.pid, P.name, P.address, ifnull(avg(VE.total_spending/VE.number_of_persons), 0) as avg_cost from POI P left join Visits V on P.pid = V.pid left join Visit_event VE on V.visit_id = VE.visit_id where P.category = ? Group by P.pid order by avg_cost desc LIMIT ?";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, category);
        stmt.setInt(2, m);
        rs = stmt.executeQuery();
        ResultSetMetaData meta = rs.getMetaData();
        while (rs.next()) {
          TreeMap<String, String> map = new TreeMap<String, String>();
          for (int i = 1; i <= meta.getColumnCount(); i++) {
            String key = meta.getColumnName(i);
            String value = rs.getString(key);
            map.put(key, value);
          }
          list.add(map);
        }
      }

    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    return result;
  }

  public TreeMap<String, ArrayList<TreeMap<String, String>>> topHighRatedPOIs(int m, Connection con) {
    ResultSet rs;
    TreeMap<String, ArrayList<TreeMap<String, String>>> result = new TreeMap<String, ArrayList<TreeMap<String, String>>>();
    try {
      String sql = "select distinct category from POI";
      PreparedStatement stmt = con.prepareStatement(sql);
      rs = stmt.executeQuery();
      while (rs.next()) {
        result.put(rs.getString("category"), new ArrayList<TreeMap<String, String>>());
      }
      for(Map.Entry<String, ArrayList<TreeMap<String, String>>> entry : result.entrySet()) {
        String category = entry.getKey();
        ArrayList<TreeMap<String, String>> list = entry.getValue();
        
        sql = "select P.pid, P.address, P.name, ifnull(avg(F.score), 0) as avg_score from POI P left join Feedback F on P.pid = F.pid where P.category = ? Group by P.pid order by avg_score desc LIMIT ?";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, category);
        stmt.setInt(2, m);
        rs = stmt.executeQuery();
        ResultSetMetaData meta = rs.getMetaData();
        while (rs.next()) {
          TreeMap<String, String> map = new TreeMap<String, String>();
          for (int i = 1; i <= meta.getColumnCount(); i++) {
            String key = meta.getColumnName(i);
            String value = rs.getString(key);
            map.put(key, value);
          }
          list.add(map);
        }
      }

    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    return result;
  }

  public String topPOIs(int m, Connection con) {
    String output = "";
    ResultSet rs;
    ArrayList<String> outputs = new ArrayList<String>();
    try {
      String sql = "select distinct category from POI";
      PreparedStatement stmt = con.prepareStatement(sql);
      rs = stmt.executeQuery();
      ArrayList<String> categories = new ArrayList<String>();
      while (rs.next()) {
        categories.add(rs.getString("category"));
      }

      output = "Here are the top m popular POIs in each category:\n";
      for (String category : categories) {
        sql = "select P.name, P.address, count(*) as visited_times From POI P left join Visits V on P.pid = V.pid where P.category = ? Group by P.pid order by visited_times DESC LIMIT ?";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, category);
        stmt.setInt(2, m);

        rs = stmt.executeQuery();
        output += "Category " + category + ":\n";
        while (rs.next()) {
          output += "POI name: " + rs.getString("name") + "    Address: " + rs.getString("address")
              + "    Visited Times: " + rs.getString("visited_times") + "\n";
        }
      }
      output += "\nHere are the top m expensive POIs in each category:\n";
      for (String category : categories) {
        sql = "select P.name, P.address, ifnull(avg(VE.total_spending/VE.number_of_persons), 0) as avg_cost from POI P left join Visits V on P.pid = V.pid left join Visit_event VE on V.visit_id = VE.visit_id where P.category = ? Group by P.pid order by avg_cost desc LIMIT ?";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, category);
        stmt.setInt(2, m);
        rs = stmt.executeQuery();
        output += "Category " + category + ":\n";
        while (rs.next()) {
          output += "POI name: " + rs.getString("name") + "    Address: " + rs.getString("address")
              + "    Average cost per head: " + rs.getString("avg_cost") + "\n";
        }
      }
      output += "\nHere are the top m high_rated POIs in each category:\n";
      for (String category : categories) {
        sql = "select P.address, P.name, ifnull(avg(F.score), 0) as avg_score from POI P left join Feedback F on P.pid = F.pid where P.category = ? Group by P.pid order by avg_score desc LIMIT ?";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, category);
        stmt.setInt(2, m);
        rs = stmt.executeQuery();
        output += "Category " + category + ":\n";
        while (rs.next()) {
          output += "POI name: " + rs.getString("name") + "    Address: " + rs.getString("address")
              + "    Average Rating: " + rs.getString("avg_score") + "\n";
        }
      }

    } catch (Exception e) {
      System.out.println("cannot execute the query. " + e.getMessage());
    }
    return output;
  }

  public ArrayList<TreeMap<String, String>> searchPOI(String login, String lowPrice, String highPrice, String address, String[] keywords,
      String category, String sort, Connection con) {
    ArrayList<TreeMap<String, String>> result = new ArrayList<TreeMap<String, String>>();
    ResultSet rs = null;
    try {
      String keywordStr = "";
      if (keywords.length > 0) {
        if (!keywords[0].equals("")) {
          keywordStr = "and (P.name LIKE '%" + keywords[0] + "%'";
        }
        for (int i = 1; i < keywords.length; i++) {
          if (!keywords[i].equals("")) {
            keywordStr += " or P.name LIKE '%" + keywords[1] + "%'";
          }
        }
        boolean notEmpty = false;
        for(String keyword : keywords) {
          if(!keyword.equals(""))
            notEmpty = true; 
        }
        if(notEmpty)
          keywordStr += ") ";
      }
      address = "%" + address + "%";
      String lowPriceStr = "";
      if (!lowPrice.equals("")) {
        lowPriceStr = " and P.price >= " + lowPrice;
      }

      String highPriceStr = "";
      if (!highPrice.equals("")) {
        highPriceStr = " and P.price <= " + highPrice;
      }

      String categoryStr = " ";
      if (!category.equals("")) {
        categoryStr = " and P.category = '" + category + "' ";
      }
      String sql = null;
      if (sort.equals("a")) {
        sql = "select distinct P.pid, P.name, P.address, P.price From POI P where P.address Like ? "
            + lowPriceStr + highPriceStr + categoryStr + keywordStr
            + " order by P.price desc";
      } else if (sort.equals("b")) {
        sql = "select distinct P.pid, P.name, P.address, P.price, avg(F.score) as avg_score From POI P left join Feedback F on P.pid = F.pid where P.address Like ? "
            + lowPriceStr + highPriceStr + categoryStr + keywordStr
            + " group by P.pid order by avg_score desc";
      } else {
        sql = "select distinct P.pid, P.name, P.address, P.price, ifnull(avg(F.score), 0) as avg_score From POI P left join Feedback F on P.pid = F.pid" 
            + " left join (select trustee_login from Trusts where truster_login = '" + login
            + "' and Trust_or_not = 1) T on T.trustee_login = F.login_name where P.address Like ? "
            + lowPriceStr + highPriceStr + categoryStr + keywordStr
            + " group by P.pid order by avg_score desc";
      }
      System.out.println(sql);
      
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, address);
      rs = stmt.executeQuery();
      ResultSetMetaData meta = rs.getMetaData();
      while (rs.next()) {
        TreeMap<String, String> map = new TreeMap<String, String>();
        for (int i = 1; i <= meta.getColumnCount(); i++) {
          String key = meta.getColumnName(i);
          String value = rs.getString(key);
          map.put(key, value);
        }
        result.add(map);
      }
      rs.close();
    } catch (Exception e) {
      System.out.println("cannot execute the query " + e.getMessage());
    } finally {
      try {
        if (rs != null && !rs.isClosed())
          rs.close();
      } catch (Exception e) {
        System.out.println("cannot close resultset");
      }
    }
    return result;
  }

  public String searchPOI_(String login, String lowPrice, String highPrice, String address, String[] keywords,
      String category, String sort, Connection con) {
    String output = "";
    ResultSet rs = null;
    try {
      String keywordStr = "";
      if (keywords.length > 0) {
        if (!keywords[0].equals("")) {
          keywordStr = "and (P.name LIKE '%" + keywords[0] + "%'";
        }
        for (int i = 1; i < keywords.length; i++) {
          if (!keywords[i].equals("")) {
            keywordStr += " or P.name LIKE '%" + keywords[1] + "%'";
          }
        }
        boolean notEmpty = false;
        for(String keyword : keywords) {
          if(!keyword.equals(""))
            notEmpty = true; 
        }
        if(notEmpty)
          keywordStr += ") ";
      }
      address = "%" + address + "%";
      String lowPriceStr = "";
      if (!lowPrice.equals("")) {
        lowPriceStr = " and P.price >= " + lowPrice;
      }

      String highPriceStr = "";
      if (!highPrice.equals("")) {
        highPriceStr = " and P.price <= " + highPrice;
      }

      String categoryStr = " ";
      if (!category.equals("")) {
        categoryStr = " and P.category = '" + category + "' ";
      }
      String sql = null;
      if (sort.equals("a")) {
        sql = "select distinct P.pid, P.name, P.address, P.price From POI P where P.address Like ? "
            + lowPriceStr + highPriceStr + categoryStr + keywordStr
            + " order by P.price desc";
      } else if (sort.equals("b")) {
        sql = "select distinct P.pid, P.name, P.address, P.price, avg(F.score) as avg_score From POI P left join Feedback F on P.pid = F.pid where P.address Like ? "
            + lowPriceStr + highPriceStr + categoryStr + keywordStr
            + " group by P.pid order by avg_score desc";
      } else {
        sql = "select distinct P.pid, P.name, P.address, P.price, ifnull(avg(F.score), 0) as avg_score From POI P left join Feedback F on P.pid = F.pid" 
            + " left join (select trustee_login from Trusts where truster_login = '" + login
            + "' and Trust_or_not = 1) T on T.trustee_login = F.login_name where P.address Like ? "
            + lowPriceStr + highPriceStr + categoryStr + keywordStr
            + " group by P.pid order by avg_score desc";
      }
      System.out.println(sql);
      
      PreparedStatement stmt = con.prepareStatement(sql);
      stmt.setString(1, address);
      rs = stmt.executeQuery();
      while (rs.next()) {
        if (sort.equals("a")) {
          output += "POI name: " + rs.getString("name") + "    Address: " + rs.getString("address")
              + "    Price: " + rs.getDouble("price") + "\n";
        } else if (sort.equals("b")) {
          output += "POI name: " + rs.getString("name") + "    Address: " + rs.getString("address")
          + "    Price: " + rs.getDouble("price") + "    Avgerage score: " + rs.getDouble("avg_score") + "\n";
        } else {
          output += "POI name: " + rs.getString("name") + "    Address: " + rs.getString("address")
          + "    Price: " + rs.getDouble("price") + "    Average score from trusted users: " + rs.getDouble("avg_score") + "\n";
        }
      }
      rs.close();
    } catch (Exception e) {
      System.out.println("cannot execute the query " + e.getMessage());
    } finally {
      try {
        if (rs != null && !rs.isClosed())
          rs.close();
      } catch (Exception e) {
        System.out.println("cannot close resultset");
      }
    }
    return output;
  }
}

