require 'httparty'
require 'fileutils'
require 'uri'

def save_image_assets(document, dir, url)
  img_links = document.css('img[src]')

  img_links.each do |link|
    img_url = link['src']
  
    # Prepend the domain if it's not an absolute URL
    img_url = URI.join(url, img_url) unless img_url.start_with?('http')

    # Check if the path is absolute
    img_path = URI(img_url).path
    img_path = img_path[1..-1] if img_path.start_with?('/')

    img_response = HTTParty.get(img_url)
    
    img_directory = File.join(dir, File.dirname(img_path))
    FileUtils.mkdir_p(img_directory) unless File.directory?(img_directory)
    
    img_filename = File.join(img_directory, File.basename(img_path))
    File.write(img_filename, img_response.body)

    # Update the src attribute in the original HTML to point to the local copy
    link['src'] = File.join(File.dirname(img_path), File.basename(img_path))
  end

  document
end
