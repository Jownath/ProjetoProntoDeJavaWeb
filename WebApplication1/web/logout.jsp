<%-- 
    Document   : logout
    Created on : 24/09/2020, 17:41:59
    Author     : Jonathan
--%>

<% 
    session.invalidate();
    response.sendRedirect("index.jsp");
%>
