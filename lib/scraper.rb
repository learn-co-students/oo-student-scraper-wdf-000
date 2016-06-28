require 'open-uri'
require 'nokogiri'
require 'pry'


#  How to use Pry here?
#  How to use the httpserver & command?   How to test it?
#  Do I need to add space between css classes in css("")?


class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    # html = File.read('../fixtures/student-site/index.html')
    # index_page = Nokogiri::HTML(html)

    students = []

    index_page.css(".student-card").each do |student|
      student << {
        :name => student.css("a.card-text-container.h4").text,
        :location => student.css("a.card-text-container.p").text,
        :profile_url => student.css("a").attribute("href").value
      }
    end

    students
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))

    profile_data = {}

    socials = profile_page.css(".profile.vitals-container.social-icon-container a")
    socials.each do |a_tag|
      social_url = a_tag.attribute("href").value
      social_http = social_url.str(/(https:\/\/w{3}?.)(\w+)(.\w*)/)
      social_name = social_http.split(".")[1].to_sym
      profile_data[social_name] = social_url
    end

    profile_data[:profile_quote] = profile_page.css(".profile.vitals-container.vitals-text-container.profile-quote").text
    profile_data[:bio] = profile_page.css(".profile.details-container.bio-block.bio-content.description-holder p").text

    return profile_data
  end

end
