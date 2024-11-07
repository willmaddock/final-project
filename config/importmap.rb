# config/importmap.rb

# Pin application entry point
pin "application"

# Pin Turbo and Stimulus libraries
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

# Pin all controllers in the app/javascript/controllers directory
pin_all_from "app/javascript/controllers", under: "controllers"

# Pin Bootstrap JavaScript bundle (which includes Popper)
pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js", preload: true