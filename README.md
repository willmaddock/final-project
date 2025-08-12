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

## Getting Started (Local Development)
1. Clone the repository:
   git clone https://github.com/willmaddock/final-project.git
   cd final-project

2. Install dependencies:
   bundle install

3. Set up the database:
   rails db:create
   rails db:migrate
   rails db:seed
   # Seeds include 52 user accounts generated with Faker for testing role-based access.

4. Start the server:
   rails server

5. Visit the app at http://localhost:3000

### 🔑 Default Login Credentials
To access the app immediately after setup, use the following seeded account:

Login: logistics_manager@example.com  
Password: password

> Without this, it's impossible to use the app—so keep it handy!

## Deployment (Render)
This app is deployed on Render, a cloud platform for full-stack applications.

### 🔧 Setup Steps
1. Ensure `pg` is used in the Gemfile for PostgreSQL.
2. Add a Procfile:
   web: bundle exec rails server

3. Set environment variables on Render:
    - RAILS_MASTER_KEY (from config/master.key)
    - DATABASE_URL (from Render’s PostgreSQL service)

### 🚀 Deploy Instructions
- Connect your GitHub repo to Render
- Use the following build and start commands:
  bundle install && bundle exec rails assets:precompile
  bundle exec rails server

- Run migrations and seeds via Render Shell:
  rails db:migrate
  rails db:seed

## Models and Relationships
- User: Authenticates users and assigns roles (admin, shipping_agent, logistics_manager)
- Profile: One-to-one with User; stores personal details
- AccessPoint: Defines secure locations with access levels
- AccessLog: Tracks access attempts; belongs to User and AccessPoint

## Testing
- ✅ Unit tests for model validations and role logic (spec/models/user_spec.rb)
- 🧪 System tests for user flows and access control (spec/system/agent_login_spec.rb, spec/system/restricted_area_access_spec.rb)

## UI and Accessibility
- Built with Bootstrap for responsive design
- ARIA labels, high-contrast modes, and keyboard navigation for accessibility
- Inclusive design for users with autism, low vision, and motor disabilities

## Sprint Details
- Sprint 01: Initial setup, model scaffolding, and basic routing
- Sprint 02: RBAC implementation, UI enhancements, and test coverage
- Sprint 03: Accessibility features, seeded data, and deployment prep

## Resources
- MDN Web Docs: https://developer.mozilla.org
- Ruby on Rails Guides: https://guides.rubyonrails.org
- Accessibility Blog: https://accessibility.blog.gov.uk

## License
This project is for educational purposes only.
