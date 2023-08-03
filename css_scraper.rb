require 'httparty'
require 'fileutils'
require 'uri'

def save_css_assets(document, dir, url)
  css_links = document.css('link[rel="stylesheet"]')

  css_links.each do |link|
    css_url = link['href']
  
    # Prepend the domain if it's not an absolute URL
    css_url = URI.join(url, css_url) unless css_url.start_with?('http')

    # Check if the path is absolute
    css_path = URI(css_url).path
    css_path = css_path[1..-1] if css_path.start_with?('/')

    css_response = HTTParty.get(css_url)
    
    css_directory = File.join(dir, File.dirname(css_path))
    FileUtils.mkdir_p(css_directory) unless File.directory?(css_directory)
    
    css_filename = File.join(css_directory, File.basename(css_path))
    File.write(css_filename, css_response.body)

    # Update the href attribute in the original HTML to point to the local copy
    link['href'] = File.join(File.dirname(css_path), File.basename(css_path))
  end

  document
end
