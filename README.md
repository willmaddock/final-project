# Final Project Repository

## Overview
This repository contains the source code and documentation for my final project, a Rails-based web application developed as part of my academic journey. I served as the founder and web developer, driving the design, implementation, and testing of the project.

## Project Description
The application provides role-based access control and security clearance features tailored for stakeholders such as Shipping Agents and Logistics Managers. It emphasizes accessibility, responsive design, and secure data handling, built using modern web technologies and agile development practices.

## Features
- 🔐 Role-based access control (RBAC) with dynamic permission management
- 🚫 Real-time feedback for restricted access attempts
- 🌙 Responsive UI with dark mode via CSS media queries and JavaScript toggles
- 🗃️ Scalable database schema for permission and access logs
- ✅ RSpec testing with unit and system coverage using Capybara

## Getting Started & Deployment

# 1. Clone the repository
git clone https://github.com/willmaddock/final-project.git
cd final-project

# 2. Install dependencies
bundle install

# 3. Reset and migrate the database
bundle exec rails db:drop db:create db:migrate

# 4. Seed the database with test data
bundle exec rails db:seed
# ✅ Creates 52 users, 52 profiles, 144 access logs, 10 access points, and 29 elevated access requests

# 5. Precompile assets (optional for local, required for deployment)
bundle exec rake assets:precompile

# 6. Start the Rails server
rails server
# Visit http://localhost:3000

# 🔑 Default Login Credentials
# Use this seeded account to access the app:
# Email: logistics_manager@example.com
# Password: password

# 🧪 Optional: Run seeds via controller route
# Useful for resetting data during demos
curl http://localhost:3000/run_seeds

# 🌐 Render Deployment Steps

# Ensure PostgreSQL is used in Gemfile (pg)
# Add a Procfile with:
echo "web: bundle exec rails server" > Procfile

# Set environment variables on Render:
# - RAILS_MASTER_KEY (from config/master.key)
# - DATABASE_URL (from Render PostgreSQL)

# Build & start commands for Render:
bundle install && bundle exec rails assets:precompile
bundle exec rails server

# Run migrations and seeds via Render Shell:
rails db:migrate
rails db:seed

## Models and Relationships
# - User: Authenticates users and assigns roles (admin, shipping_agent, logistics_manager)
# - Profile: One-to-one with User; stores personal details
# - AccessPoint: Defines secure locations with access levels
# - AccessLog: Tracks access attempts; belongs to User and AccessPoint

## Testing
# ✅ Unit tests for model validations and role logic (spec/models/user_spec.rb)
# 🧪 System tests for user flows and access control (spec/system/agent_login_spec.rb, spec/system/restricted_area_access_spec.rb)

## UI and Accessibility
# - Built with Bootstrap for responsive design
# - ARIA labels, high-contrast modes, and keyboard navigation for accessibility
# - Inclusive design for users with autism, low vision, and motor disabilities

## Sprint Details
# - Sprint 01: Initial setup, model scaffolding, and basic routing
# - Sprint 02: RBAC implementation, UI enhancements, and test coverage
# - Sprint 03: Accessibility features, seeded data, and deployment prep

## Resources
# - MDN Web Docs: https://developer.mozilla.org
# - Ruby on Rails Guides: https://guides.rubyonrails.org
# - Accessibility Blog: https://accessibility.blog.gov.uk

## License
# This project is for educational purposes only.
