<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Prolongements en attente</h2>
        <c:if test="${not empty message}">
            <p class="success">${message}</p>
        </c:if>
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        <table class="table">
            <thead>
                <tr>
                    <th>ID Prolongement</th>
                    <th>Prêt</th>
                    <th>Adhérent</th>
                    <th>Nouvelle Date Retour</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="prolongement" items="${prolongements}">
                    <tr>
                        <td>${prolongement.idProlongement}</td>
                        <td>${prolongement.pret.idPret} (${prolongement.pret.exemplaire.livre.titre})</td>
                        <td>${prolongement.adherent.nom} ${prolongement.adherent.prenom}</td>
                        <td>${prolongement.nouvelleDateRetour}</td>
                        <td>
                            <form action="/admin/validateProlongement" method="post" style="display:inline;">
                                <input type="hidden" name="idProlongement" value="${prolongement.idProlongement}">
                                <button type="submit" class="btn btn-custom btn-sm">Valider</button>
                            </form>
                            <form action="/admin/rejectProlongement" method="post" style="display:inline;">
                                <input type="hidden" name="idProlongement" value="${prolongement.idProlongement}">
                                <button type="submit" class="btn btn-custom btn-sm" style="background-color: #A0522D;">Rejeter</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <a href="/admin/dashboard" class="btn btn-custom mt-3 w-100">Retour au tableau de bord</a>
    </div>
</c:set>
<%@ include file="adminDashboard.jsp" %>