require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    page = Nokogiri::HTML(html)
    students = []
    page.css('div.student-card').each do |student|
    students << {
      :name => student.css('h4').text,
      :location => student.css('p').text,
      :profile_url => "http://127.0.0.1:4000/" + student.css('a').attribute('href').value
    }
    end
    students
  end

  def self.scrape_profile_page(profile_url)

    html = open(profile_url)
    profile = Nokogiri::HTML(html)
    links = {}
 
    profile.css('div.social-icon-container a').each do |link|

      # twitter_line = link.css.attribute('href').value.match 
      # linkedin_line = link.css.attribute("href").value.match /linkedin/
      # github = link.css.attribute("href").value.match /github/

      if link.attribute('href').value.include?("twitter")
        links[:twitter] = link.attribute('href').value
      elsif link.attribute("href").value.include?("linkedin")
        links[:linkedin] = link.attribute("href").value
      elsif link.attribute("href").value.include? ("github")
        links[:github] = link.attribute("href").value
      else 
        links[:blog] = link.attribute("href").value
      end
      end
      links[:profile_quote] = profile.css('div.profile-quote').text
      links[:bio] = profile.css('div.description-holder p').text
      links 
    end
end

