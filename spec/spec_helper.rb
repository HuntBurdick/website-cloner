require 'rspec'
require 'webmock/rspec'
require 'nokogiri'
require 'httparty'
require_relative '../css_scraper'
require_relative '../js_scraper'
require_relative '../image_scraper'

RSpec.configure do |config|
  config.color = true
end
