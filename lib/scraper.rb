require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index = Nokogiri::HTML(open(index_url))

    index.css("div.student-card a").map do |student|
      student_hash = {}
      url = "http://127.0.0.1:4000/"
      student_hash[:name] = student.css("div h4.student-name").text
      student_hash[:location] = student.css("div p").text
      student_hash[:profile_url] = url + student.values[0]
      student_hash

    end

  end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url))
    profile_page = {}
    profile_page[:profile_quote] = profile.css("div.vitals-text-container div.profile-quote").text
    profile_page[:bio] = profile.css("div.details-container p").text

    profile.css("div.social-icon-container a").map do |social_media|

      link = social_media.attribute('href').value

      if link.include?("twitter")
        profile_page[:twitter] = link
      elsif link.include?("linkedin")
        profile_page[:linkedin] = link
      elsif link.include?("github")
        profile_page[:github] = link
      else
        profile_page[:blog] = link
      end
    end
    profile_page
  end

end
