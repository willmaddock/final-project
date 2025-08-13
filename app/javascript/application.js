// app/javascript/application.js
// Entry point for the build script in your package.json

// Import Turbo and Stimulus libraries
import "@hotwired/turbo-rails";
import "@hotwired/stimulus";
import "@hotwired/stimulus-loading";

// Import all controllers
import "./controllers";

// Import Bootstrap JavaScript
import "bootstrap";

// Import Dark Mode Toggle Script
import "./dark_mode_toggle";

// Ensure compatibility with Turbo for page loads
document.addEventListener("turbo:load", () => {
    console.log("Turbo has loaded the page");
});