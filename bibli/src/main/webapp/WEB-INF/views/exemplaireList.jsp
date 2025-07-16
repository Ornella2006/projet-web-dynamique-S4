<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Gestion des Exemplaires</h2>
        <a href="/admin/exemplaires/add" class="btn btn-custom mb-3">Ajouter un exemplaire</a>
        
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Livre</th>
                    <th>État</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="exemplaire" items="${exemplaires}">
                    <tr>
                        <td>${exemplaire.idExemplaire}</td>
                        <td>${exemplaire.livre.titre}</td>
                        <td>${exemplaire.etat}</td>
                        <td>${exemplaire.statut}</td>
                        <td>
                            <a href="/admin/exemplaires/edit/${exemplaire.idExemplaire}" class="btn btn-sm btn-custom">Modifier</a>
                            <a href="/admin/exemplaires/delete/${exemplaire.idExemplaire}" class="btn btn-sm btn-danger">Supprimer</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</c:set>
<%@ include file="adminDashboard.jsp" %>