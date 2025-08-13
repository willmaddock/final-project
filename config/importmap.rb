# config/importmap.rb
# Pin npm packages and local JavaScript files for Importmap

# Pin application entry point
pin "application", to: "application.js", preload: true

# Pin Turbo and Stimulus libraries
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

# Pin all controllers in the app/javascript/controllers directory
pin_all_from "app/javascript/controllers", under: "controllers"

# Pin Bootstrap JavaScript bundle (includes Popper)
pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js", preload: true

# Pin the dark mode toggle script
pin "dark_mode_toggle", to: "dark_mode_toggle.js", preload: true