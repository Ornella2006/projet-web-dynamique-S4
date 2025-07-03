<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Prêter un livre</title>
</head>
<body>
    <h1>Prêter un livre</h1>
    <form action="/pret" method="post">
        <label>ID Adhérent:</label>
        <input type="number" name="adherentId" required><br>
        <label>ID Exemplaire:</label>
        <input type="number" name="exemplaireId" required><br>
        <label>Type de prêt:</label>
        <select name="typePret">
            <option value="sur_place">Lecture sur place</option>
            <option value="maison">À la maison</option>
        </select><br>
        <button type="submit">Prêter</button>
    </form>
    <c:if test="${not empty message}">
        <p style="color: green;">${message}</p>
    </c:if>
</body>
</html>