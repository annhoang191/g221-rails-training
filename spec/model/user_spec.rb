require "rails_helper"

RSpec.describe User, type: :model do
  describe "User associations" do
    it { is_expected.to have_many(:notes).dependent(:destroy) }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
    it { is_expected.to have_many(:user_groups).dependent(:destroy) }
    it { is_expected.to have_many(:groups).through(:user_groups) }
  end

  describe "User validation" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end
end
