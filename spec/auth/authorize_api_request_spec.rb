require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  let!(:roles) { create_list(:role, 4) }
  let!(:users) { create_list(:user, 4, role_id: roles.first.id) }
  let(:header) { { 'Authorization' => token_generator(users.first.id) } }
  subject(:invalid_request_obj) { described_class.new({}) }
  subject(:request_obj) { described_class.new(header) }

  describe '#call' do
    it 'returns user object' do
      result = request_obj.call
      expect(result.instance_eval { user }).to eq(users.first)
    end

    context 'when invalid request' do
      context 'when missing token' do
        it 'raises a MissingToken error' do
          expect(invalid_request_obj.call.errors[:token][0])
            .to eq('Missing token')
        end
      end

      context 'when invalid token' do
        subject(:invalid_request_obj) do
          described_class.new('Authorization' => 'femi')
        end

        it 'returns Invalid token token error' do
          expect(invalid_request_obj.call.errors[:token][0])
            .to eq('Invalid token')
        end
      end

      context 'when token is expired' do
        let(:header) do
          {
            'Authorization' =>  expired_token_generator(users.first.id)
          }
        end
        subject(:request_obj) { described_class.new(header) }

        it 'returns Invalid token token error' do
          expect(request_obj.call.errors[:token][0])
            .to eq('Invalid token')
        end
      end
    end
  end
end
