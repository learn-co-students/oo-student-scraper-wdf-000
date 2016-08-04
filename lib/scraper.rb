require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    
    roster = []
    doc.css(".student-card a").each do |object|
      hash = {}
      hash[:name] = object.css("h4.student-name").text
      hash[:location] = object.css("p.student-location").text
      hash[:profile_url] = "http://127.0.0.1:4000/" + object.attribute("href").value
      roster << hash
    end

    roster
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)

    hash = {}
    
    doc.css(".social-icon-container a").each do |object|
      if object.attribute("href").value.include?("twitter")
        hash[:twitter] = object.attribute("href").value
      elsif object.attribute("href").value.include?("linkedin")
        hash[:linkedin] = object.attribute("href").value
      elsif object.attribute("href").value.include?("github")
        hash[:github] = object.attribute("href").value
      else
        hash[:blog] = object.attribute("href").value
      end
    end

    hash[:profile_quote] = doc.css(".profile-quote").text
    hash[:bio] = doc.css(".description-holder p").text

    hash

  end

end

