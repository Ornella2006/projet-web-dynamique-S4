<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/adherent.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Mes Réservations</h2>
        <table class="table">
            <thead>
                <tr>
                    <th>ID Réservation</th>
                    <th>Titre</th>
                    <th>Date Retrait Prévue</th>
                    <th>Statut</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="reservation" items="${reservations}">
                    <tr>
                        <td>${reservation.idReservation}</td>
                        <td>${reservation.exemplaire.livre.titre}</td>
                        <td>${reservation.dateRetraitPrevue}</td>
                        <td>${reservation.statut}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <c:if test="${empty reservations}">
            <p class="text-info">Aucune réservation en attente.</p>
        </c:if>
        <a href="/adherent/dashboard" class="btn btn-custom mt-3 w-100">Retour au tableau de bord</a>
    </div>
</c:set>
<%@ include file="adherentDashboard.jsp" %>