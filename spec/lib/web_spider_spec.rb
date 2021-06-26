require 'rails_helper'
require_relative '../../lib/robot'

RSpec.describe Robot::WebSpider do
  before do
    @obj = Robot::WebSpider.new('https://www.baidu.com')
  end

  describe '#parse_cookies' do
    it 'convert string format to hash format' do
      cookies = 'a=1; b=2; c=3'
      expect(@obj.send(:parse_cookies, cookies)).to eq({'a' => '1', 'b' => '2', 'c' => '3'})
    end
  end

  describe '#fetch' do
    it 'fetch data' do
      @obj.need_cache = false
      expect(@obj.fetch).to match(/.*html.*body.*/)
    end
  end
end
