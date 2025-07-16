<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Définir des Restrictions</h2>
        <form action="/definirRestrictions" method="post">
            <div class="mb-3">
                <label for="idLivre" class="form-label">ID Livre</label>
                <input type="number" class="form-control" id="idLivre" name="idLivre" required>
            </div>
            <div class="mb-3">
                <label for="restrictionAge" class="form-label">Âge minimum (optionnel)</label>
                <input type="number" class="form-control" id="restrictionAge" name="restrictionAge">
            </div>
            <div class="mb-3">
                <label for="professeurSeulement" class="form-label">Réservé aux professeurs ?</label>
                <select class="form-control" id="professeurSeulement" name="professeurSeulement">
                    <option value="false">Non</option>
                    <option value="true">Oui</option>
                </select>
            </div>
            <button type="submit" class="btn btn-custom w-100">Mettre à jour Restrictions</button>
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