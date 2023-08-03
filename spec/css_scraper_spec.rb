require 'spec_helper'

describe '#save_css_assets' do
  let(:url) { 'https://www.example.com' }
  let(:dir) { './sites/example' }

  before do
    stub_request(:get, url)
      .to_return(status: 200, body: '<html><head><link rel="stylesheet" href="/styles/main.css"></head><body></body></html>')
    stub_request(:get, "#{url}/styles/main.css")
      .to_return(status: 200, body: 'body { background-color: white; }')
  end

  it 'saves CSS assets from the given URL to the given directory' do
    document = Nokogiri::HTML(HTTParty.get(url).body)

    # First, remove the directory if it exists
    FileUtils.rm_rf(dir) if File.directory?(dir)

    # Call the function
    updated_document = save_css_assets(document, dir, url)

    # Test that the function updated the href attribute correctly
    expect(updated_document.css('link[rel="stylesheet"]').first['href']).to eq('styles/main.css')

    # Test that the function saved the CSS file to the correct location
    expect(File).to exist("#{dir}/styles/main.css")

    # Test that the function saved the correct contents to the CSS file
    expect(File.read("#{dir}/styles/main.css")).to eq('body { background-color: white; }')
  end
end
