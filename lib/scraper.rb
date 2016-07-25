require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    # get html of students page
    raw_html = open(index_url)
    students_page = Nokogiri::HTML(raw_html)
    # set up data collector
    student_data = []
    # iterate through student cards and collect student info
    students_page.css(".student-card").each do |student_card|
      name = student_card.css(".student-name").text
      location = student_card.css(".student-location").text
      profile_url = "http://127.0.0.1:4000/" + student_card.css("a").attr("href").value
      # students_data << student_data
      student_data << {:name => name, :location => location, :profile_url => profile_url}
    end
    student_data
  end

  def self.scrape_profile_page(profile_url)
    # get html of profile page
    raw_html = open(profile_url)
    profile_page = Nokogiri::HTML(raw_html)
    # set up data collector
    profile_data = {}
    # get social links
    profile_page.css(".social-icon-container a").each do |social_link|
      href  = social_link.attr("href")#.value
      ["twitter", "linkedin", "github"].each do |social|
        
        if href.match(social)
          profile_data[social.to_sym] = href
        end
        profile_data[:blog] = href if ["twitter", "linkedin", "github"].none? {|social| href.match(social)}
      end
      
     
    end

    # get profile quote
    profile_data[:profile_quote] = profile_page.css(".profile-quote").text
    profile_data[:bio] = profile_page.css(".description-holder").text.split("\n")[1].strip
    profile_data
  end

end

# twitter url, linkedin url, github url, blog url, profile quote, and bio