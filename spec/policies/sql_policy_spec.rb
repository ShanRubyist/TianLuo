require 'rails_helper'

RSpec.describe SQLPolicy, type: :policy do
  let(:user) { User.new }
  let(:admin) { FactoryBot.build(:admin) }

  subject { described_class }

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :sql? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, SQL)
    end

    it 'denies access if user is not admin' do
      expect(subject).not_to permit(user, SQL)
    end
  end
end
