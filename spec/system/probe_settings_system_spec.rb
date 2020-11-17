# require 'rails_helper'
#
# RSpec.describe "ProbeSettings", type: :system do
#   before do
#     # driven_by(:selenium)
#     driven_by(:rack_test)
#   end
#
#   let(:user) { FactoryBot.create(:user) }
#
#   context 'As user' do
#     before do
#       visit root_path
#       fill_in 'Email', with: user.email
#       fill_in 'Password', with: user.password
#       click_button 'Log in'
#     end
#
#     scenario 'should be root path' do
#       expect(current_path).to eq '/'
#     end
#
#     scenario 'have content' do
#       expect(page).to have_text /.+/
#     end
#
#     scenario 'add a probe setting', js: true do
#       # page.find('li .add-dialog-type-card').click
#       # fill_in 'rss_url', with: 'abc'
#       #
#       # expect { click_button '确定' }.to change(ProbeSetting, :count).by(1)
#     end
#   end
#
#   context 'As guest' do
#     before do
#       visit root_path
#     end
#
#     scenario 'redirect to sign in path' do
#       expect(current_path).to eq new_user_session_path
#     end
#   end
# end