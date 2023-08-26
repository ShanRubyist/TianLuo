require 'rails_helper'

RSpec.describe UserRssShip, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }
  let(:probe_setting) { FactoryBot.create(:probe_setting, users: [user, admin]) }

  it 'destroy probe setting first time' do
    admin.probe_settings.destroy(probe_setting)
    expect(probe_setting.users.to_a).to eq [user]
  end

  it 'destroy probe setting last time' do
    user.probe_settings.destroy(probe_setting)
    expect(probe_setting.users).to eq []
    expect(probe_setting).not_to be_valid
  end
end
