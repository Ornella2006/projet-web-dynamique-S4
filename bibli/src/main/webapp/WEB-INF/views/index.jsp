<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion de Bibliothèque</title>
</head>
<body>
    <h1>Bienvenue dans la gestion de bibliothèque</h1>
    <a href="/pret">Prêter un livre</a>
    <c:if test="${not empty error}">
        <p style="color: red;">${error}</p>
    </c:if>
</body>
</html>