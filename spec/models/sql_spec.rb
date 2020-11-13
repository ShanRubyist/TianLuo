require 'rails_helper'

RSpec.describe SQL, type: :model do
  let(:sql_statment) { 'select * from users' }

  it 'should respond to exec' do
    expect(SQL).to respond_to(:exec)
  end

  it 'return a ActiveRecord::Result' do
    expect(SQL.exec(sql_statment)).to be_a(ActiveRecord::Result)
  end

  it 'exec a sql statment' do
    User.create(FactoryBot.attributes_for(:user))
    result = SQL.exec(sql_statment)
    expect(result.first['email']).to match(/.*@.*\..+/)
  end
end
