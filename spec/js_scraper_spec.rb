require 'spec_helper'

describe '#save_js_assets' do
  let(:url) { 'https://www.example.com' }
  let(:dir) { './sites/example' }

  before do
    stub_request(:get, url)
      .to_return(status: 200, body: '<html><head><script src="/scripts/main.js"></script></head><body></body></html>')
    stub_request(:get, "#{url}/scripts/main.js")
      .to_return(status: 200, body: 'console.log("Hello, world!");')
  end

  it 'saves JavaScript assets from the given URL to the given directory' do
    document = Nokogiri::HTML(HTTParty.get(url).body)

    # First, remove the directory if it exists
    FileUtils.rm_rf(dir) if File.directory?(dir)

    # Call the function
    updated_document = save_js_assets(document, dir, url)

    # Test that the function updated the src attribute correctly
    expect(updated_document.css('script').first['src']).to eq('scripts/main.js')

    # Test that the function saved the JavaScript file to the correct location
    expect(File).to exist("#{dir}/scripts/main.js")

    # Test that the function saved the correct contents to the JavaScript file
    expect(File.read("#{dir}/scripts/main.js")).to eq('console.log("Hello, world!");')
  end
end
