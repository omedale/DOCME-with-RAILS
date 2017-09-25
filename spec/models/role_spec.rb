require 'rails_helper'

RSpec.describe Role, type: :model do
  it { is_expected.to have_many(:users).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:role) }
  it { is_expected.to validate_presence_of(:description) }
end
