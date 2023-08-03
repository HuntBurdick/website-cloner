require 'spec_helper'

describe '#save_image_assets' do
  let(:url) { 'https://www.example.com' }
  let(:dir) { './sites/example' }

  before do
    stub_request(:get, url)
      .to_return(status: 200, body: '<html><head></head><body><img src="/images/example.jpg"></body></html>')
    stub_request(:get, "#{url}/images/example.jpg")
      .to_return(status: 200, body: File.new("spec/fixtures/example.jpg"))
  end

  it 'saves image assets from the given URL to the given directory' do
    document = Nokogiri::HTML(HTTParty.get(url).body)

    # First, remove the directory if it exists
    FileUtils.rm_rf(dir) if File.directory?(dir)

    # Call the function
    updated_document = save_image_assets(document, dir, url)

    # Test that the function updated the src attribute correctly
    expect(updated_document.css('img').first['src']).to eq('images/example.jpg')

    # Test that the function saved the image file to the correct location
    expect(File).to exist("#{dir}/images/example.jpg")

    # Test that the function saved the correct contents to the image file
    expect(FileUtils.compare_file("#{dir}/images/example.jpg", "spec/fixtures/example.jpg")).to be(true)
  end
end
