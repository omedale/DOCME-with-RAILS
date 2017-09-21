require 'rails_helper'

RSpec.describe 'Roles API', type: :request do
  # initialize test data 
  let!(:roles) { create_list(:role, 4) }
  let(:role_id) { roles.first.id }
  

  describe 'GET /roles' do
    before { get '/roles' }
   
    it 'returns roles' do
      expect(json).not_to be_empty
      expect(json.size).to eq(4)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /roles/:id' do
    before { get "/roles/#{role_id}" }

    context 'when the record exists' do
      it 'returns the role' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(role_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:role_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Role/)
      end
    end
  end

  describe 'POST /roles' do
    # valid payload
    let(:valid_attributes) { { role: 'fellow', description: 'normal user' } }

    context 'when the request is valid' do
      before { post '/roles', params: valid_attributes }

      it 'creates a role' do
        expect(json['role']).to eq('fellow')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/roles', params: { title: 'Pikolo' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Role can't be blank, Description can't be blank/)
      end
    end
  end

  describe 'PUT /roles/:id' do
    let(:valid_attributes) { { role: 'public' } }

    context 'when the record exists' do
      before { put "/roles/#{role_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /roles/:id' do
    before { delete "/roles/#{role_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end