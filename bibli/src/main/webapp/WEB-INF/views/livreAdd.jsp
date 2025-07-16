<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Ajouter un Livre</h2>
        <form action="/admin/livres/save" method="post">
            <div class="mb-3">
                <label for="titre" class="form-label">Titre</label>
                <input type="text" class="form-control" id="titre" name="titre" required>
            </div>
            <div class="mb-3">
                <label for="auteur" class="form-label">Auteur</label>
                <input type="text" class="form-control" id="auteur" name="auteur">
            </div>
            <div class="mb-3">
                <label for="editeur" class="form-label">Éditeur</label>
                <input type="text" class="form-control" id="editeur" name="editeur">
            </div>
            <div class="mb-3">
                <label for="anneePublication" class="form-label">Année de publication</label>
                <input type="number" class="form-control" id="anneePublication" name="anneePublication" min="1900" max="2099">
            </div>
            <div class="mb-3">
                <label for="genre" class="form-label">Genre</label>
                <input type="text" class="form-control" id="genre" name="genre">
            </div>
            <div class="mb-3">
                <label for="isbn" class="form-label">ISBN</label>
                <input type="text" class="form-control" id="isbn" name="isbn">
            </div>
            <div class="mb-3">
                <label for="restrictionAge" class="form-label">Âge minimum</label>
                <input type="number" class="form-control" id="restrictionAge" name="restrictionAge" min="0" value="0">
            </div>
            <div class="mb-3">
                <label for="professeurSeulement" class="form-label">Réservé aux professeurs ?</label>
                <select class="form-control" id="professeurSeulement" name="professeurSeulement">
                    <option value="false">Non</option>
                    <option value="true">Oui</option>
                </select>
            </div>
            <button type="submit" class="btn btn-custom w-100">Ajouter</button>
        </form>
        <a href="/admin/livres" class="btn btn-custom mt-3 w-100">Retour à la liste</a>
    </div>
</c:set>
<%@ include file="adminDashboard.jsp" %>