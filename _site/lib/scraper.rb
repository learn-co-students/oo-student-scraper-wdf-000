require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)

    doc = Nokogiri::HTML(open(index_url))
    profiles = doc.css("div.student-card")
    students = []

    profiles.each do |profile|
      each_student = {}
      file = "http://127.0.0.1:4000/"

      each_student[:name] = profile.css("h4.student-name").text
      each_student[:location] = profile.css("p.student-location").text
      each_student[:profile_url] = file + profile.css("a").attribute("href").value

      students << each_student
    end
      students
  end



  def self.scrape_profile_page(profile_url)

    doc = Nokogiri::HTML(open(profile_url))
    profiles = doc.css("div.social-icon-container a")
    social_accounts = {}
    profiles.each do |profile|


      if profile.attribute("href").value.include?("https://twitter.com/")
        social_accounts[:twitter] = profile.attribute("href").value
      elsif
        profile.attribute("href").value.include?("https://www.linkedin.com/")
        social_accounts[:linkedin] = profile.attribute("href").value
      elsif
        profile.attribute("href").value.include?("https://github.com/")
        social_accounts[:github] = profile.attribute("href").value
      else
        social_accounts[:blog] = profile.attribute("href").value
      end
      end
        social_accounts[:profile_quote] = doc.css("div.profile-quote").text
        social_accounts[:bio] = doc.css("div.description-holder p").text
        social_accounts
      end

end
