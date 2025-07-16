<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Convertir Réservation en Prêt</h2>
        <form action="/pret/admin/convertFinalize" method="post">
            <input type="hidden" name="idReservation" value="${reservation.idReservation}">
            <input type="hidden" name="nonce" value="<%= java.util.UUID.randomUUID().toString() %>">
            <div class="mb-3">
                <label for="idAdherent" class="form-label">ID Adhérent</label>
                <input type="number" class="form-control" id="idAdherent" name="adherentId" value="${reservation.adherent.idAdherent}" readonly>
            </div>
            <div class="mb-3">
                <label for="idExemplaire" class="form-label">ID Exemplaire</label>
                <input type="number" class="form-control" id="idExemplaire" name="exemplaireId" value="${reservation.exemplaire.idExemplaire}" readonly>
            </div>
            <div class="mb-3">
                <label for="typePret" class="form-label">Type de prêt</label>
                <input type="text" class="form-control" id="typePret" name="typePret" value="${reservation.typePret}" readonly>
            </div>
            <div class="mb-3">
                <label for="datePret" class="form-label">Date de prêt (optionnel)</label>
                <input type="date" class="form-control" id="datePret" name="datePret" value="${today}">
            </div>
            <div class="mb-3">
                <label for="dateRetourPrevue" class="form-label">Date de retour prévue (optionnel)</label>
                <input type="date" class="form-control" id="dateRetourPrevue" name="dateRetourPrevue">
            </div>
            <button type="submit" class="btn btn-custom w-100">Finaliser le prêt</button>
            <c:if test="${not empty message}">
                <p class="success">${message}</p>
            </c:if>
            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>
        </form>
        <a href="/admin/validatedReservations" class="btn btn-custom mt-3 w-100">Retour</a>
    </div>
</c:set>
<%@ include file="adminDashboard.jsp" %>
