<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Modifier l'Exemplaire</h2>
        <form action="/admin/exemplaires/edit/${exemplaire.idExemplaire}" method="post">
            <input type="hidden" name="idExemplaire" value="${exemplaire.idExemplaire}">
            <div class="mb-3">
                <label for="livre" class="form-label">Livre</label>
                <select class="form-control" id="livre" name="livre.idLivre" required>
                    <c:forEach var="livre" items="${livres}">
                        <option value="${livre.idLivre}" ${livre.idLivre == exemplaire.livre.idLivre ? 'selected' : ''}>
                            ${livre.titre}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="mb-3">
                <label for="etat" class="form-label">État</label>
                <select class="form-control" id="etat" name="etat" required>
                    <option value="BON" ${exemplaire.etat == 'BON' ? 'selected' : ''}>Bon</option>
                    <option value="ABIME" ${exemplaire.etat == 'ABIME' ? 'selected' : ''}>Abîmé</option>
                    <option value="PERDU" ${exemplaire.etat == 'PERDU' ? 'selected' : ''}>Perdu</option>
                </select>
            </div>
            <div class="mb-3">
                <label for="statut" class="form-label">Statut</label>
                <select class="form-control" id="statut" name="statut" required>
                    <option value="DISPONIBLE" ${exemplaire.statut == 'DISPONIBLE' ? 'selected' : ''}>Disponible</option>
                    <option value="EN_PRET" ${exemplaire.statut == 'EN_PRET' ? 'selected' : ''}>En prêt</option>
                    <option value="RESERVE" ${exemplaire.statut == 'RESERVE' ? 'selected' : ''}>Réservé</option>
                    <option value="LECTURE_SUR_PLACE" ${exemplaire.statut == 'LECTURE_SUR_PLACE' ? 'selected' : ''}>Lecture sur place</option>
                </select>
            </div>
            <button type="submit" class="btn btn-custom w-100">Enregistrer</button>
        </form>
        <a href="/admin/exemplaires" class="btn btn-custom mt-3 w-100">Retour</a>
    </div>
</c:set>
<%@ include file="adminDashboard.jsp" %>