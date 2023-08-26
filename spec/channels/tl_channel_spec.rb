require "rails_helper"

RSpec.describe TlChannel, :type => :channel do
  it "successfully subscribes" do
    subscribe user_id: 1
    expect(subscription).to be_confirmed
  end

  it "rejects subscription" do
    subscribe user_id: nil
    expect(subscription).to be_rejected
  end

  # it "successfully subscribes" do
  #   subscribe user_id: 1
  #
  #   perform :hello, foo: 'bar'
  #   expect(transmissions.last).to eq('foo' => 'bar')
  # end
end
