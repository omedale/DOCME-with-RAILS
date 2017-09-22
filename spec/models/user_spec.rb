require 'rails_helper'

RSpec.describe User, type: :model do

  it { is_expected.to belong_to(:role) }

  it { is_expected.to have_many(:documents).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:password_digest) }
  it { is_expected.to have_secure_password }
end
