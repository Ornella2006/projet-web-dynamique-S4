<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tableau de Bord - Bibliothécaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: url('https://images.unsplash.com/photo-1512820790803-83ca1980f6b9') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            margin: 0;
            font-family: 'Georgia', serif;
        }
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            width: 250px;
            background-color: rgba(139, 69, 19, 0.95); /* Marron sombre avec opacité */
            padding-top: 20px;
            color: white;
        }
        .sidebar a {
            color: white;
            padding: 15px;
            display: block;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        .sidebar a:hover {
            background-color: #A0522D;
        }
        .content {
            margin-left: 270px;
            padding: 20px;
        }
        .card {
            background-color: rgba(255, 255, 255, 0.95);
            border: 1px solid #8B4513;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s;
        }
        .card:hover {
            transform: scale(1.05);
        }
        .card-title {
            color: #8B4513;
            font-weight: bold;
        }
        .card-text {
            color: #333;
        }
        .btn-custom {
            background-color: #8B4513;
            color: white;
            border: none;
        }
        .btn-custom:hover {
            background-color: #A0522D;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h3 class="text-center mb-4">Menu Bibliothécaire</h3>
        <a href="/admin/pret">Gérer les Prêts</a>
        <a href="/admin/retour">Retour des Prêts</a>
        <a href="/admin/reservation">Gérer les Réservations</a>
        <a href="/admin/livre">Gérer les Livres</a>
        <a href="/admin/exemplaire">Gérer les Exemplaires</a>
        <a href="/admin/adherent">Gérer les Adhérents</a>
        <a href="/logout" class="btn btn-custom mt-3 ms-3">Déconnexion</a>
    </div>
    <div class="content">
        <div class="container">
            <h1 class="text-center mb-4" style="color: white; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);">Tableau de Bord Bibliothécaire</h1>
            <div class="row">
                <div class="col-md-6">
                    <div class="card p-4 mb-4">
                        <h3 class="card-title">Bienvenue, Bibliothécaire</h3>
                        <p class="card-text">Utilisez le menu à gauche pour gérer les prêts, réservations, livres, exemplaires et adhérents.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>