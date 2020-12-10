<%-- 
    Document   : restrita
    Created on : 03/09/2020, 13:50:58
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
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.min.js" integrity="sha384-w1Q4orYjBQndcko6MimVbzY0tgp4pWB4lZ7lr30WKz0vr/aWKhXdBNmNb5D92v7s" crossorigin="anonymous"></script>
        
        <title>Projeto JAVA Web</title>
    </head>
    
    
    <body>
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <a class="navbar-brand" href="#">Lista de Usuários</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item active">
                    <a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Link</a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true">Disabled</a>
                </li>
            </ul>
            
            
            <form class="form-inline my-2 my-lg-0">
                <%
                    String usuarioSessao = (String) session.getAttribute("usuarioSessao");
                    out.println("Olá: &nbsp; <b> " + usuarioSessao + "</b>&nbsp;");
                    out.println("<hr>");
                    
                    if (usuarioSessao == null) {
                        response.sendRedirect("index.jsp");
                    }
                %>
                
                <a href="logout.jsp">
                    <input type="button" class="btn btn-outline-danger my-2 my-sm-0" value="SAIR" />
                </a>
                
                
            </form>
        </div>
        </nav>
                
                
        <div class="container">
            
            <div class="row mt-4 mb-4"> 
                <!--- <button class="btn-info" data-toggle="modal" data-target="#modalInserir">Novo Usuário</button> -->
                <a type="button" class="btn-info" href="restrita.jsp?funcao=novo">Novo Usuário</a> 
                
                <form class="form-inline my-2 my-lg-0" method="post"> 
                <input class="form-control mr-sm-2" type="search" name="txtbuscar" placeholder="Digite um nome" aria-label="Search"> 
                <button class="btn btn-outline-info my-2 my-sm-0" name="btn_buscar" type="submit">Buscar</button> 
                </form> 
            </div>
            
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Nome</th>
                        <th scope="col">Email</th>
                        <th scope="col">Senha</th>
                        <th scope="col">Nível</th>
                        <th scope="col">Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Statement st = null;
                        ResultSet rs = null;
                        
                        
                        try {
                            st = new Conexao().conectar().createStatement();
                            if (request.getParameter("btn_buscar") != null) {
                                String busca = '%' + request.getParameter("txtbuscar") + '%';
                                rs = st.executeQuery("SELECT * FROM usuarios WHERE nome LIKE '" + busca + "' ");
                            }
                            else{
                                rs = st.executeQuery("SELECT * FROM usuarios");
                            }
                            
                            
                            while (rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getString(1)%></td>
                                    <td><%= rs.getString(2)%></td>
                                    <td><%= rs.getString(3)%></td>
                                    <td><%= rs.getString(4)%></td>
                                    <td><%= rs.getString(5)%></td>
                                    <td> 
                                        <a href="restrita.jsp?funcao=excluir&id=<%= rs.getString(1)%>"
                                           class="btn  my-2 my-sm-0 btn-primary">Excluir</a>
                                        <a href="restrita.jsp?funcao=atualizar&id=<%= rs.getString(1)%>" 
                                           class="btn  my-2 my-sm-0 btn-secondary">Alterar</a>
                                    </td>
                                </tr>
                                <%
                            }
                        } 
                        catch (Exception e){
                            out.println(e);
                        }


                    %>
                </tbody>
            </table>
        </div>
    </body>
<!-- Modal -->
<div class="modal fade" id="modalInserir" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
          <%
            String id_novo= "";  
            String nome_novo= "";  
            String email_novo= "";
            String senha_novo= "";
            String nivel_novo= "";
            String titulo = null;
            String btn = null;
            if (request.getParameter("funcao") != null &&
                    request.getParameter("funcao").equals("atualizar")){
                titulo = "Alterar Usuário";
                btn = "btn-atualizar";
                id_novo = request.getParameter("id");
                try{
                    st = new Conexao().conectar().createStatement();
                    rs = st.executeQuery("SELECT * FROM usuarios WHERE " + "id = '" + id_novo + "'");
                    while (rs.next()){
                        nome_novo = rs.getString(2);
                        email_novo = rs.getString(3);
                        senha_novo = rs.getString(4);
                        nivel_novo = rs.getString(5);
                        usuarioSessao = rs.getString(2);
                    }
                } catch (Exception e){
                    out.println(e);
                }
                
            }else{
                titulo = "Cadastro de Novo Usuário";
                btn = "btn-salvar";
            }
          %>
        <h5 class="modal-title" id="exampleModalLabel"><%=titulo%></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
        
        
        
      <form id="cadastro-form" class="form" action="" method="POST">
        <div class="modal-body">
            
            <%
                if (request.getParameter("funcao") != null &&
                        request.getParameter("funcao").equals("atualizar")){
                    //out.print("<script>alert('FUNÇÃO ATUALIZAR - FOI CLICADA!');</script>");
                }
            %>
            
            <div class="form-group">
                <label for="name" class="text-info">Nome:</label><br>
                <input value="<%=nome_novo%>" type="text" name="nome" id="nome" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="email" class="text-info">Email:</label><br>
                <input value="<%=email_novo%>" type="text" name="email" id="email" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="senha" class="text-info">Senha:</label><br>
                <input value="<%=senha_novo%>" type="text" name="senha" id="senha" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="exampleFormControlSelect1">Nível</label><br>
                <select class="form-control" name="txtNivel" id="txtNivel">
                    <option value="<%=nivel_novo %>"><%=nivel_novo %></option>
                    <%
                        if(!nivel_novo.equals("comum")){
                            out.println("<option>comum</option>");
                        }
                        if(!nivel_novo.equals("adm")){
                            out.println("<option>Administrador</option>");
                        }
                    %>
                </select>
            </div>
            
        </div>
          
          
          
          
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Fechar</button>
        <button type="submit" name="<%=btn %>" class="btn btn-primary"><%=titulo %></button>
      </div>
      </form>
    </div>
  </div>
</div>
</html>

<%
    // SALVAR
    if (request.getParameter("btn-salvar") != null){
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String nivel = request.getParameter("txtNivel");
        
        try{
            st = new Conexao().conectar().createStatement();
            
            rs = st.executeQuery("SELECT * FROM usuarios WHERE email = '"+ email +"' ");
            while (rs.next()) {
               rs.getRow();
               if (rs.getRow() > 0) {
                   out.print("<script>alert ('Usuário já cadastrado');</script>");
                   return;
               }
            }
            
            st.executeUpdate("INSERT INTO usuarios (nome, email, senha, nivel) " + 
                    "VALUES ('" + nome + "','" + email + "','" + senha + "','" + nivel + "')");
            response.sendRedirect("restrita.jsp");
        } catch (Exception e) {
            out.println(e);
        }

    }
%>

<%
   // ATUALIZAR
    if (request.getParameter("btn-atualizar") != null){
        String id = request.getParameter("id");
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String nivel = request.getParameter("txtNivel");
        
        try{
            st = new Conexao().conectar().createStatement();
            st.executeUpdate("UPDATE usuarios SET nome = '" + nome + "',"
            + "email = '" + email + "', senha = '" + senha + "'," 
                    + "nivel = '" + nivel + "' WHERE id = '" + id + "' ");
            response.sendRedirect("restrita.jsp");
        } catch (Exception e) {
            out.println(e);
        }

    }
%>

<%
    //FUNÇÃO EXCLUIR
    if (request.getParameter("funcao") != null &&
            request.getParameter("funcao").equals("excluir")){
        //out.println("<script>alert('FUNÇÃO EXCLUIR!');</script>");
        String id = request.getParameter("id");
        try{
            st = new Conexao().conectar().createStatement();
            st.executeUpdate("DELETE FROM usuarios WHERE id = '" + id + "' ");
            response.sendRedirect("restrita.jsp");
        } catch (Exception e){
            out.println(e);
        }
    }
%>

<%
    if (request.getParameter("funcao") != null &&
            request.getParameter("funcao").equals("atualizar")){
        out.println("<script>$('#modalInserir').modal('show');</script>");
    }

%>

<%
    if (request.getParameter("funcao") != null &&
            request.getParameter("funcao").equals("novo")){
        out.println("<script>$('#modalInserir').modal('show');</script>");
    }
%>