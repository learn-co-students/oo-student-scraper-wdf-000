require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)

    learn_students = Nokogiri::HTML(open(index_url))

    students = []

    url = "http://127.0.0.1:4000/"

    learn_students.css("div.student-card").each do |student|
      student_hash = {}
      student_hash[:name] = student.css("h4.student-name").text
      student_hash[:location] = student.css("p.student-location").text
      student_hash[:profile_url]= url + student.css("a").attribute("href").value
      students << student_hash
    end
    students
    end

  def self.scrape_profile_page(profile_url)

    learn_student = Nokogiri::HTML(open(profile_url))

    student_information = {}


    student_social_media = learn_student.css("div.social-icon-container a").each do |channel|
      if channel.attribute("href").value.include? "linkedin"
        student_information[:linkedin] = channel.attribute("href").value
      elsif channel.attribute("href").value.include? "twitter"
        student_information[:twitter] = channel.attribute("href").value
      elsif channel.attribute("href").value.include? "github"
        student_information[:github] = channel.attribute("href").value
      else
        student_information[:blog] = channel.attribute("href").value
      end
    end
    student_information[:profile_quote] = learn_student.css("div.profile-quote").text
    student_information[:bio] = learn_student.css("p").text

    student_information
  end

end
