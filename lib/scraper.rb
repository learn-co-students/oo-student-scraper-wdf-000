require 'nokogiri'
require 'open-uri'
require 'uri'

class Scraper
  def self.scrape_index_page(url)
    # :name index.css('.student-card h4').text
    # :location index.css('.student-card p').text
    # :profile_url index.css('.student-card a').attribute('href').value

    html = open(url)
    index = Nokogiri::HTML(html)
    cards = []

    index.css('div.student-card').each do |card|
      cards << {
        :name => card.css('h4').text,
        :location => card.css('p').text,
        :profile_url => "http://127.0.0.1:4000/" + card.css('a').attribute('href').value
      }
    end

    cards
  end

  # social profile.css('div.social-icon-container a')[INDEX].attribute('href').value
  # profile_quote profile.css('div.profile-quote').text
  # bio profile.css('div.bio-block p').text

  def self.scrape_profile_page(url)
    html = open(url)
    profile = Nokogiri::HTML(html)
    result = {}

    # get name
    name = profile.css('h1.profile-name').text.downcase.split(/\s+/)

    # get social links
    profile.css('div.social-icon-container a').each do |a|
      uri = URI.parse(a.attribute('href').value)
      key = /(www.)?[^.]+/.match(uri.hostname).to_s.gsub(/www\./,'')
      
      if (key).match(name[1]) then key = :blog end

      result[key.to_sym] = a.attribute('href').value
    end
 
    # get profile quote
    result[:profile_quote] = profile.css('div.profile-quote').text

    # get bio
    result[:bio] = profile.css('div.bio-block p').text

    result
  end
end
