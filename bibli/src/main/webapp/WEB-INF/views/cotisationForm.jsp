<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Renouveler une Cotisation</h2>
        <form action="/admin/renouvelerCotisation" method="post">
            <div class="mb-3">
                <label for="idAdherent" class="form-label">ID Adhérent</label>
                <input type="number" class="form-control" id="idAdherent" name="idAdherent" required>
            </div>
            <div class="mb-3">
                <label for="dateDebut" class="form-label">Date de début</label>
                <input type="date" class="form-control" id="dateDebut" name="dateDebut" required>
            </div>
            <div class="mb-3">
                <label for="dateFin" class="form-label">Date de fin</label>
                <input type="date" class="form-control" id="dateFin" name="dateFin" required>
            </div>
            <div class="mb-3">
                <label for="montant" class="form-label">Montant</label>
                <input type="number" step="0.01" class="form-control" id="montant" name="montant" required>
            </div>
            <button type="submit" class="btn btn-custom w-100">Renouveler Cotisation</button>
            <c:if test="${not empty message}">
                <p class="success">${message}</p>
            </c:if>
            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>
        </form>
        <a href="/admin/dashboard" class="btn btn-custom mt-3 w-100">Retour au tableau de bord</a>
    </div>
</c:set>
<%@ include file="adminDashboard.jsp" %>