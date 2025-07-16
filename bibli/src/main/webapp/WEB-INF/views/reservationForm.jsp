<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/css/adherent.css" rel="stylesheet">
<c:set var="content">
    <div class="form-container">
        <h2>Réserver un Exemplaire</h2>
        <div class="mb-3">
            <input type="text" class="form-control" id="searchBar" placeholder="Rechercher un exemplaire..." onkeyup="filterExemplaires()">
            <input type="number" class="form-control mt-2" id="idFilter" placeholder="Filtrer par ID (optionnel)" onkeyup="filterExemplairesById()">
        </div>
        <div class="row" id="exemplaireCards">
            <c:forEach var="exemplaire" items="${exemplaires}">
                <c:if test="${exemplaire.statut == 'DISPONIBLE'}">
                    <div class="col-md-4 mb-3">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Exemplaire ID: ${exemplaire.idExemplaire}</h5>
                                <p class="card-text">Titre: ${exemplaire.livre.titre}</p>
                                <p class="card-text">Auteur: ${exemplaire.livre.auteur}</p>
                                <p class="card-text">ISBN: ${exemplaire.livre.isbn}</p>
                                <p class="card-text">Âge min: ${exemplaire.livre.restrictionAge}</p>
                                <p class="card-text">Professeurs seulement: ${exemplaire.livre.professeurSeulement ? 'Oui' : 'Non'}</p>
                                <button class="btn btn-custom select-btn" data-id="${exemplaire.idExemplaire}">Sélectionner</button>
                            </div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
        <form id="reservationForm" action="/adherent/reservation" method="post" class="mt-4" onsubmit="return validateForm()">
            <input type="hidden" id="exemplaireId" name="exemplaireId" value="">
            <div class="mb-3">
                <label for="typePret" class="form-label">Type de prêt</label>
                <select class="form-control" id="typePret" name="typePret" required>
                    <option value="lecture_sur_place">Lecture sur place</option>
                    <option value="domicile">Domicile</option>
                </select>
            </div>
            <div class="mb-3">
                <label for="dateRetraitPrevue" class="form-label">Date de retrait prévue</label>
                <input type="date" class="form-control" id="dateRetraitPrevue" name="dateRetraitPrevue" required>
            </div>
            <button type="submit" class="btn btn-custom w-100">Soumettre la réservation</button>
            <c:if test="${not empty message}">
                <p class="success">${message}</p>
            </c:if>
            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>
        </form>
        <a href="/adherent/dashboard" class="btn btn-custom mt-3 w-100">Retour au tableau de bord</a>
    </div>
    <script>
        let selectedId = null;

        document.querySelectorAll('.select-btn').forEach(button => {
            button.addEventListener('click', function() {
                selectedId = this.getAttribute('data-id');
                document.getElementById('exemplaireId').value = selectedId;
                document.querySelectorAll('.select-btn').forEach(btn => btn.classList.remove('selected'));
                this.classList.add('selected');
            });
        });

        function filterExemplaires() {
            let input = document.getElementById("searchBar").value.toLowerCase();
            let idInput = document.getElementById("idFilter").value;
            let cards = document.getElementById("exemplaireCards").getElementsByClassName("card");
            for (let i = 0; i < cards.length; i++) {
                let title = cards[i].getElementsByTagName("h5")[0].innerText.toLowerCase();
                let text = cards[i].innerText.toLowerCase();
                let id = cards[i].getElementsByTagName("h5")[0].innerText.match(/\d+/)[0];
                if ((text.includes(input) || input === "") && (idInput === "" || id === idInput)) {
                    cards[i].parentElement.style.display = "";
                } else {
                    cards[i].parentElement.style.display = "none";
                }
            }
        }

        function filterExemplairesById() {
            let idInput = document.getElementById("idFilter").value;
            if (idInput && !selectedId) { // Mettre à jour exemplaireId uniquement si aucune carte n'est sélectionnée
                document.getElementById('exemplaireId').value = idInput;
            }
            filterExemplaires();
        }

        function validateForm() {
            if (!document.getElementById('exemplaireId').value) {
                alert("Veuillez sélectionner un exemplaire ou entrer un ID valide.");
                return false;
            }
            return true;
        }
    </script>
    <style>
        .selected {
            background-color: #28a745;
            color: white;
        }
    </style>
</c:set>
<%@ include file="adherentDashboard.jsp" %>