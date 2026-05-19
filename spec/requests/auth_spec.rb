require 'rails_helper'

RSpec.describe 'Auth', type: :request do
  #τεστ για το signup
  describe 'POST /signup' do
    it 'δημιουργεί νέο χρήστη και επιστρέφει token' do
      post '/signup', params: { email: 'new@test.com', password: '123456' }
      
      #ελεγχος οτι η απάντηση είναι 201 Created
      expect(response).to have_http_status(:created)
      #ελεγχος ότι υπάρχει token στην απάντηση
      expect(JSON.parse(response.body)).to include('token')
    end

    it 'αποτυγχάνει αν το email υπάρχει ήδη' do
      create(:user, email: 'exists@test.com')
      post '/signup', params: { email: 'exists@test.com', password: '123456' }

      #ελεγχος ότι η απάντηση είναι 422 Unprocessable Entity
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  #τεστ για το login
  describe 'POST /auth/login' do
    let(:user) { create(:user, email: 'login@test.com', password: '123456') }

    it 'συνδέεται με σωστά στοιχεία και επιστρέφει token' do
      post '/auth/login', params: { email: user.email, password: '123456' }

      #έλεγχος ότι η απάντηση είναι 200 OK
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('token')
    end

    it 'αποτυγχάνει με λάθος password' do
      post '/auth/login', params: { email: user.email, password: 'wrongpassword' }

      #ελεγχος ότι η απάντηση είναι 401 Unauthorized
      expect(response).to have_http_status(:unauthorized)
    end
  end

  #τεστ για το logout
  describe 'GET /auth/logout' do
    it 'επιστρέφει μήνυμα επιτυχίας' do
      get '/auth/logout'

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Logged out successfully')
    end
  end
end