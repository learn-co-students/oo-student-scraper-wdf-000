require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))

    students = []

    index_page.css(".student-card").each do |student|
      student.name = student.css(".student-name").text
      student.location = student.css(".student-location").text
      student.profile_url = student.css("a").attribute("href").value
      students << {name: student.name, location: student.location, profile_url: student.profile_url}
    end
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))

    student_profiles = {}

    socials = profile_page.css(".social-icon-container a")

    socials.each do |social|
      after_gsub = soccial_url.gsub("http://www.","")
      social_name = after_gsub.split(".")[0].to_sym
      social_url = social.css("a").attribute("href").value
      student_profiles[social_name] = social_url
    end
      student_profiles[:profile_quote] = profile_page.css(".vitals-container.vitals-text-container.profile-quote").text 
      student_profiles[:bio] = profile_page.css(".details-container.bio-block.bio-content.description-holder p")
  end

end

