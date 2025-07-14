<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bibliothèque - Inscription</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/public.css" rel="stylesheet">
</head>
<body>
    <div class="signin-container">
        <h2 class="text-center mb-4" style="color: #8B4513;">Inscription <%= request.getParameter("role") %></h2>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>
        <form action="/signin" method="post">
            <input type="hidden" name="role" value="<%= request.getParameter("role") %>">
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="mb-3">
                <label for="motDePasse" class="form-label">Mot de passe</label>
                <input type="password" class="form-control" id="motDePasse" name="motDePasse" required>
            </div>
            <% if ("ADHERENT".equals(request.getParameter("role"))) { %>
                <div class="mb-3">
                    <label for="nom" class="form-label">Nom</label>
                    <input type="text" class="form-control" id="nom" name="nom" required>
                </div>
                <div class="mb-3">
                    <label for="prenom" class="form-label">Prénom</label>
                    <input type="text" class="form-control" id="prenom" name="prenom" required>
                </div>
                <div class="mb-3">
                    <label for="dateNaissance" class="form-label">Date de naissance</label>
                    <input type="date" class="form-control" id="dateNaissance" name="dateNaissance" required>
                </div>
                <div class="mb-3">
                    <label for="idProfil" class="form-label">Type de profil</label>
                    <select class="form-control" id="idProfil" name="idProfil" required>
                        <option value="1">ETUDIANT</option>
                        <option value="2">PROFESSIONNEL</option>
                        <option value="3">PROFESSEUR</option>
                    </select>
                </div>
            <% } %>
            <button type="submit" class="btn btn-custom w-100">S'inscrire</button>
        </form>
        <p class="text-center mt-3">Déjà un compte ? <a href="/login?role=<%= request.getParameter("role") %>">Se connecter</a></p>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>