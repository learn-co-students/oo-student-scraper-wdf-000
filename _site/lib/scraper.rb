require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    array = []
    # student: doc.css("div.student-card")
    # student-name: student.css("h4.student-name").text
    # location: student.css("p.student-location").text
    # profile_url: student.css("a").attribute("href").value

    doc.css("div.student-card").each do |student|
      hash = {}
      hash[:name] = student.css("h4.student-name").text
      hash[:location] = student.css("p.student-location").text
      hash[:profile_url] = "http://127.0.0.1:4000/" + student.css("a").attribute("href").value
      array << hash
    end

    array
    
  end

  # profile-quote : doc.css("div.vitals-text-container div.profile-quote").text
  # bio: doc.css("div.description-holder p").text
  # link: doc.css("div.social-icon-container a")
  # url: link.attribute("href").value

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    hash = {}
    
    doc.css("div.social-icon-container a").each do |link|

      if link.attribute("href").value.include?("twitter")
        hash[:twitter] = link.attribute("href").value
      elsif link.attribute("href").value.include?("linkedin")
        hash[:linkedin] = link.attribute("href").value
      elsif link.attribute("href").value.include?("github")
        hash[:github] = link.attribute("href").value
      else 
        hash[:blog] = link.attribute("href").value
      end
 
      #elsif link.css("a").attribute("href").value.include?("pro")
    end

    if doc.css("div.vitals-text-container div.profile-quote").text
      hash[:profile_quote] = doc.css("div.vitals-text-container div.profile-quote").text
    end
    if doc.css("div.description-holder p").text
      hash[:bio] = doc.css("div.description-holder p").text
    end

    hash
    
  end

end

