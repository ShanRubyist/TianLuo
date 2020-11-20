require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:user) { User.new }
  let(:guest) { nil }

  subject { described_class }

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :create? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :update? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :destroy? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :valid_user? do
    it 'grants access if user is login in' do
      expect(subject).to permit(user, User)
    end

    it 'denies access if user is guest' do
      expect(subject).not_to permit(guest, User)
    end
  end
end
