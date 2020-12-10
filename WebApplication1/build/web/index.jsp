<%-- 
    Document   : index
    Created on : 24/08/2020, 13:49:38
    Author     : Jonathan
--%>

<%@page import="java.sql.*"%>
<%@page import="config.Conexao"%>
<%@page import="com.mysql.jdbc.Driver"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="css/estilo.css" rel="stylesheet">
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    </head>
<!------ Include the above in your HEAD tag ---------->
<%
    Statement st = null;
    ResultSet rs = null;
    
%>
<body>
    <div id="login">
        <h3 class="text-center text-white pt-5">Login form</h3>
        <div class="container">
            <div id="login-row" class="row justify-content-center align-items-center">
                <div id="login-column" class="col-md-6">
                    <div id="login-box" class="col-md-12">
                        <form id="login-form" class="form" action="" method="post">
                            <h3 class="text-center text-info">Login</h3>
                            <div class="form-group">
                                <label for="username" class="text-info">Email:</label><br>
                                <input type="text" name="nome_usuario" id="username" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="password" class="text-info">Password:</label><br>
                                <input type="password" name="senha_usuario" id="password" class="form-control">
                            </div>
                            
                            <div class="form-group">
                                <%-- <label for="remember-me" class="text-info"><span>Remember me</span> <span><input id="remember-me" name="remember-me" type="checkbox"></span></label><br>
                                --%>
                                <input type="submit" name="submit" class="btn btn-info btn-md" value="Entrar">
                            </div>
                            <%-- 
                            <div id="register-link" class="text-right">
                                <a href="#" class="text-info">Register here</a>
                            </div>
                            --%>
                            
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%
    String nome = request.getParameter("nome_usuario");
    String senha = request.getParameter("senha_usuario");
    String nome_usuario = "";
    String senha_usuario = "";
    String usuarioSessao = "";
    int i = 0;

    try {
        st = new Conexao().conectar().createStatement();
        rs = st.executeQuery("SELECT * FROM usuarios WHERE email = '"+nome+"' and senha = '"+senha+"' ");
        while (rs.next()) {
            nome_usuario = rs.getString(3);
            senha_usuario = rs.getString(4);
            usuarioSessao = rs.getString(2);
            rs.last();
            i = rs.getRow();
        }
    } 
    catch (Exception e){
        out.println(e);
    }
    
    if (i == 0){
        out.println("Usuário não encontrado no Banco de Dados");
    } else {
        session.setAttribute("usuarioSessao", usuarioSessao);
        response.sendRedirect("restrita.jsp");
    }
    %>
    
</body>

</html>
