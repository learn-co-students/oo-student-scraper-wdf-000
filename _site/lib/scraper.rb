require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    # Get document HTML
    html = Nokogiri::HTML(open(index_url))

    # Access student info
    students_container = html.css("div.student-card")

    #Final array
    students_array = []

    # Populate students_hash
    students_container.each do |student|
      name = student.css("h4").text
      location = student.css("p").text
      profile_url = "http://127.0.0.1:4000/" + student.css("a").attribute("href").value

      students_array << {
        :name => name,
        :location => location,
        :profile_url => profile_url
      }
    end

    students_array
  end

  def self.scrape_profile_page(profile_url)
    student_info = {}

    # Get profile page
    html = Nokogiri::HTML(open(profile_url))

    social_links = html.css(".social-icon-container").css("a")
    profile_quote = html.css(".profile-quote").text
    bio = html.css(".description-holder").css("p").text

    # Get social links / create social keys
    social_links.each do |anchor|
      link = anchor.attribute("href").value

      if link.include?("twitter")
        student_info[:twitter] = link
      elsif link.include?("linkedin")
        student_info[:linkedin] = link
      elsif link.include?("github")
        student_info[:github] = link
      else
        student_info[:blog] = link
      end
    end

    # Add profile quote and bio to final hash
    student_info[:profile_quote] = profile_quote
    student_info[:bio] = bio

    student_info
  end

end
