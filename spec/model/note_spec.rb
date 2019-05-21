require "rails_helper"

RSpec.describe Note, type: :model do
  describe "Note associations" do
    it { is_expected.to belong_to(:user) }
  end
end
