require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    # index_url = index_url.gsub("http://127.0.0.1:4000/", "")
    # binding.pry
  
    students = Nokogiri::HTML(open(index_url))

    students.css(".student-card").map do |student|
      name = student.css("div.card-text-container").text.split("\n ")[1].strip
      location = student.css("div.card-text-container").text.split("\n ")[2].strip
      # binding.pry
      link = student.css('a').attr("href").value.prepend("http://127.0.0.1:4000/")
      {:name => name, :location => location, :profile_url => link }
    end
  end

  def self.scrape_profile_page(profile_url)
    student = Nokogiri::HTML(open(profile_url))
    hash = {}
    # binding.pry
        # binding.pry
    student.css(".social-icon-container a").each do |s|
      link = s.attribute('href').value
      
      if link.include?("linkedin")
        hash[:linkedin] = link
      elsif link.include?("github")
        hash[:github] = link
      elsif link.include?("twitter")
        hash[:twitter] = link
      else 
        hash[:blog] = link
      end
    end
    hash[:profile_quote] = student.css(".profile-quote").text
    hash[:bio] = student.css(".description-holder").text.split("\n")[1].strip
    hash
  end
end

