<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Formulaire de prêt</title>
</head>
<body>
    <h2>Formulaire de prêt</h2>
    <form action="/pret" method="post">
        <label for="idAdherent">ID Adhérent:</label>
        <input type="number" id="idAdherent" name="idAdherent" required><br>
        <label for="idExemplaire">ID Exemplaire:</label>
        <input type="number" id="idExemplaire" name="idExemplaire" required><br>
        <label for="typePret">Type de prêt:</label>
        <select id="typePret" name="typePret">
            <option value="DOMICILE">Domicile</option>
            <option value="SUR_PLACE">Sur place</option>
        </select><br>
        <input type="submit" value="Valider le prêt">
    </form>
    <c:if test="${not empty message}">
        <p style="color: green;">${message}</p>
    </c:if>
    <c:if test="${not empty error}">
        <p style="color: red;">${error}</p>
    </c:if>
</body>
</html>