require "rails_helper"

RSpec.describe Task, type: :model do
  describe "Task associations" do
    it { is_expected.to belong_to(:user) }
  end
end
