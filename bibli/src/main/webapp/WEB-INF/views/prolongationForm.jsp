<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/adherent.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Demander une Prolongation</h2>
        <form action="/pret/traiterDemanderProlongation" method="post">
            <div class="mb-3">
               <c:if test="${empty prets}">
    <p>Aucun prêt disponible pour prolongation.</p>
</c:if>
<select class="form-control" id="idPret" name="idPret" required>
    <c:forEach var="pret" items="${prets}">
        <c:if test="${pret.dateRetourEffective == null && pret.prolongationCount < adherent.profil.quotaProlongement}">
            <option value="${pret.idPret}">${pret.exemplaire.livre.titre} (Retour prévu: ${pret.dateRetourPrevue})</option>
        </c:if>
    </c:forEach>
</select>
            </div>
            <div class="mb-3">
                <label for="nouvelleDateRetour" class="form-label">Nouvelle date de retour</label>
                <input type="date" class="form-control" id="nouvelleDateRetour" name="nouvelleDateRetour" required>
            </div>
            <button type="submit" class="btn btn-custom w-100">Soumettre la demande</button>
            <c:if test="${not empty message}">
                <p class="success">${message}</p>
            </c:if>
            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>
        </form>
        <a href="/adherent/dashboard" class="btn btn-custom mt-3 w-100">Retour au tableau de bord</a>
    </div>
</c:set>
<%@ include file="adherentDashboard.jsp" %>