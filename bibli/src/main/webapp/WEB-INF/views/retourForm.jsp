<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Retourner un Prêt</h2>
        <form action="/admin/retour" method="post">
            <div class="mb-3">
                <label for="idPret" class="form-label">ID du Prêt</label>
                <input type="number" class="form-control" id="idPret" name="idPret" required>
            </div>
            <button type="submit" class="btn btn-custom w-100">Retourner le prêt</button>
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