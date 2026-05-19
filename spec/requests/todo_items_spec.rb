require 'rails_helper'

RSpec.describe 'TodoItems', type: :request do
  #test user, todo και token για τα τεστ
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:todo) { create(:todo, user: user) }

  describe 'POST /todos/:id/items' do
    it 'δημιουργεί νέο todo item' do
      post "/todos/#{todo.id}/items",
        params: { todo_item: { content: 'New Item', completed: false } },
        headers: headers

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['content']).to eq('New Item')
    end

    it 'αποτυγχάνει χωρίς content' do
      post "/todos/#{todo.id}/items",
        params: { todo_item: { content: '' } },
        headers: headers

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe 'GET /todos/:id/items/:iid' do
    it 'επιστρέφει ένα συγκεκριμένο todo item' do
      item = create(:todo_item, todo: todo)
      get "/todos/#{todo.id}/items/#{item.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(item.id)
    end

    it 'επιστρέφει 404 αν δεν βρεθεί το item' do
      get "/todos/#{todo.id}/items/99999", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PUT /todos/:id/items/:iid' do
    it 'ενημερώνει ένα todo item' do
      item = create(:todo_item, todo: todo)
      put "/todos/#{todo.id}/items/#{item.id}",
        params: { todo_item: { content: 'Updated Item', completed: true } },
        headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['content']).to eq('Updated Item')
      expect(JSON.parse(response.body)['completed']).to eq(true)
    end
  end

  describe 'DELETE /todos/:id/items/:iid' do
    it 'διαγράφει ένα todo item' do
      item = create(:todo_item, todo: todo)
      delete "/todos/#{todo.id}/items/#{item.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Todo item deleted successfully')
    end
  end
end