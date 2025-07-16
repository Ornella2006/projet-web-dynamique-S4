<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Formulaire de Prêt</h2>
        <form action="/pret/admin/pret" method="post">
            <div class="mb-3">
                <label for="idAdherent" class="form-label">ID Adhérent</label>
                <input type="number" class="form-control" id="idAdherent" name="adherentId" required>
            </div>
            <div class="mb-3">
                <label for="idExemplaire" class="form-label">ID Exemplaire</label>
                <input type="number" class="form-control" id="idExemplaire" name="exemplaireId" required>
            </div>
            <div class="mb-3">
                <label for="typePret" class="form-label">Type de prêt</label>
                <select class="form-control" id="typePret" name="typePret" required>
                    <option value="SUR_PLACE">Sur place</option>
                    <option value="DOMICILE">Domicile</option>
                </select>
            </div>
           <div class="mb-3">
                <label for="datePret" class="form-label">Date de prêt (optionnel)</label>
                <input type="date" class="form-control" id="datePret" name="datePret" value="${now}">
            </div>
            <div class="mb-3">
                <label for="dateRetourPrevue" class="form-label">Date de retour prévue (optionnel)</label>
                <input type="date" class="form-control" id="dateRetourPrevue" name="dateRetourPrevue">
            </div>
            <!-- <div class="mb-3">
                <label for="datePret" class="form-label">Date de prêt (optionnel)</label>
                <input type="date" class="form-control" id="datePret" name="datePret">
            </div>
            <div class="mb-3">
                <label for="dateRetourPrevue" class="form-label">Date de retour prévue (optionnel)</label>
                <input type="date" class="form-control" id="dateRetourPrevue" name="dateRetourPrevue">
            </div> -->
            <button type="submit" class="btn btn-custom w-100">Valider le prêt</button>
            <c:if test="${not empty message}">
    <p class="success">${message}</p>
</c:if>
<c:if test="${not empty adjustedDate}">
    <p class="info">Date de retour prévue : ${adjustedDate}</p>
</c:if>
<c:if test="${not empty error}">
    <p class="error">${error}</p>
</c:if>
        </form>
        <a href="/admin/dashboard" class="btn btn-custom mt-3 w-100">Retour au tableau de bord</a>
    </div>
</c:set>
<%@ include file="adminDashboard.jsp" %>