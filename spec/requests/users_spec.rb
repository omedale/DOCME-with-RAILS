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
    
  end

  describe 'POST /users' do
   
  end

  describe 'PUT /users/:id' do
    
  end

  describe 'DELETE /users/:id' do
    
  end
end
