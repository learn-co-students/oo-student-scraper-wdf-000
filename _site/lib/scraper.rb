require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)  #Should return an array of hashes
    raw_text = Nokogiri::HTML(open(index_url))
    scraped_data = []
    # binding.pry
    raw_text.css(".student-card").each do |student|
      student_element = {};
      student_element[:name] = student.css(".student-name").text
      student_element[:location] = student.css(".student-location").text
      student_element[:profile_url] = "#{student.css("a")[0].values[0]}"
      scraped_data << student_element
    end

    return scraped_data
  end

  def self.scrape_profile_page(profile_url)
    raw_text = Nokogiri::HTML(open(profile_url))
    # binding.pry
    profile = {}
    profile[:bio] = raw_text.css(".description-holder p").text
    profile[:profile_quote] = raw_text.css(".profile-quote").text
    raw_text.css(".social-icon-container").css("a").each_with_object(profile) do |social, profile|
      profile[:twitter] = social.values[0] if !social.values[0].match(/twitter/).nil?
      profile[:github] = social.values[0] if !social.values[0].match(/github/).nil?
      profile[:linkedin] = social.values[0] if !social.values[0].match(/linkedin/).nil?
        if social.values[0].match(/twitter/).nil? && social.values[0].match(/github/).nil? && social.values[0].match(/linkedin/).nil?
          profile[:blog] = social.values[0]
        end
      end
  end

end
