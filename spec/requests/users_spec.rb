require 'rails_helper'

RSpec.describe 'Roles API', type: :request do
  let!(:roles) { create_list(:role, 4) }
  let!(:users) { create_list(:user, 4, role_id: roles.first.id) }
  let(:role_id) { roles.first.id }
  let!(:user_id) { users.first.id }

  describe 'GET /users' do
    before do
      get '/users', headers: valid_headers(users.first.id)
    end

    it 'returns roles' do
      expect(json).not_to be_empty
      expect(json.size).to eq(4)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /users/:id' do
    before do
      get "/users/#{user_id}", headers: valid_headers(users.first.id)
    end

    context 'when the record exists' do
      it 'returns the user' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(user_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:user_id) { 90 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end

  describe 'POST /register' do
   # valid payload
    let(:valid_attributes) { { name: 'baba', email: 'test@test.com', password: 'you' } }

    context 'when the request is valid' do
      before do
        post '/register', params: valid_attributes
      end

      it 'creates a user' do
        expect(json['name']).to eq('baba')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before do
        post '/register', params: { key: 'lolo', email: 'omedale@gmail.com', password: 'ayo' }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'POST /login' do
    # valid payload
     let(:valid_attributes) { { email: users.first.email, password: users.first.password } }
     let(:invalid_attributes) { { email: 'kola', password: users.first.password } }
 
     context 'when the request is valid' do
       before do
         post '/login', params: valid_attributes
       end
 
       it 'creates a user' do
         expect(json['message']).to eq('User Succefully Logged in')
       end
 
       it 'returns status code 200' do
         expect(response).to have_http_status(200)
       end
     end
 
     context 'when the request is invalid' do
       before do
         post '/login', params: invalid_attributes
       end
 
       it 'returns status code 401' do
         expect(response).to have_http_status(401)
       end
 
       it 'returns a Invalid credentials message' do
        obj = JSON(response.body)
         expect(obj['error']['user_authentication'])
           .to eq(['Invalid credentials'])
       end
     end
   end

  describe 'PUT /users/:id' do
    let(:valid_attributes) { { name: 'Tolulope' } }
    let(:invalid_attributes) { { name: 'Tolulope', email: users.first.email } }

    context 'when the record exists' do
      before do
        put "/users/#{user_id}", params: valid_attributes, headers: valid_headers(users.first.id)
      end

      it 'updates the record' do
        obj = JSON(response.body)
        message = obj['message']
        expect(message).to eq('User Updated Succefully')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when email already exist' do
      before do
        put "/users/#{user_id}", params: invalid_attributes, headers: valid_headers(users.first.id)
      end

      it 'fails to update' do
        obj = JSON(response.body)
        message = obj['message']
        expect(message).to eq('Email Already Exist')
      end

      it 'returns status code 500' do
        expect(response).to have_http_status(500)
      end
    end
  end

  describe 'DELETE /users/:id' do
    
  end
end
