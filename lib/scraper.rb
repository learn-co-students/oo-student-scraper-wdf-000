require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_url = index_url.gsub("http://127.0.0.1:4000/", "")
    index_page = Nokogiri::HTML(open(index_url))

    index_page.css('.student-card').map do |card|
      student_name = card.css('.student-name').text
      student_location = card.css('.student-location').text
      student_url = card.css('a').attr('href').value.prepend("http://127.0.0.1:4000/")

      { :name => student_name, :location => student_location, :profile_url => student_url }
    end
  end

  def self.scrape_profile_page(profile_url)
    profile_url = profile_url.gsub("http://127.0.0.1:4000/", "")
    profile_page = Nokogiri::HTML(open(profile_url))
    student = {}

    links = profile_page.css(".social-icon-container a").map { |el| el.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end

    student[:bio] = profile_page.css(".description-holder p").text
    student[:profile_quote] = profile_page.css(".profile-quote").text

    student
  end
end
