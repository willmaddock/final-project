# Final Project Repository

## Overview
This repository contains the source code and documentation for my final project, a Rails-based web application developed as part of my academic journey. I served as the founder and web developer, driving the design, implementation, and testing of the project.

## Project Description
The project focuses on creating a web app with role-based access control and security clearance features, enhancing user experience for stakeholders such as Shipping Agents and Logistics Managers. The application leverages modern web technologies and follows agile methodologies to ensure efficient workflows and maintainable code.

## Features
- Role-based access control (RBAC) with dynamic permission management
- Real-time feedback mechanisms for restricted access areas
- Responsive UI with dark mode integration using CSS media queries and JavaScript toggles
- Scalable database schema for permission storage
- Rspec testing including unit and system tests with Capybara

## Getting Started
1. Clone the repository: `git clone https://github.com/willmaddock/final-project.git`
2. Navigate to the project directory: `cd final-project`
3. Install dependencies: `bundle install`
4. Set up the database: `rails db:migrate`
5. Start the server: `rails server`
6. Access the app at `http://localhost:3000`

## Models and Relationships
- **User Model**: Manages user authentication and roles (e.g., admin, shipping_agent, logistics_manager).
- **Profile Model**: One-to-one relationship with User, storing personal details.
- **AccessPoint Model**: Manages access points with location, access_level, and status.
- **AccessLog Model**: One-to-many relationship with User and AccessPoint, logging access attempts.

## Testing
- Unit tests for model validations and role-based authorizations (spec/models/user_spec.rb)
- System tests with Capybara for user stories (spec/system/agent_login_spec.rb, spec/system/restricted_area_access_spec.rb)

## UI and Accessibility
- Implemented with Bootstrap for responsiveness
- Designed for accessibility with ARIA labels, high-contrast modes, and keyboard navigation
- Supports users with diverse needs (e.g., autistic spectrum, low vision, motor disabilities)

## Sprint Details
- **Sprint 01**: Initial setup, model creation, and basic routes.
- **Sprint 02**: Enhanced RBAC, UI improvements, and testing implementation.

## Resources
- [MDN Web Docs](https://developer.mozilla.org)
- [Ruby on Rails Guides](https://guides.rubyonrails.org)
- [Accessibility Blog](https://accessibility.blog.gov.uk)

## License
This project is for educational purposes only.
