require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    
    link = "http://127.0.0.1:4000/"

    doc.css("div.student-card a").collect do |person|
      student_hash = {}
      student_hash[:name] = person.css("h4.student-name").text
      student_hash[:location] = person.css("p.student-location").text
      student_hash[:profile_url] = link + person.values[0]
      student_hash
    end
  end

  def self.scrape_profile_page(profile_url)
    doc2 = Nokogiri::HTML(open(profile_url))
    hash = {}
    doc2.css("div.social-icon-container a").collect do |link|

      if(link.attribute("href").value.include?("twitter"))
        hash[:twitter] = link.attribute("href").value

      elsif(link.attribute("href").value.include?("linkedin"))
        hash[:linkedin] = link.attribute("href").value

      elsif(link.attribute("href").value.include?("github"))
        hash[:github] = link.attribute("href").value

      elsif(link.attribute("href").value.include?("http"))
        hash[:blog] = link.attribute("href").value
      end
    end

  hash[:profile_quote] = doc2.css("div.profile-quote").text
  hash[:bio] = doc2.css("div.description-holder p").text
  hash
  end
end