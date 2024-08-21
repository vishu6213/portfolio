function initMap() {
    const location = { lat: -25.344, lng: 131.036 };
// The map, centered at location
const map = new google.maps.Map(document.getElementById("map"), {
zoom: 4,
center: location,
});
// The marker, positioned at location
const marker = new google.maps.Marker({
position: location,
map: map,
});
}

// Modal functionality
function openModal(modalId) {
document.getElementById(modalId).style.display = "block";
}

function closeModal(modalId) {
document.getElementById(modalId).style.display = "none";
}

// Close modals when clicking outside of the modal content
window.onclick = function(event) {
let modals = document.querySelectorAll('.modal');
modals.forEach(modal => {
if (event.target === modal) {
modal.style.display = "none";
}
});
}

// Smooth scroll for navigation links
document.querySelectorAll('nav ul li a').forEach(anchor => {
anchor.addEventListener('click', function(e) {
e.preventDefault();

document.querySelector(this.getAttribute('href')).scrollIntoView({
behavior: 'smooth'
});
});
});
