require "rails_helper"

RSpec.describe WeeklySummaryMailer, type: :mailer do
  describe 'notify' do
    let(:mail) { WeeklySummaryMailer.notify }

    it 'renders the headers' do
      expect(mail.subject).to eq('TianLuo Weekly Summary')
      expect(mail.to).to eq([ENV['ADMIN_EMAIL']])
      expect(mail.from).to eq([ENV['EMAIL_FROM_ADDRESS']])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(/本周汇总/)
    end
  end
end
