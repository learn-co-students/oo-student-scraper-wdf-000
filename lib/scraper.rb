require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)


    html = Nokogiri::HTML(open(index_url))

    students = html.css("div.student-card")

    all_students = []
    
    students.each do |student|
      name = student.css(".card-text-container").text.split("\n ")[1].strip
      location = student.css(".card-text-container").text.split("\n ")[2].strip
      profile_url = "http://127.0.0.1:4000/" + student.css("a").attribute("href").value

      all_students << {
        :name => name, 
        :location => location,
        :profile_url => profile_url
      }
    end

    all_students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    html = Nokogiri::HTML(open(profile_url))
    social_links = html.css(".social-icon-container").css("a")
    profile_quote = html.css(".profile-quote").text 
    bio = html.css(".description-holder").css("p").text

    social_links.each do |links|
      link = links.attribute("href").value

      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student [:blog] = link
      end

    end

    student[:profile_quote] = html.css(".profile-quote").text
    student[:bio] = html.css(".description-holder").text.split("\n")[1].strip
    student
  end

end

