<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tableau de Bord - Adhérent</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/adherent.css" rel="stylesheet">
</head>
<body>
    <%@ include file="fragments/sidebar-adherent.jsp" %>
    <div class="content">
        <div class="container">
            <h1 class="text-center mb-4" style="color: white; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);">Tableau de Bord Adhérent</h1>
            <div class="row">
                <div class="col-md-6 mx-auto">
                    <div class="card p-4 mb-4 text-center">
                        <h3 class="card-title">Bienvenue, Adhérent</h3>
                        <p class="card-text">Utilisez le menu à gauche pour consulter vos prêts, réservations ou votre profil.</p>
                    </div>
                </div>
            </div>
            ${content}
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>