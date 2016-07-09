require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    page = Nokogiri::HTML(open(index_url)) 
    st_name = page.css('div.student-card').each {|n| students << {:name => n.css('a div.card-text-container h4').text, :location => n.css('a div.card-text-container p').text, :profile_url => "http://127.0.0.1:4000/" + n.css('a')[0]['href']}}
    # st_name.each {|s| students << {:name => s['h4'].text, :location => s['p'].text} }
    students
  end

  def self.scrape_profile_page(profile_url)
    scraped_student = {}
    page = Nokogiri::HTML(open(profile_url))
    # scraped_student[:name] = page.css('h1.profile-name').text
    # scraped_student[:location] = page.css('h2.profile-location').text   
    scraped_student[:profile_quote] = page.css('div.profile-quote').text
    scraped_student[:bio] = page.css('div.bio-content div.description-holder p').text
    page.css('div.social-icon-container a').each do |a|
      site = a['href']
      if site.match(/.*twitter.*/)
	scraped_student[:twitter] = site 
      elsif site.match(/.*linkedin.*/)
	scraped_student[:linkedin] = site
      elsif site.match(/.*github.*/)
	scraped_student[:github] = site
      else
	scraped_student[:blog] = site
      end
      # scraped_student[:blog] = page.css('div.social-icon-container a')[3]['href'] rescue nil
      # scraped_student[:github] = page.css('div.social-icon-container a')[2]['href'] rescue nil
      # scraped_student[:linkedin] = page.css('div.social-icon-container a')[1]['href'] rescue nil
      # scraped_student[:twitter] = page.css('div.social-icon-container a')[0]['href'] rescue nil 
    end
    scraped_student
  end

end

