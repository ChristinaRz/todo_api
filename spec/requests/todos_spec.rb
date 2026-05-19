require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  #test user και token για τα τεστ
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET /todos' do
    it 'επιστρέφει όλα τα todos του χρήστη' do
      # 3 todos για τον test user
      create_list(:todo, 3, user: user)
      get '/todos', headers: headers

      expect(response).to have_http_status(:ok)
      #έλεγχος ότι επιστρέφονται 3 todos
      expect(JSON.parse(response.body).size).to eq(3)
    end

    it 'αποτυγχάνει χωρίς token' do
      get '/todos'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /todos' do
    it 'δημιουργεί νέο todo' do
      post '/todos',
        params: { todo: { title: 'New Todo', description: 'New Description' } },
        headers: headers

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['title']).to eq('New Todo')
    end

    it 'αποτυγχάνει χωρίς τίτλο' do
      post '/todos',
        params: { todo: { title: '' } },
        headers: headers

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe 'GET /todos/:id' do
    it 'επιστρέφει ένα συγκεκριμένο todo' do
      todo = create(:todo, user: user)
      get "/todos/#{todo.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(todo.id)
    end

    it 'επιστρέφει 404 αν δεν βρεθεί το todo' do
      get '/todos/99999', headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PUT /todos/:id' do
    it 'ενημερώνει ένα todo' do
      todo = create(:todo, user: user)
      put "/todos/#{todo.id}",
        params: { todo: { title: 'Updated Title' } },
        headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['title']).to eq('Updated Title')
    end
  end

  describe 'DELETE /todos/:id' do
    it 'διαγράφει ένα todo' do
      todo = create(:todo, user: user)
      delete "/todos/#{todo.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Todo deleted successfully')
    end
  end
end