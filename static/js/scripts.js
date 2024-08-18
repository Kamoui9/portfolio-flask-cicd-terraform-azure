// scripts.js
// navbar
navLinks = document.querySelectorAll('a');
navLinks.forEach(link => {
if (link.href === window.location.href) {
    link.classList.add('active');
}
});

// footer
date = new Date();
document.querySelector("#copyright").innerHTML = "© Matéo Pannetier, " + date.getFullYear();