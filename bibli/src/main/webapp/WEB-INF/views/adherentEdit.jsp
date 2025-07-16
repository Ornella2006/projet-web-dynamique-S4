<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/admin.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Modifier l'Adhérent</h2>
        <form action="/admin/adherents/edit/${adherent.idAdherent}" method="post">
            <input type="hidden" name="idAdherent" value="${adherent.idAdherent}">
            <div class="mb-3">
                <label for="profil" class="form-label">Profil</label>
                <select class="form-control" id="profil" name="profil.idProfil" required>
                    <c:forEach var="profil" items="${profils}">
                        <option value="${profil.idProfil}" ${profil.idProfil == adherent.profil.idProfil ? 'selected' : ''}>
                            ${profil.typeProfil}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="mb-3">
                <label for="nom" class="form-label">Nom</label>
                <input type="text" class="form-control" id="nom" name="nom" value="${adherent.nom}" required>
            </div>
            <div class="mb-3">
                <label for="prenom" class="form-label">Prénom</label>
                <input type="text" class="form-control" id="prenom" name="prenom" value="${adherent.prenom}" required>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" value="${adherent.email}">
            </div>
            <div class="mb-3">
                <label for="telephone" class="form-label">Téléphone</label>
                <input type="text" class="form-control" id="telephone" name="telephone" value="${adherent.telephone}">
            </div>
            <div class="mb-3">
                <label for="dateNaissance" class="form-label">Date de naissance</label>
                <input type="date" class="form-control" id="dateNaissance" name="dateNaissance" value="${adherent.dateNaissance}" required>
            </div>
            <div class="mb-3">
                <label for="statut" class="form-label">Statut</label>
                <select class="form-control" id="statut" name="statut" required>
                    <option value="ACTIF" ${adherent.statut == 'ACTIF' ? 'selected' : ''}>Actif</option>
                    <option value="INACTIF" ${adherent.statut == 'INACTIF' ? 'selected' : ''}>Inactif</option>
                    <option value="SANCTIONNE" ${adherent.statut == 'SANCTIONNE' ? 'selected' : ''}>Sanctionné</option>
                </select>
            </div>
            <button type="submit" class="btn btn-custom w-100">Enregistrer</button>
        </form>
        <a href="/admin/adherents" class="btn btn-custom mt-3 w-100">Retour</a>
    </div>
</c:set>
<%@ include file="adminDashboard.jsp" %>