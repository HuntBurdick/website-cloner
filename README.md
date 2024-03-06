# Website Cloner

This web scraper is designed to scrape a given webpage and save the HTML, CSS, JS, and image assets locally to a directory of your choosing.

## How It Works

The scraper works by sending a GET request to a URL of your choosing. It then parses the HTML of the webpage, downloads the linked CSS, JS, and image assets, and saves the HTML and assets locally to a directory.

The scraper handles absolute and relative URLs, and it updates the HTML to reference the locally saved assets, preserving the original file and directory structure.

## How to Use

First, make sure you have Ruby installed on your machine. Then, clone this repository and navigate to the project directory in your terminal.

Install the required gems with Bundler:

```Bash
bundle install
```

To use the scraper, run the scraper.rb script, passing in the URL you want to scrape and the directory you want to save the scraped contents to as arguments:

```Bash
ruby scrape.rb https://www.example.com name-of-site
```

This will scrape the webpage at https://www.example.com and save the contents to ./sites/name-of-site.

To run the tests, use the following command:

```Bash
bundle exec rspec
```

## Dependencies

This scraper uses the following Ruby gems:

- httparty for sending HTTP requests.
- nokogiri for parsing HTML.
- fileutils for handling files and directories.

These dependencies can be installed using Bundler:

```Bash
bundle install
```
