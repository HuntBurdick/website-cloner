require 'bundler/setup'
require 'nokogiri'
require 'httparty'
require 'fileutils'
require 'json'
require_relative 'css_scraper'
require_relative 'js_scraper'
require_relative 'image_scraper'

# Get URL and folder name from command line arguments
url = ARGV[0]
folder_name = ARGV[1]

# Define the directory
dir = "./sites/#{folder_name}"

# Remove the directory and its contents if it exists
FileUtils.rm_rf(dir) if File.directory?(dir)

# Create the directory
FileUtils.mkdir_p(dir)

response = HTTParty.get(url)

# Parse the document with Nokogiri
document = Nokogiri::HTML(response.body)

# Save assets
document = save_css_assets(document, dir, url)
document = save_js_assets(document, dir, url)
document = save_image_assets(document, dir, url)

# Save modified HTML
File.write("#{dir}/index.html", document.to_html)

# Save URL as JSON
File.write("#{dir}/url.json", { url: url }.to_json)
