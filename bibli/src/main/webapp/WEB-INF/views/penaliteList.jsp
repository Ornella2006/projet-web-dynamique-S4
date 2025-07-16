<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Liste des Pénalités</h2>
        <c:if test="${not empty message}">
            <p class="success">${message}</p>
        </c:if>
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        <table class="table">
            <thead>
                <tr>
                    <th>ID Pénalité</th>
                    <th>Adhérent</th>
                    <th>Prêt</th>
                    <th>Date Début</th>
                    <th>Date Fin</th>
                    <th>Raison</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="penalite" items="${penalites}">
                    <tr>
                        <td>${penalite.idPenalite}</td>
                        <td>${penalite.adherent.nom} ${penalite.adherent.prenom}</td>
                        <td>${penalite.pret != null ? penalite.pret.idPret : 'N/A'}</td>
                        <td>${penalite.dateDebutPenalite}</td>
                        <td>${penalite.dateFinPenalite}</td>
                        <td>${penalite.raison}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <a href="/admin/dashboard" class="btn btn-custom mt-3 w-100">Retour au tableau de bord</a>
    </div>
</c:set>
<%@ include file="adminDashboard.jsp" %>