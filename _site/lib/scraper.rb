require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  attr_accessor :get_page

  def self.get_page(url)
    result = open(url)
    page_doc = Nokogiri::HTML(result)
  end

  def self.get_page_part(page_doc, part)
    get_page(page_doc).css(part)
  end

  # returns an array of hashes
  def self.scrape_index_page(index_url)
    students = []
    get_page_part(index_url, "div.student-card").each do |student|
      # each hash represents a single student
      students << {
        :name => student.css("div.card-text-container h4").text,
        :location => student.css("div.card-text-container p").text,
        :profile_url => "http://127.0.0.1:4000/" + student.css("a").attribute("href").value
      }
    end
    # binding.pry
    students
  end

  def self.scrape_profile_page(profile_url)
    # define social sites
    social_sites = [
      "twitter", "linkedin", "github", "facebook" "youtube"
    ]
    # store social info
    social_info = {}
    # get all social links
    page_social_links = get_page_part(profile_url, "div.social-icon-container a")
    # map all social link values
    social_links = page_social_links.map {|links| links.attribute("href").value }
    # store the social links if matches found
    social_links.each do |link|
      site_name = link.match(/\b\w*\b\.com/).to_s.split(%r{\.\w*}).first
      if social_sites.include?(site_name)
        social_info[site_name.to_sym] = link
      else
        social_info[:blog] = link
      end
    end
    # store quote
    social_info[:profile_quote] = get_page_part(profile_url, "div.profile-quote").text
    # store bio
    social_info[:bio] = get_page_part(profile_url, "div.description-holder p").text
    social_info
  end

end

