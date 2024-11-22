document.addEventListener("turbo:load", () => {
    const toggleButton = document.getElementById("dark-mode-toggle");
    const body = document.body;

    if (!toggleButton) {
        console.error("Dark mode toggle button not found!");
        return;
    }

    // Check for stored preference in localStorage
    const storedTheme = localStorage.getItem("theme") || "light";

    // Apply the stored theme on page load
    if (storedTheme === "dark") {
        body.classList.add("dark-mode");
        toggleButton.innerText = "Light Mode";
        toggleButton.classList.remove("btn-light");
        toggleButton.classList.add("btn-dark");
    } else {
        body.classList.remove("dark-mode");
        toggleButton.innerText = "Dark Mode";
        toggleButton.classList.remove("btn-dark");
        toggleButton.classList.add("btn-light");
    }

    // Prevent duplicate event listeners
    if (toggleButton.dataset.initialized === "true") return;
    toggleButton.dataset.initialized = "true";

    // Toggle dark mode on button click
    toggleButton.addEventListener("click", () => {
        const isDarkMode = body.classList.toggle("dark-mode");

        // Update button text and style
        toggleButton.innerText = isDarkMode ? "Light Mode" : "Dark Mode";
        toggleButton.classList.toggle("btn-dark", isDarkMode);
        toggleButton.classList.toggle("btn-light", !isDarkMode);

        // Store the new theme in localStorage
        localStorage.setItem("theme", isDarkMode ? "dark" : "light");
    });
});