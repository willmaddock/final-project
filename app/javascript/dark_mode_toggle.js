// app/javascript/dark_mode_toggle.js

document.addEventListener("turbo:load", () => {
    const toggleButton = document.getElementById("dark-mode-toggle");
    const body = document.body;

    // Check for stored preference in localStorage
    const isDarkMode = localStorage.getItem("dark-mode") === "true";

    // Apply the stored preference on page load
    if (isDarkMode) {
        body.classList.add("dark-mode");
        toggleButton.innerText = "Light Mode";
        toggleButton.classList.remove("btn-light");
        toggleButton.classList.add("btn-dark");
    }

    // Toggle dark mode on button click
    toggleButton.addEventListener("click", () => {
        body.classList.toggle("dark-mode");

        // Update button text and style based on the current mode
        if (body.classList.contains("dark-mode")) {
            toggleButton.innerText = "Light Mode";
            toggleButton.classList.remove("btn-light");
            toggleButton.classList.add("btn-dark");
            localStorage.setItem("dark-mode", "true");
        } else {
            toggleButton.innerText = "Dark Mode";
            toggleButton.classList.remove("btn-dark");
            toggleButton.classList.add("btn-light");
            localStorage.setItem("dark-mode", "false");
        }
    });
});