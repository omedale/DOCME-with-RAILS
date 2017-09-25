require 'rails_helper'

RSpec.describe Document, type: :model do
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:content) }
  it { is_expected.to validate_presence_of(:owner) }
  it { is_expected.to validate_presence_of(:access) }
end
