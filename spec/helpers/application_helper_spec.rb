require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  login_user

  describe '#import_partial' do
    it 'render partial' do
      pending 'TODO'
      expect(import_partial('common/nav')).to include('abc')
    end

    it 'return one line' do
      pending 'TODO'
      expect(import_partial('common/nav')).to match(/\n/)
    end
  end
end