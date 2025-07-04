<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Formulaire de prêt</title>
</head>
<body>
    <h2>Formulaire de prêt</h2>
    <form action="/pret" method="post">
        <label for="idAdherent">ID Adhérent:</label>
        <input type="number" id="idAdherent" name="adherentId" required><br>

        <label for="idExemplaire">ID Exemplaire:</label>
        <input type="number" id="idExemplaire" name="exemplaireId" required><br>

        <label for="typePret">Type de prêt:</label>
        <select id="typePret" name="typePret">
            <option value="SUR_PLACE">Sur place</option>
            <option value="DOMICILE">Domicile</option>
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
