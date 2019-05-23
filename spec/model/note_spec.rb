require "rails_helper"

RSpec.describe Note, type: :model do
  describe "Note associations" do
    it { is_expected.to belong_to(:user) }
  end

  it { is_expected.to validate_presence_of(:content) }
end
