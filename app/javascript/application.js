// app/javascript/application.js

// Import Turbo and Stimulus libraries
import "@hotwired/turbo-rails";
import "@hotwired/stimulus";
import "@hotwired/stimulus-loading";

// Import Bootstrap JavaScript
import "bootstrap";  // Ensure Bootstrap is imported here

// Ensure compatibility with Turbo for DELETE requests in links
document.addEventListener("turbo:load", () => {
    // Any additional JavaScript code can go here
    console.log("Turbo has loaded the page");
});