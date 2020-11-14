require 'rails_helper'

RSpec.describe ProbeSetting, type: :model do
  before do
    # @user = FactoryBot.build(:user)
  end

  it 'is invalid without a url' do
    # expect{FactoryBot.build(:invalid_probe_setting)}.to have(1).errors_on(:url)
    expect(FactoryBot.build(:invalid_probe_setting)).not_to be_valid
  end

  it 'is valid with a url' do
    expect(FactoryBot.build(:probe_setting)).to be_valid
  end

  it 'should respond to url' do
    expect(FactoryBot.build(:probe_setting)).to respond_to(:url)
  end

  it 'is correct url' do
    expect(FactoryBot.build(:probe_setting).url).to eq('https://ruby-china.org/topics/feed')
  end
end
