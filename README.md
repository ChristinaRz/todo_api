# Todo API

A REST API for managing todos and todo items, built with Ruby on Rails.

## Technologies
- Ruby on Rails (API mode)
- PostgreSQL
- JWT Authentication
- RSpec (Testing)
- Swagger/OpenAPI (Documentation)

## Installation
git clone https://github.com/ChristinaRz/todo_api.git
cd todo_api
bundle install
rails db:create db:migrate
rails server


## API Documentation
After starting the server, the Swagger documentation is available at:
http://localhost:3000/api-docs

## Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /signup | Register a new user |
| POST | /auth/login | Login |
| GET | /auth/logout | Logout |
| GET | /todos | List all todos |
| POST | /todos | Create a todo |
| GET | /todos/:id | Get a todo |
| PUT | /todos/:id | Update a todo |
| DELETE | /todos/:id | Delete a todo |
| GET | /todos/:id/items/:iid | Get a todo item |
| POST | /todos/:id/items | Create a todo item |
| PUT | /todos/:id/items/:iid | Update a todo item |
| DELETE | /todos/:id/items/:iid | Delete a todo item |

## Running Tests
bundle exec rspec


## Academic Context
Developed for SaaS project (2025-2026)