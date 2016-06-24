require 'pry'
require 'nokogiri'
require 'open-uri'
class Scraper
  def scrape_index_page(url)

    html = File.read(url)
    index = Nokogiri::HTML(html)
 binding.pry   
  end

  def scrape_profile_page
  end
end

a=Scraper.new
a.scrape_index_page("http://127.0.0.1:4000i/")
