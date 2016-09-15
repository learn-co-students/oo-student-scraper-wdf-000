require 'open-uri'
require 'nokogiri'
require 'pry'

  # student_info: doc.css('div.student-card')
  # name: student.css('h4.student-name').text
  # location: student.css('p.student-location').text
  # profile_url: student.css('a').attribute('href').value
  # student_social_info: doc.css('div.social-icon-container a')
  # linkedin: social_link.attribute('href').value
  # github: social_link.attribute('href').value
  # blog: social_link.attribute('href').value
  # profile_quote: doc.css('div.vitals-text-container div.profile-quote').text
  # bio: doc.css('div.description-holder p').text

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)

    doc.css('div.student-card').collect do |student|
      {
      :name => student.css('h4.student-name').text,
      :location => student.css('p.student-location').text,
      :profile_url => ('http://127.0.0.1:4000/') + student.css('a').attribute('href').value
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)

    links = {}

    doc.css('div.social-icon-container a').each do |social_link|
      link = social_link.attribute("href").value
      if link.include?("twitter")
        links[:twitter] = link
      elsif link.include?("linkedin")
        links[:linkedin] = link
      elsif link.include?("github")
        links[:github] = link
      else
        links[:blog] = link
      end
    end
    links[:bio] = doc.css('div.description-holder p').text
    links[:profile_quote] = doc.css('div.vitals-text-container div.profile-quote').text
    links
  end
end
