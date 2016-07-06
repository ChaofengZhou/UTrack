# UTrack
UTrack is a Web Application built with [JSP](http://www.oracle.com/technetwork/java/javaee/jsp/index.html), [Java](https://java.com/en/download/), [Bootstrap](http://getbootstrap.com/) and [MySQL](https://www.mongodb.com/). It is a yelp-like project which supports functionalities including allowing admin to add/edit POI (like restaurants and parks), and allowing users to add visit records, rate and comments to POIs.

UTrack is the course project for my undergraduate class `Database Systems`.

### UI/UX Design

I have designed my website as similar as the real world Yelp. Here is a list of UI guides:

1. User can either register a new user or log in to an account on the index page.

2. On the main page, it will show the basic info of the user. Regular users will have a "Two degree of separation" button, while admin will have "create user" and "user awards" buttons besides that. All the buttons will take users to specific pages.

3. On the POI list page, I have placed a search div with several searching boxes on the left side. On the right side, there is a div for top POIs. Users can click the POI name to go to the POI webpages. Clicking the show button in top POIs div will refresh the page so the category filter will be reset.

4. On the POI pages, users can favorite, put feedback and add visit records to POI. Admin can edit the POI. Also, every POI has feedbacks attached on its webpage. users can rate the feedbacks.

5. On the user list page, I have placed a whole user list on the left side and a name filter is provided. Regular users will only see the left side list but admin can check "User Awards" list which shows the top users. Similarly, we can click the user link to go to user pages.

6. On the user pages, we can see the basic information of a user and we can trust or distrust a user.

7. On the two degrees of separation page, there are two dropdown boxes for selecting users, and there is a submit button.

8. We can click the user name link on the navbar to go to temp visits and log out.

9. Temp visits page shows the visit records the users have added in this session. Users can confirm the adding.

10. Clicking "Log out" button will end the session, and users will log out.

