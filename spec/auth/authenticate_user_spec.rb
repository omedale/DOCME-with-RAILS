require 'rails_helper'

RSpec.describe AuthenticateUser, type: :request do
  let!(:roles) { create_list(:role, 4) }
  let!(:users) { create_list(:user, 4, role_id: roles.first.id) }
  subject(:valid_auth_obj) { described_class.new(users.first.email, users.first.password) }
  subject(:invalid_auth_obj) { described_class.new('abula', 'eko') }

  describe '#call' do
    context 'when valid credentials' do
      it 'returns an auth token' do
        token = valid_auth_obj.call.result
        expect(token).not_to be_nil
      end
    end

    context 'when invalid credentials' do
      it 'returns an Invalid credentials message' do
        expect(invalid_auth_obj.call.errors[:user_authentication][0])
          .to eq('Invalid credentials')
      end
    end
  end
end
