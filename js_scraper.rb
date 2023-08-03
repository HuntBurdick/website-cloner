require 'httparty'
require 'fileutils'
require 'uri'

def save_js_assets(document, dir, url)
  js_links = document.css('script[src]')

  js_links.each do |link|
    js_url = link['src']
  
    # Prepend the domain if it's not an absolute URL
    js_url = URI.join(url, js_url) unless js_url.start_with?('http')

    # Check if the path is absolute
    js_path = URI(js_url).path
    js_path = js_path[1..-1] if js_path.start_with?('/')

    js_response = HTTParty.get(js_url)
    
    js_directory = File.join(dir, File.dirname(js_path))
    FileUtils.mkdir_p(js_directory) unless File.directory?(js_directory)
    
    js_filename = File.join(js_directory, File.basename(js_path))
    File.write(js_filename, js_response.body)

    # Update the src attribute in the original HTML to point to the local copy
    link['src'] = File.join(File.dirname(js_path), File.basename(js_path))
  end

  document
end
