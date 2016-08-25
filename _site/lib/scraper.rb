require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []


    # index_page.css(".student-card").each do |card|
    #   name = card.css("h4").text
    #   location = card.css("p").text
    #   profile_url = card.css("h3").text
    #   students << {:name => name, :location => location, :profile_url => profile_url}
    # end
    index_page.css(".roster-cards-container").each do |cards|
      cards.css(".student-card").each do |card|
          name = card.css("h4").text
          location = card.css("p").text
          profile_url = "http://127.0.0.1:4000/"+card.css("a").attribute("href").value
          # students << {:name => name, :location => location, :profile_url => profile_url}
          students << {name: name, location: location, profile_url: profile_url}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    student = {}
    array = []
    profile_page.css(".social-icon-container").css("a").collect do |link|
      array << link.attribute("href").value
    end
    
    array.each do |link|
      if link.include?("twitter")
        student[:twitter] = link
      elsif link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      else
        student[:blog] = link
      end
  end
    quote = profile_page.css(".profile-quote").text
    student[:profile_quote] = quote
    description = profile_page.css(".description-holder").css("p").text
    student[:bio] = description
    student
      # binding.pry
  end
end
