require 'swagger_helper'

RSpec.describe 'Todo API Documentation', type: :request do

  #AUTH
  path '/signup' do
    post 'Εγγραφή νέου χρήστη' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: '123456' }
        },
        required: ['email', 'password']
      }

      response '201', 'Χρήστης δημιουργήθηκε' do
        let(:user) { { email: 'new@example.com', password: '123456' } }
        run_test!
      end

      response '422', 'Μη έγκυρα στοιχεία' do
        let(:user) { { email: '', password: '' } }
        run_test!
      end
    end
  end

  path '/auth/login' do
    post 'Σύνδεση χρήστη' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: '123456' }
        },
        required: ['email', 'password']
      }

      response '200', 'Επιτυχής σύνδεση' do
        let(:credentials) { { email: 'user@example.com', password: '123456' } }
        before { User.create!(email: 'user@example.com', password: '123456') }
        run_test!
      end

      response '401', 'Λάθος στοιχεία' do
        let(:credentials) { { email: 'wrong@example.com', password: 'wrong' } }
        run_test!
      end
    end
  end

  path '/auth/logout' do
    get 'Αποσύνδεση χρήστη' do
      tags 'Authentication'
      produces 'application/json'

      response '200', 'Επιτυχής αποσύνδεση' do
        run_test!
      end
    end
  end

  #TODOS
  path '/todos' do
    get 'Λίστα όλων των todos' do
      tags 'Todos'
      security [bearerAuth: []]
      produces 'application/json'

      response '200', 'Επιτυχής ανάκτηση' do
        let(:user) { User.create!(email: 'test@test.com', password: '123456') }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
        run_test!
      end

      response '401', 'Μη εξουσιοδοτημένος' do
        let(:Authorization) { 'Bearer invalid' }
        run_test!
      end
    end

    post 'Δημιουργία νέου todo' do
      tags 'Todos'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :todo, in: :body, schema: {
        type: :object,
        properties: {
          todo: {
            type: :object,
            properties: {
              title: { type: :string, example: 'My Todo' },
              description: { type: :string, example: 'My Description' }
            },
            required: ['title']
          }
        }
      }

      response '201', 'Todo δημιουργήθηκε' do
        let(:user) { User.create!(email: 'test2@test.com', password: '123456') }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
        let(:todo) { { todo: { title: 'Test', description: 'Test' } } }
        run_test!
      end
    end
  end

  path '/todos/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'ID του todo'

    get 'Ανάκτηση συγκεκριμένου todo' do
      tags 'Todos'
      security [bearerAuth: []]
      produces 'application/json'

      response '200', 'Επιτυχής ανάκτηση' do
        let(:user) { User.create!(email: 'test3@test.com', password: '123456') }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
        let(:id) { user.todos.create!(title: 'Test').id }
        run_test!
      end

      response '404', 'Δεν βρέθηκε' do
        let(:user) { User.create!(email: 'test4@test.com', password: '123456') }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
        let(:id) { 99999 }
        run_test!
      end
    end

    put 'Ενημέρωση todo' do
      tags 'Todos'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :todo, in: :body, schema: {
        type: :object,
        properties: {
          todo: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string }
            }
          }
        }
      }

      response '200', 'Todo ενημερώθηκε' do
        let(:user) { User.create!(email: 'test5@test.com', password: '123456') }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
        let(:id) { user.todos.create!(title: 'Test').id }
        let(:todo) { { todo: { title: 'Updated' } } }
        run_test!
      end
    end

    delete 'Διαγραφή todo' do
      tags 'Todos'
      security [bearerAuth: []]
      produces 'application/json'

      response '200', 'Todo διαγράφηκε' do
        let(:user) { User.create!(email: 'test6@test.com', password: '123456') }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
        let(:id) { user.todos.create!(title: 'Test').id }
        run_test!
      end
    end
  end

  #TODO ITEMS
  path '/todos/{id}/items' do
    parameter name: :id, in: :path, type: :integer, description: 'ID του todo'

    post 'Δημιουργία νέου todo item' do
      tags 'Todo Items'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :todo_item, in: :body, schema: {
        type: :object,
        properties: {
          todo_item: {
            type: :object,
            properties: {
              content: { type: :string, example: 'My item' },
              completed: { type: :boolean, example: false }
            },
            required: ['content']
          }
        }
      }

      response '201', 'Item δημιουργήθηκε' do
        let(:user) { User.create!(email: 'test7@test.com', password: '123456') }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
        let(:id) { user.todos.create!(title: 'Test').id }
        let(:todo_item) { { todo_item: { content: 'Test item', completed: false } } }
        run_test!
      end
    end
  end

  path '/todos/{id}/items/{iid}' do
    parameter name: :id, in: :path, type: :integer, description: 'ID του todo'
    parameter name: :iid, in: :path, type: :integer, description: 'ID του todo item'

    get 'Ανάκτηση συγκεκριμένου todo item' do
      tags 'Todo Items'
      security [bearerAuth: []]
      produces 'application/json'

      response '200', 'Επιτυχής ανάκτηση' do
        let(:user) { User.create!(email: 'test8@test.com', password: '123456') }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
        let(:todo) { user.todos.create!(title: 'Test') }
        let(:id) { todo.id }
        let(:iid) { todo.todo_items.create!(content: 'Test item').id }
        run_test!
      end
    end

    put 'Ενημέρωση todo item' do
      tags 'Todo Items'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :todo_item, in: :body, schema: {
        type: :object,
        properties: {
          todo_item: {
            type: :object,
            properties: {
              content: { type: :string },
              completed: { type: :boolean }
            }
          }
        }
      }

      response '200', 'Item ενημερώθηκε' do
        let(:user) { User.create!(email: 'test9@test.com', password: '123456') }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
        let(:todo) { user.todos.create!(title: 'Test') }
        let(:id) { todo.id }
        let(:iid) { todo.todo_items.create!(content: 'Test item').id }
        let(:todo_item) { { todo_item: { content: 'Updated', completed: true } } }
        run_test!
      end
    end

    delete 'Διαγραφή todo item' do
      tags 'Todo Items'
      security [bearerAuth: []]
      produces 'application/json'

      response '200', 'Item διαγράφηκε' do
        let(:user) { User.create!(email: 'test10@test.com', password: '123456') }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
        let(:todo) { user.todos.create!(title: 'Test') }
        let(:id) { todo.id }
        let(:iid) { todo.todo_items.create!(content: 'Test item').id }
        run_test!
      end
    end
  end
end