<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Formulaire de Prêt - Bibliothèque</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: url('https://images.unsplash.com/photo-1512820790803-83ca1980f6b9') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            margin: 0;
            font-family: 'Georgia', serif;
            display: flex;
        }
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            width: 250px;
            background-color: rgba(139, 69, 19, 0.95);
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
            width: 100%;
        }
        .form-container {
            background-color: rgba(255, 255, 255, 0.95);
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            max-width: 500px;
            margin: auto;
        }
        .btn-custom {
            background-color: #8B4513;
            color: white;
            border: none;
        }
        .btn-custom:hover {
            background-color: #A0522D;
        }
        .error {
            color: red;
            font-size: 0.9em;
            margin-top: 10px;
        }
        .success {
            color: green;
            font-size: 0.9em;
            margin-top: 10px;
        }
        h2 {
            color: #8B4513;
            font-weight: bold;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h3 class="text-center mb-4">Menu Bibliothécaire</h3>
        <a href="/admin/pret">Gérer les Prêts</a>
        <a href="/admin/reservation">Gérer les Réservations</a>
        <a href="/admin/livre">Gérer les Livres</a>
        <a href="/admin/exemplaire">Gérer les Exemplaires</a>
        <a href="/admin/adherent">Gérer les Adhérents</a>
        <a href="/logout" class="btn btn-custom mt-3 ms-3">Déconnexion</a>
    </div>
    <div class="content">
        <div class="form-container">
            <h2>Formulaire de Prêt</h2>
            <form action="/admin/pret" method="post">
                <div class="mb-3">
                    <label for="idAdherent" class="form-label">ID Adhérent</label>
                    <input type="number" class="form-control" id="idAdherent" name="adherentId" required>
                </div>
                <div class="mb-3">
                    <label for="idExemplaire" class="form-label">ID Exemplaire</label>
                    <input type="number" class="form-control" id="idExemplaire" name="exemplaireId" required>
                </div>
                <div class="mb-3">
                    <label for="typePret" class="form-label">Type de prêt</label>
                    <select class="form-control" id="typePret" name="typePret" required>
                        <option value="SUR_PLACE">Sur place</option>
                        <option value="DOMICILE">Domicile</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-custom w-100">Valider le prêt</button>
            </form>
<<<<<<< HEAD
=======

            <h2 class="mt-4">Retourner un Prêt</h2>
            <form action="/admin/pret/retour" method="post">
                <div class="mb-3">
                    <label for="idPret" class="form-label">ID du Prêt</label>
                    <input type="number" class="form-control" id="idPret" name="idPret" required>
                </div>
                <button type="submit" class="btn btn-custom w-100">Retourner le prêt</button>
            </form>

>>>>>>> master
            <c:if test="${not empty message}">
                <p class="success">${message}</p>
            </c:if>
            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>
            <a href="/admin/dashboard" class="btn btn-custom mt-3 w-100">Retour au tableau de bord</a>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>