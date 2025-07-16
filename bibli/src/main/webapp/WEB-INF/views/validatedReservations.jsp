<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Réservations validées</h2>
        <c:if test="${not empty message}">
            <p class="success">${message}</p>
        </c:if>
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        <table class="table">
            <thead>
                <tr>
                    <th>ID Réservation</th>
                    <th>Adhérent</th>
                    <th>Exemplaire</th>
                    <th>Date Retrait</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="reservation" items="${reservations}">
                    <tr>
                        <td>${reservation.idReservation}</td>
                        <td>${reservation.adherent.nom} ${reservation.adherent.prenom}</td>
                        <td>${reservation.exemplaire.livre.titre}</td>
                        <td>${reservation.dateRetraitPrevue}</td>
                        <td>
                        <form action="/admin/convertToPretForm" method="get" style="display:inline;">   
                                <input type="hidden" name="idReservation" value="${reservation.idReservation}">                           
                                <input type="hidden" name="idAdherent" value="${reservation.adherent.idAdherent}">
                                <button type="submit" class="btn btn-custom btn-sm" style="background-color: #8B4513;">Convertir en Prêt</button>
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