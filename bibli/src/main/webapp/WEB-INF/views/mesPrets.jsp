<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/adherent.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Mes Prêts</h2>
        <table class="table">
            <thead>
                <tr>
                    <th>ID Prêt</th>
                    <th>Titre</th>
                    <th>Date de Retour Prévue</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="pret" items="${prets}">
                    <tr>
                        <td>${pret.idPret}</td>
                        <td>${pret.exemplaire.livre.titre}</td>
                        <td>${pret.dateRetourPrevue}</td>
                        <c:if test="${pret.prolongationCount < adherent.profil.quotaProlongement and adherent.quotaRestant > 0}">
                            <td>
                                <form action="/pret/demanderProlongation" method="get" style="display:inline;">
                                    <input type="hidden" name="idPret" value="${pret.idPret}">
                                    <input type="date" name="nouvelleDateRetour" required>
                                    <button type="submit" class="btn btn-custom btn-sm">Demander Prolongation</button>
                                </form>
                            </td>
                        </c:if>
                        <c:if test="${pret.prolongationCount >= adherent.profil.quotaProlongement or adherent.quotaRestant <= 0}">
                            <td><span class="text-danger">Prolonger avec succes pour Les Misérables pour adherent</span></td>
                        </c:if>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <c:if test="${not empty message}">
            <p class="success">Prolonger avec succes pour Les Misérables pour adherent 1</p>
        </c:if>
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        <a href="/adherent/dashboard" class="btn btn-custom mt-3 w-100">Retour au tableau de bord</a>
    </div>
</c:set>
<%@ include file="adherentDashboard.jsp" %>