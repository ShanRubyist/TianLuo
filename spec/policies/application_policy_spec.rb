require 'rails_helper'

describe ApplicationPolicy do
  subject { ApplicationPolicy }

  permissions :update?, :edit? do
    it "denies access if post is published" do
      expect(subject).not_to permit(FactoryBot.create(:user), User)
    end

    it "grants access if post is published and user is an admin" do
      expect(subject).to permit(FactoryBot.create(:admin), User)
    end
  end

  permissions :destroy? do
    it "denies access" do
      expect(subject).not_to permit(FactoryBot.create(:user), User)
    end

    it "denies access even if user is an admin" do
      expect(subject).to permit(FactoryBot.create(:admin), User)
    end
  end
end