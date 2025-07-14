<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bibliothèque - Choix du Profil</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/public.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h1 class="text-center mb-5" style="color: white; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);">Bienvenue à la Bibliothèque</h1>
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card text-center p-4 m-2">
                    <h3 class="card-title">Accéder en tant qu'Adhérent</h3>
                    <p class="card-text">Connectez-vous pour consulter vos prêts, etc.</p>
                    <a href="/login?role=ADHERENT" class="btn btn-custom">Connexion Adhérent</a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-center p-4 m-2">
                    <h3 class="card-title">Accéder en tant que Bibliothécaire</h3>
                    <p class="card-text">Gérez les prêts, réservations et le catalogue.</p>
                    <a href="/login?role=BIBLIOTHECAIRE" class="btn btn-custom">Connexion Bibliothécaire</a>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>