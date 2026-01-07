require "rails_helper"

RSpec.describe VoiceGeneration, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      expect(build(:voice_generation)).to be_valid
    end

    it "is invalid without text" do
      expect(build(:voice_generation, text: nil)).not_to be_valid
    end

    it "is invalid with text longer than MAX_TEXT_LENGTH" do
      expect(build(:voice_generation, text: "a" * 1001)).not_to be_valid
    end

    it "is invalid without voice_id" do
      expect(build(:voice_generation, voice_id: nil)).not_to be_valid
    end
  end

  describe "scopes" do
    it ".recent returns ordered by created_at desc" do
      old = create(:voice_generation, created_at: 2.days.ago)
      new = create(:voice_generation, created_at: 1.day.ago)
      expect(VoiceGeneration.recent).to eq([ new, old ])
    end
  end
end
