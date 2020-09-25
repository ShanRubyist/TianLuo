require 'rails_helper'

# RSpec.describe "RailsAdmin", type: :system do
#   before do
#     driven_by(:rack_test)
#   end
#
#   let(:user) { FactoryBot.create(:user) }
#   let(:admin) { FactoryBot.create(:admin) }
#
#   context 'When user is admin' do
#     before do
#       visit root_path
#       fill_in 'Email', with: admin.email
#       fill_in 'Password', with: admin.password
#       click_button 'Log in'
#     end
#
#     scenario 'should be root path' do
#       expect(current_path).to eq '/'
#     end
#
#     scenario 'grant access to admin dashboard' do
#       visit rails_admin.dashboard_path
#       expect(current_path).to eq rails_admin.dashboard_path
#     end
#
#     scenario 'grant access to model' do
#       visit rails_admin.index_path(model_name: 'RssFeed')
#       expect(current_path).to eq rails_admin.index_path(model_name: 'RssFeed')
#     end
#
#     scenario 'click dashboard button' do
#       # visit rails_admin.dashboard_path
#       # page.find('.dashboard_root_link a').click
#       # expect(current_path).to eq rails_admin.dashboard_path
#     end
#
#     scenario 'grant access to model' do
#       visit rails_admin.index_path(model_name: 'RssFeed')
#       expect(page.find('.page-header h1')).to have_content 'List of Rss feeds'
#     end
#   end
#
#   context 'When user is not admin' do
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
#     scenario 'denies access to admin dashboard' do
#       expect { visit rails_admin.dashboard_path }.to raise_error(Pundit::NotAuthorizedError)
#     end
#   end
# end