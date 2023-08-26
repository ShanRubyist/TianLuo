require "rails_helper"

RSpec.describe ApplicationCable::Connection, :type => :channel do
  it "successfully connects" do
    connect "/cable?user_id=1"
    expect(connection.user_id).to eq "323"
  end

  it "disconnects" do
    connect "/cable?user_id=42"
    expect { disconnect }.to output(/User 42 disconnected/).to_stdout
  end
end
