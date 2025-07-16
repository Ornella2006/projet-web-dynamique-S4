<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Gestion des Adhérents</h2>
        <a href="/admin/adherents/add" class="btn btn-custom mb-3">Ajouter un adhérent</a>
        
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nom</th>
                    <th>Prénom</th>
                    <th>Email</th>
                    <th>Profil</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="adherent" items="${adherents}">
                    <tr>
                        <td>${adherent.idAdherent}</td>
                        <td>${adherent.nom}</td>
                        <td>${adherent.prenom}</td>
                        <td>${adherent.email}</td>
                        <td>${adherent.profil.typeProfil}</td>
                        <td>${adherent.statut}</td>
                        <td>
                            <a href="/admin/adherents/edit/${adherent.idAdherent}" class="btn btn-sm btn-custom">Modifier</a>
                            <a href="/admin/adherents/delete/${adherent.idAdherent}" class="btn btn-sm btn-danger">Supprimer</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</c:set>
<%@ include file="adminDashboard.jsp" %>