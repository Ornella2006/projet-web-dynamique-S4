<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="content">
    <div class="form-container">
        <h2>Gestion des Livres</h2>
        <a href="/admin/livres/add" class="btn btn-custom mb-3">Ajouter un livre</a>
        
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Titre</th>
                    <th>Auteur</th>
                    <th>ISBN</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="livre" items="${livres}">
                    <tr>
                        <td>${livre.idLivre}</td>
                        <td>${livre.titre}</td>
                        <td>${livre.auteur}</td>
                        <td>${livre.isbn}</td>
                        <td>
                            <a href="/admin/livres/edit/${livre.idLivre}" class="btn btn-sm btn-custom">Modifier</a>
                            <a href="/admin/livres/delete/${livre.idLivre}" class="btn btn-sm btn-danger">Supprimer</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</c:set>
<%@ include file="adminDashboard.jsp" %>