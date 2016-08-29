require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    learn_students = Nokogiri::HTML(open(index_url))
    index_url = "http://127.0.0.1:4000/"

    students = []

    learn_students.css("div.student-card").each do |student|
      student_hash = {}
      student_hash[:name] = student.css("h4.student-name").text
      student_hash[:location] = student.css("p.student-location").text
      student_hash[:profile_url] = "http://127.0.0.1:4000/"+student.css("a").attribute("href").value

      students << student_hash
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))

    student_profile = []
    student = {}

    profile_page.css("div.social-icon-container a").collect do |link|
      student_profile << link.attribute("href").value
    end

    student_profile.each do |link|
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
    student[:profile_quote] = profile_page.css(".profile-quote").text
    student[:bio] = profile_page.css(".description-holder").css("p").text

    student
  end
end
